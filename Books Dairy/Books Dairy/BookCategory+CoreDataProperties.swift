//
//  BookCategory+CoreDataProperties.swift
//  Books Dairy
//
//  Created by Shreesha on 18/08/16.
//  Copyright © 2016 YML. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BookCategory {

    @NSManaged var category: NSNumber?
    @NSManaged var userId: NSNumber?
    @NSManaged var book: Book?

}
