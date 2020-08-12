//
//  CurrentWeatherData+CoreDataClass.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/12/20.
//
//

import Foundation
import CoreData

@objc(CurrentWeatherData)
public class CurrentWeatherData: NSManagedObject {
    convenience init(context: NSManagedObjectContext, entry: CurrentWeatherEntry) {
        self.init(context: context)
        self.timestamp = entry.dt
        self.sunrise = entry.sunrise
        self.sunset = entry.sunset
        self.temp = entry.temp
        self.feelsLike = entry.feels_like
        self.pressure = Int16(entry.pressure)
        self.humidity = Int16(entry.humidity)
        self.dewPoint = entry.dew_point
        self.clouds = Int16(entry.clouds)
        self.uvi = entry.uvi
        self.visibility = Int16(entry.visibility)
        self.windSpeed = entry.wind_speed
        self.windDeg = Int16(entry.wind_deg)
        
        if let windGust = entry.wind_gust {
            self.windGust = NSNumber(value: windGust)
        }
        
        if let rain = entry.rain {
            let rainData = PrecipitationData(context: context, entry: rain)
            self.rain = rainData
        }
        
        if let snow = entry.snow {
            let snowData = PrecipitationData(context: context, entry: snow)
            self.snow = snowData
        }
        
        let groups = entry.weather.map {
            ConditionData(context: context, group: $0)
        }
        self.weather = NSOrderedSet(array: groups)
    }
    
    func derivedEntry() -> CurrentWeatherEntry {
        let conditionData = weather?.array as! [ConditionData]
        let groups = conditionData.map {
            $0.derivedGroup()
        }
        
        return CurrentWeatherEntry(dt: timestamp!, sunrise: sunrise!, sunset: sunset!, temp: temp, feels_like: feelsLike, pressure: Int(pressure), humidity: Int(humidity), dew_point: dewPoint, clouds: Int(clouds), uvi: uvi, visibility: Int(visibility), wind_speed: windSpeed, wind_gust: windGust?.doubleValue, wind_deg: Int(windDeg), rain: rain?.derivedEntry(), snow: snow?.derivedEntry(), weather: groups)
    }
}
