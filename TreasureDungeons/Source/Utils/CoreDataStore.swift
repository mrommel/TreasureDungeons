//
//  CoreDataStore.swift
//  TreasureDungeons
//
//  Created by Michael Rommel on 25.07.17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import Foundation

import CoreData

class CoreDataStore : NSObject {
    var persistentStoreCoordinator : NSPersistentStoreCoordinator!
    var managedObjectModel : NSManagedObjectModel!
    var managedObjectContext : NSManagedObjectContext!
    
    override init() {
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let domains = FileManager.SearchPathDomainMask.userDomainMask
        let directory = FileManager.SearchPathDirectory.documentDirectory
        
        let applicationDocumentsDirectory = FileManager.default.urls(for: directory, in: domains).first!
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        let storeURL = applicationDocumentsDirectory.appendingPathComponent("TreasureDungeons.sqlite")
        
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: "", at: storeURL, options: options)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext.undoManager = nil
        
        super.init()
    }
    
    /*func fetchEntriesWithPredicate(_ predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], completionBlock: (([ManagedTodoItem]) -> Void)!) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "TodoItem")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        managedObjectContext.perform {
            let queryResults = try? self.managedObjectContext.fetch(fetchRequest)
            let managedResults = queryResults! as! [ManagedTodoItem]
            completionBlock(managedResults)
        }
    }
    
    func newTodoItem() -> ManagedTodoItem {
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "TodoItem", into: managedObjectContext) as! ManagedTodoItem
        
        return newEntry
    }*/
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
}

typealias PlayerCompletionBlock = (_ player: Player?, _ error: Error?) -> Void

extension CoreDataStore {
    
    func fetchPlayer(completionHandler: @escaping PlayerCompletionBlock) {
        
        let context = self.managedObjectContext
        
        do {
            let players = try context!.fetch(Player.fetchRequest()) as? [Player]
            
            if players != nil && (players?.count)! > 0 {
                completionHandler(players?.first, nil)
            } else {
                // load default
                let player = Player(context: context!)
                player.reset()
                
                // Save the data to coredata
                self.save()
                
                completionHandler(player, nil)
            }
        } catch {
            print("Fetching failed - loading default")
            print("error during read player from db: \(error)")
            
            completionHandler(nil, error)
        }
    }
}
