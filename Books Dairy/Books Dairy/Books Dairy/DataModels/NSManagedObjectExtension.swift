//
//  NSManagedObject+extension.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import CoreData
import UIKit
extension NSManagedObject {
    class func entityClassName() -> String {
        let name = NSStringFromClass(self)
        if let className = name.componentsSeparatedByString(".").last{
            return className
        }
        return ""
    }

    convenience init(managedObjectContext: NSManagedObjectContext) {
        let eName = self.dynamicType.entityClassName()
        let entity = NSEntityDescription.entityForName(eName, inManagedObjectContext: managedObjectContext)
        if let entity = entity {
            self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        } else {
            fatalError("Dont have the entity name")
        }
    }
}
extension NSManagedObject {
    func addObject<T: AnyObject>(value: T, toSetWithKey key: String) {
        let set = self.mutableSetValueForKey(key)
        set.addObject(value)
    }

    func removeObject<T: AnyObject>(value: T, fromSetWithKey key: String) {
        let set = self.mutableSetValueForKey(key)
        set.removeObject(value)
    }
    static func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: entityClassName())
    }
}

extension NSManagedObjectContext {
    func newObject<T: NSManagedObject>() -> T? {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(T.entityClassName(), inManagedObjectContext: self) as? T
            else { fatalError("Invalid Core Data Model.") }
        return object
    }

    func executeTheFetchRequest<T: NSManagedObject>(error: NSErrorPointer = nil, builder: ((NSFetchRequest) -> ())? = nil) -> [T]? {
        let request = NSFetchRequest(entityName: T.entityClassName())
        request.returnsObjectsAsFaults = false
        builder?(request)

        var object : [T]?
        do {
            object = try executeFetchRequest(request) as? [T]

        } catch _ as NSError {
            object = nil
        } catch {
            object = nil
        }
        return object
    }

    private func saveData(completion : () -> Void) {
        do {
            try save()
            if let parentContext = parentContext {
                parentContext.saveData({
                    completion()
                })
            } else {
                completion()
            }

        }catch {
            completion()
            fatalError("Failed to save the context")
        }
    }

    func AsynchronouslySave(dataSaved : ViewModelCompletion) {
        performBlock {
            self.saveData{
                dataSaved()
            }
        }
    }
    func SynchronouslySave(dataSaved : ViewModelCompletion) {
        performBlockAndWait {

            self.saveData{
                dataSaved()
            }
        }
    }
}