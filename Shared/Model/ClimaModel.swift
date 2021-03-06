//
//  ClimaModel.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 7/21/20.
//

import Combine
import CoreData
import CoreLocation
import MapKit

class ClimaModel: NSObject, ObservableObject {
    @Published private(set) var currentCity = City.fallback
    @Published private(set) var savedCities = [City]()
    
    var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "lastUpdateDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastUpdateDate")
        }
    }

    private var cancellables = Set<AnyCancellable>()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()

        setupLocationMonitoring()
        loadSavedCities()
    }
}

// MARK: City Management

extension ClimaModel {
    func save(_ city: City) {
        // Append to property
        var newSavedCities = savedCities
        newSavedCities.append(city)
        savedCities = newSavedCities.sorted()
        
        PersistentContainer.shared.save([city])
    }
    
    func delete(_ city: City) {
        savedCities = savedCities.filter {
            $0.id != city.id
        }
        
        PersistentContainer.shared.delete(city)
    }
    
    func loadSavedCities() {
        PersistentContainer.shared.loadStoredCities()
            .map {
                $0.map {
                    $0.derivedCity()
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    self.updateSavedCities()
                }
            } receiveValue: { cities in
                self.savedCities = cities.sorted()
            }
            .store(in: &cancellables)
    }
    
    func updateSavedCities() {
        let lastRefresh = lastUpdate ?? .distantPast
        
        let now = Date()
        let interval = TimeInterval(30 * 60)
        
        guard !savedCities.isEmpty, now > (lastRefresh + interval) else {
            return
        }
        
        resetRequests()
        PersistentContainer.shared.deleteAll()
        
        update(cities: savedCities)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.lastUpdate = Date()
            } receiveValue: { cities in
                self.savedCities = cities.sorted()

                PersistentContainer.shared.save(cities)
            }
            .store(in: &cancellables)
    }
}

// MARK: Combine

extension ClimaModel {
    func resetRequests() {
        cancellables.forEach {
            $0.cancel()
        }
        
        cancellables = []
    }
    
    func placemark(for location: CLLocation) -> AnyPublisher<CLPlacemark?, ClimaError> {
        return Future() { promise in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    promise(.success(firstLocation))
                } else {
                    promise(.failure(.reverseGeocoding))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func createCity(for location: CLLocation) -> AnyPublisher<City, Never> {
        let weatherDataPubliser = OpenWeatherMapAPI.weatherData(for: location)
        let placemarkPublisher = placemark(for: location)
        
        return placemarkPublisher.zip(weatherDataPubliser)
            .map { placemark, data in
                City(placemark: placemark, data: data)
            }
            .replaceError(with: .fallback)
            .eraseToAnyPublisher()
    }
    
    func update(city: City) -> AnyPublisher<City, Never> {
        let location = city.location
        
        return OpenWeatherMapAPI.weatherData(for: location)
            .map {
                city.updated(with: $0)
            }
            .replaceError(with: .fallback)
            .eraseToAnyPublisher()
    }
    
    func update(cities: [City]) -> AnyPublisher<[City], Never> {
        let publishers = cities.map {
            update(city: $0)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
}

// MARK: Location

extension ClimaModel {
    func updateCurrentCity(with location: CLLocation) {
        createCity(for: location)
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentCity)
    }
    
    func primaryLocation(for completion: MKLocalSearchCompletion) -> AnyPublisher<CLLocation, ClimaError> {
        return Future() { promise in
            let request = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let response = response else {
                    promise(.failure(.forwardGeocoding))
                    return
                }
                
                if let location = response.mapItems[0].placemark.location {
                    promise(.success(location))
                } else {
                    promise(.failure(.forwardGeocoding))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func appendCity(from completion: MKLocalSearchCompletion) {
        primaryLocation(for: completion)
            .flatMap { location in
                self.createCity(for: location)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: { city in
                self.save(city)
            }
            .store(in: &cancellables)
    }
}

extension ClimaModel: CLLocationManagerDelegate {
    func setupLocationMonitoring() {
        #if os(iOS)
        locationManager.requestWhenInUseAuthorization()
        #else
        locationManager.requestAlwaysAuthorization()
        #endif
        
        locationManager.delegate = self
        #if os(iOS)
        locationManager.allowsBackgroundLocationUpdates = true
        #endif
        
        startLocationMonitoring()
    }
    
    func startLocationMonitoring() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            return
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopLocationMonitoring() {
        locationManager.stopMonitoringSignificantLocationChanges()
        currentCity = .locationDenied
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            stopLocationMonitoring()
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationMonitoring()
        case .notDetermined:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        
        updateCurrentCity(with: lastLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            stopLocationMonitoring()
        }
    }
}
