//
//  DailyWeatherData+CoreDataClass.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/12/20.
//
//

import Foundation
import CoreData

@objc(DailyWeatherData)
public class DailyWeatherData: NSManagedObject {
    convenience init(context: NSManagedObjectContext, entry: DailyWeatherEntry) {
        self.init(context: context)
        self.timestamp = entry.dt
        self.sunrise = entry.sunrise
        self.sunset = entry.sunset
        self.temp = TemperatureData(context: context, entry: entry.temp)
        self.feelsLike = TemperatureData(context: context, entry: entry.feels_like)
        self.pressure = Int16(entry.pressure)
        self.humidity = Int16(entry.humidity)
        self.dewPoint = entry.dew_point
        self.clouds = Int16(entry.clouds)
        self.uvi = entry.uvi
        self.windSpeed = entry.wind_speed
        self.windDeg = Int16(entry.wind_deg)
        self.pop = entry.pop
        
        if let windGust = entry.wind_gust {
            self.windGust = NSNumber(value: windGust)
        }
        
        if let visibility = entry.visibility {
            self.visibility = NSNumber(value: visibility)
        }
        
        if let rain = entry.rain {
            self.rain = NSNumber(value: rain)
        }
        
        if let snow = entry.snow {
            self.snow = NSNumber(value: snow)
        }
        
        let groups = entry.weather.map {
            ConditionData(context: context, group: $0)
        }
        self.weather = NSOrderedSet(array: groups)
    }
    
    func derivedEntry() -> DailyWeatherEntry {
        let conditionData = weather?.array as! [ConditionData]
        let groups = conditionData.map {
            $0.derivedGroup()
        }

        return DailyWeatherEntry(dt: timestamp!, sunrise: sunrise!, sunset: sunset!, temp: temp!.derivedEntry(), feels_like: feelsLike!.derivedEntry(), pressure: Int(pressure), humidity: Int(humidity), dew_point: dewPoint, clouds: Int(clouds), uvi: uvi, visibility: visibility?.doubleValue, wind_speed: windSpeed, wind_gust: windGust?.doubleValue, wind_deg: Int(windDeg), pop: pop, rain: rain?.doubleValue, snow: snow?.doubleValue, weather: groups)
    }
}
