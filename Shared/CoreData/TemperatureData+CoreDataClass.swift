//
//  TemperatureData+CoreDataClass.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/12/20.
//
//

import Foundation
import CoreData

@objc(TemperatureData)
public class TemperatureData: NSManagedObject {
    convenience init(context: NSManagedObjectContext, entry: DailyTemperatureEntry) {
        self.init(context: context)
        self.night = entry.night
        self.morning = entry.morn
        self.evening = entry.eve
        self.day = entry.day
        
        if let min = entry.min {
            self.min = NSNumber(value: min)
        }
        
        if let max = entry.max {
            self.max = NSNumber(value: max)
        }
    }
    
    func derivedEntry() -> DailyTemperatureEntry {
        return DailyTemperatureEntry(morn: morning, day: day, eve: evening, night: night, min: min?.doubleValue, max: max?.doubleValue)
    }
}
