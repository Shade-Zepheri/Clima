//
//  File.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/2/20.
//

import Combine
import CoreLocation

enum OpenWeatherMapAPI {
    static func request(for location: CLLocation) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/onecall"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "exclude", value: "minutely"),
            URLQueryItem(name: "appid", value: OpenWeatherMapKey)
        ]
        
        return components.url
    }
    
    static func weatherData(for location: CLLocation) -> AnyPublisher<WeatherResponse, ClimaError> {
        guard let url = request(for: location) else {
            return Fail(error: ClimaError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw ClimaError.statusCode
                }
                
                return element.data
            }
            .decode(type: WeatherResponse.self, decoder: decoder)
            .mapError {
                ClimaError.map($0)
            }
            .eraseToAnyPublisher()
    }
}
