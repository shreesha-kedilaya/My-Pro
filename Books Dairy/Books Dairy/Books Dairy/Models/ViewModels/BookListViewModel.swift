//
//  BookListViewModel.swift
//  Books Dairy
//
//  Created by Shreesha on 28/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation

class BookListViewModel{
    var user : User?
    var readList : [Book]?
    var wishList : [Book]?
    var books : [Book]?

    static let sharedInstance = BookListViewModel()


//    func updateTheData() {
//        let context = PersistenceStack.sharedInstance.createChildContext()
//        let user : [User]? = context.executeTheFetchRequest()
//        if let user = user {
//            self.user = user.first
//        }
//        let books : [Book]? = context.executeTheFetchRequest()
//        if let books = books {
//            self.books = books
//        }
//    }
}