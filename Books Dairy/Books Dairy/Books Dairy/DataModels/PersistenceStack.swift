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
    private(set) var mainContext: NSManagedObjectContext = {
        let context = PersistenceStack.createMainContext()
        return context
    }()
    
    /** Private context: Parent of main context. */
    private private(set) var privateContext: NSManagedObjectContext = {
        let context = PersistenceStack.createPrivateContext()
        return context
    }()
    
    
    private init(modelName: String) {
        buildStack(modelName)
    }
    
    private func buildStack(modelName: String) {
        guard let modelURL = NSBundle.mainBundle().URLForResource(modelName, withExtension:"momd") else {

            fatalError("Error loading model from bundle")
        }


        
        guard let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL) else {

            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        privateContext.persistentStoreCoordinator = coordinator
        
        mainContext.parentContext = privateContext
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
        let psc = self.privateContext.persistentStoreCoordinator
        
        let storeURL = self.storeURL()
        print(storeURL)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try psc?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch {

            fatalError("Error migrating store: \(error)")
        }
        

        }
    }
    
    private func storeURL() -> NSURL? {
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let docURL = urls.last
        
        let storeURL = docURL?.URLByAppendingPathComponent("\(kModelName).sqlite")
        
        return storeURL
    }
    
    private static func createMainContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        return context
    }
    
    private static func createPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        return context
    }
    
    func save() {
        
        guard (self.mainContext.hasChanges || self.privateContext.hasChanges) else {
            return
        }
        
        mainContext.performBlockAndWait { () -> Void in
            
            do {
                try self.mainContext.save()
                
                self.privateContext.performBlock({ () -> Void in
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
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        context.parentContext = mainContext
        return context
    }
    
    //CAUTION: USE THIS METHOD WITH UTMOST CARE. Make it non-private only if required.
    private func reset() {
        let persistentStoreCoordinator = privateContext.persistentStoreCoordinator
        
        mainContext.reset()
        privateContext.reset()
        
        let stores = persistentStoreCoordinator?.persistentStores
        
        guard let persistentStores = stores else {
            return
        }
        
        for store in persistentStores {
            do {
                try persistentStoreCoordinator?.removePersistentStore(store)
            } catch {
            }
        }
        
        //Remove SQLiteStore
        do {
            let storeURL = self.storeURL()
            try NSFileManager.defaultManager().removeItemAtURL(storeURL!) 
            
        } catch {
        }
        
        mainContext = PersistenceStack.createMainContext()
        privateContext = PersistenceStack.createPrivateContext()
        buildStack(kModelName)
    }
}