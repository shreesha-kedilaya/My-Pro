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
        if let className = name.components(separatedBy: ".").last{
            return className
        }
        return ""
    }

    convenience init(managedObjectContext: NSManagedObjectContext) {
        let eName = type(of: self).entityClassName()
        let entity = NSEntityDescription.entity(forEntityName: eName, in: managedObjectContext)
        if let entity = entity {
            self.init(entity: entity, insertInto: managedObjectContext)
        } else {
            fatalError("Dont have the entity name")
        }
    }
}
extension NSManagedObject {
    func addObject<T: AnyObject>(_ value: T, toSetWithKey key: String) {
        let set = self.mutableSetValue(forKey: key)
        set.add(value)
    }

    func removeObject<T: AnyObject>(_ value: T, fromSetWithKey key: String) {
        let set = self.mutableSetValue(forKey: key)
        set.remove(value)
    }

    static func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: entityClassName())
    }

    static func fetchRequest() -> NSFetchRequest
}

extension NSManagedObjectContext {
    func newObject<T: NSManagedObject>() -> T? {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: T.entityClassName(), into: self) as? T
            else { fatalError("Invalid Core Data Model.") }
        return object
    }

    func executeTheFetchRequest<T: NSManagedObject>(_ error: NSErrorPointer? = nil, builder: ((NSFetchRequest) -> ())? = nil) -> [T]? {
        let request = NSFetchRequest(entityName: T.entityClassName())
        request.returnsObjectsAsFaults = false
        builder?(request)

        var object : [T]?
        do {
            object = try fetch(request) as? [T]

        } catch _ as NSError {
            object = nil
        } catch {
            object = nil
        }
        return object
    }

    fileprivate func saveData(_ completion : () -> Void) {
        do {
            try save()
            if let parentContext = parent {
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

    func AsynchronouslySave(_ dataSaved : @escaping ViewModelCompletion) {
        perform {
            self.saveData{
                dataSaved()
            }
        }
    }
    func SynchronouslySave(_ dataSaved : @escaping ViewModelCompletion) {
        performAndWait {

            self.saveData{
                dataSaved()
            }
        }
    }
}
