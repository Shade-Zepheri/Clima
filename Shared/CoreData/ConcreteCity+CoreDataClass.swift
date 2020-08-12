//
//  ConcreteCity+CoreDataClass.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/12/20.
//
//

import Foundation
import CoreData

@objc(ConcreteCity)
public class ConcreteCity: NSManagedObject {
    convenience init(context: NSManagedObjectContext, city: City) {
        self.init(context: context)
        self.id = city.id
        self.timestamp = city.timestamp
        self.lastRefresh = city.lastRefresh
        self.locality = city.locality
        self.province = city.province
        self.country = city.country
        self.weatherData = CoalescedWeatherData(context: context, response: city.weatherData)
    }
    
    func derivedCity() -> City {
        return City(id: id!, timestamp: timestamp!, lastRefresh: lastRefresh!, locality: locality!, province: province!, country: country!, weatherData: weatherData!.derivedData())
    }
}
