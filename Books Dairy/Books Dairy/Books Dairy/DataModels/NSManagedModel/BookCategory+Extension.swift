//
//  File.swift
//  Books Dairy
//
//  Created by Shreesha on 04/07/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
//
//var readingListCategoty: ReadingCategory? {
//get {
//    if let readingCategory = category {
//        return ReadingCategory(rawValue: readingCategory)
//    } else {
//        return ReadingCategory.None
//    }
//
//}
//set {
//    self.category = newValue?.rawValue
//}
//}
extension BookCategory {
    enum ReadingCategory : Int {
        case ReadList = 10
        case WishList = 20
        case None = 100

        func name() -> String {
            switch self {
            case .ReadList: return "Read List"

            case .WishList: return "Wish List"
                
            case .None: return "None"
            }
        }
    }
}
