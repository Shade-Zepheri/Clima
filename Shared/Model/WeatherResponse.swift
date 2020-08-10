//
//  WeatherResponse.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 7/22/20.
//

import Foundation

// MARK: Weather Response

struct WeatherResponse: Codable {
    var lat: Double
    var lon: Double
    
    var timezone: String
    var timezone_offset: Int
    
    var current: CurrentWeatherEntry
    var hourly: [HourlyWeatherEntry]
    var daily: [DailyWeatherEntry]
    
    static let fallback = WeatherResponse(lat: 0.0, lon: 0.0, timezone: "N/A", timezone_offset: 0, current: .fallback, hourly: [.fallback], daily: [.fallback])
    static let denied = WeatherResponse(lat: 0.0, lon: 0.0, timezone: "N/A", timezone_offset: 0, current: .denied, hourly: [.fallback], daily: [.fallback])
}

struct CurrentWeatherEntry: Codable {
    var dt: Int
    var sunrise: Int
    var sunset: Int
    
    var temp: Double
    var feels_like: Double
    
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    
    var clouds: Int
    var uvi: Double
    var visibility: Int
    var wind_speed: Double
    var wind_gust: Double?
    var wind_deg: Int
    
    var rain: PrecipitationEntry?
    var snow: PrecipitationEntry?
    var weather: [WeatherGroup]
    
    static let fallback = CurrentWeatherEntry(dt: 0, sunrise: 0, sunset: 0, temp: 0, feels_like: 0, pressure: 0, humidity: 0, dew_point: 0, clouds: 0, uvi: 0, visibility: 0, wind_speed: 0, wind_gust: nil, wind_deg: 0, rain: nil, snow: nil, weather: [.fallback])
    static let denied = CurrentWeatherEntry(dt: 0, sunrise: 0, sunset: 0, temp: 0, feels_like: 0, pressure: 0, humidity: 0, dew_point: 0, clouds: 0, uvi: 0, visibility: 0, wind_speed: 0, wind_gust: nil, wind_deg: 0, rain: nil, snow: nil, weather: [.denied])
}

struct HourlyWeatherEntry: Codable {
    var dt: Int
    
    var temp: Double
    var feels_like: Double
    
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    
    var clouds: Int
    var visibility: Int
    var wind_speed: Double
    var wind_gust: Double?
    var wind_deg: Int
    
    var pop: Double
    
    var rain: PrecipitationEntry?
    var snow: PrecipitationEntry?
    var weather: [WeatherGroup]
    
    static let fallback = HourlyWeatherEntry(dt: 0, temp: 0, feels_like: 0, pressure: 0, humidity: 0, dew_point: 0, clouds: 0, visibility: 0, wind_speed: 0, wind_gust: nil, wind_deg: 0, pop: 0.96, rain: nil, snow: nil, weather: [.fallback])
}

extension HourlyWeatherEntry: Identifiable {
    var id: Int {
        return dt
    }
    
    var timestamp: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter.timeDateFormatter
        return formatter.string(from: date)
    }
    
    var currentTemp: String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        
        let rawTemperature = Measurement<UnitTemperature>(value: temp, unit: .kelvin)
        return formatter.string(from: rawTemperature)
    }
}

struct DailyWeatherEntry: Codable {
    var dt: Int
    var sunrise: Int
    var sunset: Int
    
    var temp: DailyTemperatureEntry
    var feels_like: DailyTemperatureEntry
    
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    
    var clouds: Int
    var uvi: Double
    var visibility: Double?
    var wind_speed: Double
    var wind_gust: Double?
    var wind_deg: Int
    
    var pop: Double
    
    var rain: Double?
    var snow: Double?
    var weather: [WeatherGroup]
    
    static let fallback = DailyWeatherEntry(dt: 0, sunrise: 0, sunset: 0, temp: .fallback, feels_like: .fallback, pressure: 0, humidity: 0, dew_point: 0, clouds: 0, uvi: 0, visibility: 0, wind_speed: 0, wind_gust: nil, wind_deg: 0, pop: 0.96, rain: nil, snow: nil, weather: [.fallback])
}

struct PrecipitationEntry: Codable {
    var oneHour: Double
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct WeatherGroup: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
    static let fallback = WeatherGroup(id: 802, main: "N/A", description: "N/A", icon: "03n")
    static let denied = WeatherGroup(id: 802, main: "Unable to determine location", description: "Location Services disabled, please enable in order to view data for the current location", icon: "03n")
}

struct DailyTemperatureEntry: Codable {
    var morn: Double
    var day: Double
    var eve: Double
    var night: Double
    var min: Double?
    var max: Double?
    
    static let fallback = DailyTemperatureEntry(morn: 302.26, day: 302.26, eve: 302.26, night: 301.74, min: 301.74, max: 302.26)
}
