//
//  Rating+CoreDataProperties.swift
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

extension Rating {

    @NSManaged var rating: NSNumber?
    @NSManaged var userId: NSNumber?
    @NSManaged var book: Book?

}
