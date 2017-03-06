//
//  PersistenceStack.swift
//  RealSimple
//
//  Created by Ramsundar Shandilya on 11/25/15.
//  Copyright © 2015 Y Media Labs. All rights reserved.
//

import Foundation
import CoreData

/*

                      THE STACK

                      ---------
                      | Store |
                      ---------
                          |
            -------------------------------
            | PersistenceStoreCoordinator |
            -------------------------------
                          |
                  ------------------
                  | PrivateContext |
                  ------------------
                          |
                   ---------------
                   | MainContext | <---- Single Source of truth
                   ---------------
                         /|\
                        / | \
                       /  |  \
                      /   |   \
                     /    |    \
                    /     |     \
                   /      |      \
                  /       |       \
                 /        |        \
                /         |         \
      *************  *************  *************
      | Child MOC |  | Child MOC |  | Child MOC |
      *************  *************  *************


*/

private let kModelName = "BooksDairy"

final class PersistenceStack {
    
    static let sharedInstance = PersistenceStack(modelName: kModelName)
    
    /** Main context for use in View Controllers, Fetch Results Controllers etc. */
    fileprivate(set) var mainContext: NSManagedObjectContext = {
        let context = PersistenceStack.createMainContext()
        return context
    }()
    
    /** Private context: Parent of main context. */
    fileprivate fileprivate(set) var privateContext: NSManagedObjectContext = {
        let context = PersistenceStack.createPrivateContext()
        return context
    }()
    
    
    fileprivate init(modelName: String) {
        buildStack(modelName)
    }
    
    fileprivate func buildStack(_ modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension:"momd") else {

            fatalError("Error loading model from bundle")
        }


        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {

            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        privateContext.persistentStoreCoordinator = coordinator
        
        mainContext.parent = privateContext
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async { () -> Void in
        let psc = self.privateContext.persistentStoreCoordinator
        
        let storeURL = self.storeURL()
        print(storeURL)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try psc?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {

            fatalError("Error migrating store: \(error)")
        }
        

        }
    }
    
    fileprivate func storeURL() -> URL? {
        let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let docURL = urls.last
        
        let storeURL = docURL?.appendingPathComponent("\(kModelName).sqlite")
        
        return storeURL
    }
    
    fileprivate static func createMainContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        return context
    }
    
    fileprivate static func createPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        return context
    }
    
    func save() {
        
        guard (self.mainContext.hasChanges || self.privateContext.hasChanges) else {
            return
        }
        
        mainContext.performAndWait { () -> Void in
            
            do {
                try self.mainContext.save()
                
                self.privateContext.perform({ () -> Void in
                    do {
                        try self.privateContext.save()
                    } catch {
                    }
                })
                
            } catch {

            }
        }
    }
    
    func createChildContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }
    
    //CAUTION: USE THIS METHOD WITH UTMOST CARE. Make it non-private only if required.
    fileprivate func reset() {
        let persistentStoreCoordinator = privateContext.persistentStoreCoordinator
        
        mainContext.reset()
        privateContext.reset()
        
        let stores = persistentStoreCoordinator?.persistentStores
        
        guard let persistentStores = stores else {
            return
        }
        
        for store in persistentStores {
            do {
                try persistentStoreCoordinator?.remove(store)
            } catch {
            }
        }
        
        //Remove SQLiteStore
        do {
            let storeURL = self.storeURL()
            try FileManager.default.removeItem(at: storeURL!) 
            
        } catch {
        }
        
        mainContext = PersistenceStack.createMainContext()
        privateContext = PersistenceStack.createPrivateContext()
        buildStack(kModelName)
    }
}
