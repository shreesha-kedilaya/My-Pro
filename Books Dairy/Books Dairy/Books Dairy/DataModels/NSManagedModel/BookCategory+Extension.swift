//
//  File.swift
//  Books Dairy
//
//  Created by Shreesha on 04/07/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation

//var readingListCategoty: ReadingCategory? {
//get {
//    if let readingCategory = category {
//        return ReadingCategory(rawValue: readingCategory as Int)
//    } else {
//        return ReadingCategory.None
//    }
//}
//set {
//    self.category = newValue?.rawValue
//}
//}
extension BookCategory {
    enum ReadingCategory : Int {
        case readList = 10
        case wishList = 20
        case none = 100

        func name() -> String {
            switch self {
            case .readList: return "Read List"

            case .wishList: return "Wish List"
                
            case .none: return "None"
            }
        }
    }
}
