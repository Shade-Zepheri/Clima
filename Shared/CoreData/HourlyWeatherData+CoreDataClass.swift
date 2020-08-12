//
//  HourlyWeatherData+CoreDataClass.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/12/20.
//
//

import Foundation
import CoreData

@objc(HourlyWeatherData)
public class HourlyWeatherData: NSManagedObject {
    convenience init(context: NSManagedObjectContext, entry: HourlyWeatherEntry) {
        self.init(context: context)
        self.timestamp = entry.dt
        self.temp = entry.temp
        self.feelsLike = entry.feels_like
        self.pressure = Int16(entry.pressure)
        self.humidity = Int16(entry.humidity)
        self.dewPoint = entry.dew_point
        self.clouds = Int16(entry.clouds)
        self.visibility = Int16(entry.visibility)
        self.windSpeed = entry.wind_speed
        self.windDeg = Int16(entry.wind_deg)
        self.pop = entry.pop
        
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
    
    func derivedEntry() -> HourlyWeatherEntry {
        let conditionData = weather?.array as! [ConditionData]
        let groups = conditionData.map {
            $0.derivedGroup()
        }

        return HourlyWeatherEntry(dt: timestamp!, temp: temp, feels_like: feelsLike, pressure: Int(pressure), humidity: Int(humidity), dew_point: dewPoint, clouds: Int(clouds), visibility: Int(visibility), wind_speed: windSpeed, wind_gust: windGust?.doubleValue, wind_deg: Int(windDeg), pop: pop, rain: rain?.derivedEntry(), snow: snow?.derivedEntry(), weather: groups)
    }
}
