//
//  PersistentContainer.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/10/20.
//

import Foundation
import Combine
import CoreData

class PersistentContainer: NSPersistentContainer {
    static let shared: PersistentContainer = {
        let container = PersistentContainer(name: "Clima")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
            
            print("Successfully loaded persistent store at: \(description.url?.description ?? "nil")")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        
        return container
    }()
    
    override func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = super.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        return backgroundContext
    }
}

// MARK: Convenience Methods

extension PersistentContainer {
    func loadStoredCities() -> AnyPublisher<[ConcreteCity], ClimaError> {
        return Future() { promise in
            let allEntriesRequest: NSFetchRequest<ConcreteCity> = ConcreteCity.fetchRequest()
            allEntriesRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ConcreteCity.timestamp), ascending: false)]
            
            let context = self.newBackgroundContext()
            context.perform {
                do {
                    let fetchResult = try context.fetch(allEntriesRequest)
                    guard !fetchResult.isEmpty else {
                        promise(.failure(.noSavedCities))
                        return
                    }
                    
                    promise(.success(fetchResult))
                } catch {
                    promise(.failure(ClimaError.map(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(_ cities: [City]) {
        let context = newBackgroundContext()
        context.perform {
            do {
                _ = cities.map {
                    ConcreteCity(context: context, city: $0)
                }
                
                try context.save()
            } catch {
                print("Error adding entries to store: \(error)")
            }
        }
    }
    
    func delete(_ city: City) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ConcreteCity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", city.id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let context = newBackgroundContext()
        context.perform {
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Error deleting entry: \(error)")
            }
        }
    }
}
