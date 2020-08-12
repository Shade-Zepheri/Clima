//
//  PrecipitationData+CoreDataClass.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/12/20.
//
//

import Foundation
import CoreData

@objc(PrecipitationData)
public class PrecipitationData: NSManagedObject {
    convenience init(context: NSManagedObjectContext, entry: PrecipitationEntry) {
        self.init(context: context)
        self.oneHour = entry.oneHour
    }
    
    func derivedEntry() -> PrecipitationEntry {
        return PrecipitationEntry(oneHour: oneHour)
    }
}
