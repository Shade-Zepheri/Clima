//
//  ClimaModel.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 7/21/20.
//

import UIKit
import Combine
import CoreData
import CoreLocation
import MapKit

class ClimaModel: NSObject, ObservableObject {
    @Published var currentCity = City.fallbackCity
    @Published var savedCities = [City]()
    
    var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "lastUpdateDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastUpdateDate")
        }
    }

    private var willEnterForeground: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()

        willEnterForeground = NotificationCenter.default.publisher(for: UIScene.willEnterForegroundNotification)
            .sink { _ in
                print("willEnterForeground")
            }

        setupLocationMonitoring()
        loadSavedCities()
    }
}

// MARK: City Management

extension ClimaModel {
    func save(city: City) {
        // Append to property
        var newSavedCities = savedCities
        newSavedCities.append(city)
        savedCities = newSavedCities.sorted()
        
        PersistentContainer.shared.save([city])
    }
    
    func loadSavedCities() {
        PersistentContainer.shared.loadStoredCities()
            .map {
                $0.map {
                    $0.derivedCity()
                }
            }
            .flatMap { cities in
                self.updateCities(cities)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    self.lastUpdate = Date()
                }
            } receiveValue: { cities in
                self.savedCities = cities.sorted()
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
            .map { (placemark, data) in
                City(placemark: placemark, data: data)
            }
            .replaceError(with: .fallbackCity)
            .eraseToAnyPublisher()
    }
    
    func update(city: City) -> AnyPublisher<City, Never> {
        let location = city.location
        
        return OpenWeatherMapAPI.weatherData(for: location)
            .map { response in
                city.updated(with: response)
            }
            .replaceError(with: .fallbackCity)
            .eraseToAnyPublisher()
    }
    
    func updateCities(_ cities: [City]) -> AnyPublisher<[City], Never> {
        let publishers = cities.map {
            update(city: $0)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
}

// MARK: Backgrounding

//extension ClimaModel {
//    func registerBackgroundTasks() {
//        didEnterBackground = NotificationCenter.default.publisher(for: UIScene.didEnterBackgroundNotification)
//            .sink { _ in
//                self.scheduleAppRefresh()
//            }
//    }
//
//    func scheduleAppRefresh() {
//        let request = BGAppRefreshTaskRequest(identifier: "com.shade.clima.refresh")
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)
//
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("Couldn't schedule app refresh: \(error)")
//        }
//    }
//
//    func handleAppRefresh(task: BGAppRefreshTask) {
//        scheduleAppRefresh()
//
//        resetRequests()
//
//        let updateToken = updateSavedCities()
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                self.lastUpdate = Date()
//                task.setTaskCompleted(success: true)
//            } receiveValue: { cities in
//                self.savedCities = cities.sorted()
//            }
//
//        task.expirationHandler = {
//            updateToken.cancel()
//        }
//    }
//}

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
                    break
                case .finished:
                    break
                }
            } receiveValue: { city in
                self.save(city: city)
            }
            .store(in: &cancellables)
    }
}

extension ClimaModel: CLLocationManagerDelegate {
    func setupLocationMonitoring() {
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        
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
        switch manager.authorizationStatus() {
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
