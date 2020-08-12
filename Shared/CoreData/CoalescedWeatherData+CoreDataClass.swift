//
//  CoalescedWeatherData+CoreDataClass.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/12/20.
//
//

import Foundation
import CoreData

@objc(CoalescedWeatherData)
public class CoalescedWeatherData: NSManagedObject {
    convenience init(context: NSManagedObjectContext, response: WeatherResponse) {
        self.init(context: context)
        self.latitude = response.lat
        self.longitude = response.lon
        self.currentWeather = CurrentWeatherData(context: context, entry: response.current)
        
        let hourlyData = response.hourly.map {
            HourlyWeatherData(context: context, entry: $0)
        }
        self.hourlyWeather = NSOrderedSet(array: hourlyData)
        
        let dailyData = response.daily.map {
            DailyWeatherData(context: context, entry: $0)
        }
        self.dailyWeather = NSOrderedSet(array: dailyData)
    }
    
    func derivedData() -> WeatherResponse {
        let hourlyData = hourlyWeather?.array as! [HourlyWeatherData]
        let hourlyEntries = hourlyData.map {
            $0.derivedEntry()
        }
        
        let dailyData = dailyWeather?.array as! [DailyWeatherData]
        let dailyEntries = dailyData.map {
            $0.derivedEntry()
        }
        
        return WeatherResponse(lat: latitude, lon: longitude, timezone: "", timezone_offset: 0, current: currentWeather!.derivedEntry(), hourly: hourlyEntries, daily: dailyEntries)
    }
}
