//
//  ConditionData+CoreDataClass.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/12/20.
//
//

import Foundation
import CoreData

@objc(ConditionData)
public class ConditionData: NSManagedObject {
    convenience init(context: NSManagedObjectContext, group: WeatherGroup) {
        self.init(context: context)
        self.summary = group.description
        self.main = group.main
        self.icon = group.icon
        self.id = Int16(group.id)
    }
    
    func derivedGroup() -> WeatherGroup {
        return WeatherGroup(id: Int(id), main: main!, description: summary!, icon: icon!)
    }
}
