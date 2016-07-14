//
//  User+CoreDataProperties.swift
//  Books Dairy
//
//  Created by Shreesha on 05/07/16.
//  Copyright © 2016 YML. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var author_rating: NSNumber?
    @NSManaged var info: String?
    @NSManaged var name: String?
    @NSManaged var timeStamp: NSNumber?
    @NSManaged var userId: NSNumber?
    @NSManaged var books: NSSet?

}
