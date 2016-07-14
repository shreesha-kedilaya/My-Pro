//
//  BookCategory.swift
//  Books Dairy
//
//  Created by Shreesha on 05/07/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import CoreData


class BookCategory: NSManagedObject {

    var readingListCategoty: ReadingCategory? {
        get {
            if let readingCategory = category {
                return ReadingCategory(rawValue: readingCategory as Int)
            } else {
                return ReadingCategory.None
            }
        }
        set {
            self.category = newValue?.rawValue
        }
    }

}
