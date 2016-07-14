//
//  Book+CoreDataProperties.swift
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

extension Book {

    @NSManaged var author_rating: NSNumber?
    @NSManaged var authorId: NSNumber?
    @NSManaged var authorName: String?
    @NSManaged var averageRating: NSNumber?
    @NSManaged var bookId: NSNumber?
    @NSManaged var category: String?
    @NSManaged var details: String?
    @NSManaged var name: String?
    @NSManaged var timeStamp: NSNumber?
    @NSManaged var categories: NSSet?
    @NSManaged var ratings: NSSet?
    @NSManaged var users: NSSet?

}
