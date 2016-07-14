//
//  Book+Extension.swift
//  Books Dairy
//
//  Created by Shreesha on 01/07/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation

//var readingListCategoty: ReadingCategory? {
//get {
//    if let readingCategory = readingCategory {
//        return ReadingCategory(rawValue: readingCategory)
//    } else {
//        return ReadingCategory
//            .None
//    }
//
//}
//set {
//    self.readingCategory = newValue?.rawValue
//}
//}

extension Book {
    enum Category : String {
        case ScienceFiction = "Science Fiction",
        Drama = "Drama",
        Mystery = "Mystery",
        Horror = "Horror",
        Romance = "Romance",
        Travel = "Travel",
        Health = "Health",
        Comics = "Comics",
        None = "No category"

        static let allItems = [Category.ScienceFiction, .Drama, .Mystery, .Horror, .Romance, .Travel, .Health, .Comics]
    }
}