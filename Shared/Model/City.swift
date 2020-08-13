//
//  City.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 7/22/20.
//

import Foundation
import CoreLocation
import SwiftUI

struct City: Identifiable {
    var id = UUID()
    var timestamp = Date()
    var lastRefresh = Date()
    var cardColor = Color.random()

    let locality: String
    let province: String
    let country: String

    var weatherData: WeatherResponse
    
    func updated(with data: WeatherResponse) -> City {
        return City(id: id, timestamp: timestamp, lastRefresh: Date(), cardColor: cardColor, locality: locality, province: province, country: country, weatherData: data)
    }
}

extension City {
    init(placemark: CLPlacemark?, data: WeatherResponse) {
        locality = placemark?.locality ?? "N/A"
        province = placemark?.administrativeArea ?? "N/A"
        country = placemark?.country ?? "N/A"
        
        weatherData = data
    }
    
    static let fallbackCity = City(locality: "--", province: "--", country: "--", weatherData: .fallback)
    static let test = City(
        locality: "Houston",
        province: "Texas",
        country: "USA",
        weatherData: WeatherResponse(lat: 29.76, lon: -95.37, timezone: "America/Chicago", timezone_offset: -18000,
                                     current: CurrentWeatherEntry(dt: Date(timeIntervalSince1970: 1596513727), sunrise: Date(timeIntervalSince1970: 1596454946), sunset: Date(timeIntervalSince1970: 1596503563), temp: 302.26, feels_like: 304.67, pressure: 1015, humidity: 70, dew_point: 296.23, clouds: 40, uvi: 10.68, visibility: 10000, wind_speed: 4.1, wind_gust: nil, wind_deg: 200, rain: nil, snow: nil, weather: [WeatherGroup(id: 802, main: "Clouds", description: "scattered clouds", icon: "03n")]), hourly: [.fallback], daily: [.fallback])
    )
    
    static let locationDenied = City(locality: "--", province: "--", country: "--", weatherData: .denied)
    
    func isFallback() -> Bool {
        return locality == "--"
    }
}

// MARK: Convenience Methods

extension City {
    var location: CLLocation {
        return CLLocation(latitude: weatherData.lat, longitude: weatherData.lon)
    }
    
    var condition: String {
        return weatherData.current.weather[0].main
    }
    
    var currentTemp: String {
        if isFallback() {
            return "--º"
        } else {
            let formatter = MeasurementFormatter()
            formatter.unitStyle = .short
            formatter.numberFormatter.maximumFractionDigits = 0
            
            let rawTemperature = Measurement<UnitTemperature>(value: weatherData.current.temp, unit: .kelvin)
            return formatter.string(from: rawTemperature)
        }
    }
    
    var feelsLikeTemp: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        
        let rawTemperature = Measurement<UnitTemperature>(value: weatherData.current.feels_like, unit: .kelvin)
        return formatter.string(from: rawTemperature)
    }

    var pressure: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.numberFormatter.maximumFractionDigits = 1
        
        let rawPressure = Measurement<UnitPressure>(value: Double(weatherData.current.pressure), unit: .hectopascals)
        return formatter.string(from: rawPressure)
    }
    
    var humidity: Int {
        return weatherData.current.humidity
    }
    
    var dewPoint: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        
        let rawTemperature = Measurement<UnitTemperature>(value: weatherData.current.dew_point, unit: .kelvin)
        return formatter.string(from: rawTemperature)
    }
    
    var uvi: Double {
        return weatherData.current.uvi
    }
    
    var clouds: Int {
        return weatherData.current.clouds
    }
    
    var visibility: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.numberFormatter.maximumFractionDigits = 1
        
        let rawDistance = Measurement<UnitLength>(value: Double(weatherData.current.visibility), unit: .meters)
        return formatter.string(from: rawDistance)
    }
    
    var windSpeed: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.numberFormatter.maximumFractionDigits = 1
        
        let rawSpeed = Measurement<UnitSpeed>(value: weatherData.current.wind_speed, unit: .metersPerSecond)
        return formatter.string(from: rawSpeed)
    }
    
    var windGust: Double? {
        return weatherData.current.wind_gust
    }
    
    var windDegrees: Int {
        return weatherData.current.wind_deg
    }
    
    var weatherCode: String {
        return weatherData.current.weather[0].icon
    }
    
    var dailyHigh: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        
        let rawTemperature = Measurement<UnitTemperature>(value: weatherData.daily[0].temp.max!, unit: .kelvin)
        return formatter.string(from: rawTemperature)
    }
    
    var dailyLow: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        
        let rawTemperature = Measurement<UnitTemperature>(value: weatherData.daily[0].temp.min!, unit: .kelvin)
        return formatter.string(from: rawTemperature)
    }
    
    var sunriseTime: String {
        let formatter = DateFormatter.timeDateFormatter
        return formatter.string(from: weatherData.current.sunrise)
    }
    
    var sunsetTime: String {
        let formatter = DateFormatter.timeDateFormatter
        return formatter.string(from: weatherData.current.sunset)
    }
    
    var precipitationPercentage: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: NSNumber(value: weatherData.hourly[0].pop))!
    }
}

// MARK: Comparable & Hashable

extension City: Comparable {
    static func < (lhs: City, rhs: City) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
    static func <= (lhs: City, rhs: City) -> Bool {
        return lhs.timestamp <= rhs.timestamp
    }
    
    static func > (lhs: City, rhs: City) -> Bool {
        return lhs.timestamp > rhs.timestamp
    }
    
    static func >= (lhs: City, rhs: City) -> Bool {
        return lhs.timestamp >= rhs.timestamp
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
}

extension City: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
