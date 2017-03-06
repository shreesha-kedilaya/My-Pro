//
//  BookListViewModel.swift
//  Books Dairy
//
//  Created by Shreesha on 28/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import CoreData

class BookListViewModel{
    var user : User?
    var readList : [Book]?
    var wishList : [Book]?
    var allBooks : [Book]?
    var userBooks: [Book]?

    var currentBooks : [Book]?

    func fetchAllData(_ completion : @escaping ViewModelCompletion) {
        let context = PersistenceStack.sharedInstance.mainContext
        userBooks = user?.books?.allObjects as? [Book]
        context.perform {
            self.fetchAllBooks(context) {
                self.fetchReadList(context)
                self.fetchWishList(context)
                completion()
            }
        }
    }

    func fetchUser(_ completion : @escaping ViewModelCompletion) {
        let context = PersistenceStack.sharedInstance.mainContext
        let user : User? = context.executeTheFetchRequest(nil) { (request) in
            if let userId = self.user?.userId {
                request.predicate = NSPredicate(format: "userId == %@", userId)
            }
        }?.first
        context.perform {
            self.user = user
            completion()
        }
    }

    fileprivate func fetchReadList(_ context : NSManagedObjectContext) {

        readList = []
        let readingCategories : [BookCategory]? = context.executeTheFetchRequest(nil) {
            if let userId = self.user?.userId {
                $0.predicate = NSPredicate(format: "userId == %@ AND category == %d", userId, BookCategory.ReadingCategory.readList.rawValue)
            }
        }
        if let readingCategories = readingCategories {
            for category in readingCategories {
                if let book = category.book {
                    readList?.append(book)
                }
            }
        }

        let sortedArray = readList?.sorted(by: { (book1, book2) -> Bool in
            if let timestamp1 = book1.timeStamp as? Double, let timestamp2 = book2.timeStamp as? Double {
                return timestamp1 > timestamp2
            } else {
                return false
            }
        })

        readList = sortedArray
    }

    fileprivate func fetchWishList(_ context:NSManagedObjectContext) {

        wishList = []
        let readingCategories : [BookCategory]? = context.executeTheFetchRequest(nil) {
            if let userId = self.user?.userId {
                $0.predicate = NSPredicate(format: "userId == %@ AND category == %d", userId, BookCategory.ReadingCategory.wishList.rawValue)
            }
        }
        if let readingCategories = readingCategories {
            for category in readingCategories {
                if let book = category.book {
                    self.wishList?.append(book)
                }
            }
        }

        let sortedArray = wishList?.sorted(by: { (book1, book2) -> Bool in
            if let timestamp1 = book1.timeStamp as? Double, let timestamp2 = book2.timeStamp as? Double {
                return timestamp1 > timestamp2
            } else {
                return false
            }
        })
        wishList = sortedArray
    }

    fileprivate func fetchAllBooks(_ context: NSManagedObjectContext, completion : @escaping ViewModelCompletion) {
        let books : [Book]? = context.executeTheFetchRequest()
        let sortedArray = books?.sorted(by: { (book1, book2) -> Bool in
            if let timestamp1 = book1.timeStamp as? Double, let timestamp2 = book2.timeStamp as? Double {
                return timestamp1 > timestamp2
            } else {
                return false
            }
        })
        context.performAndWait { 
            self.allBooks = sortedArray
            completion()
        }
    }

    func addToReadList(_ book : Book, completion : @escaping ViewModelCompletion) {
        addBookToTypeOfCategoty(book, category: .readList) { 
            completion()
        }
    }

    func addToWishList(_ book:Book, completion : @escaping ViewModelCompletion){
        addBookToTypeOfCategoty(book, category: .wishList) { 
            completion()
        }
    }

    fileprivate func addBookToTypeOfCategoty(_ book : Book, category : BookCategory.ReadingCategory, completion : ViewModelCompletion) {

        let context = book.managedObjectContext
        var categoryObject : BookCategory? = context?.executeTheFetchRequest(nil) {
            if let userId = self.user?.userId , let bookId = book.bookId {
                $0.predicate = NSPredicate(format: "userId == %@ AND book.bookId == %@", userId, bookId)
            }
        }?.first

        if let categoryObject = categoryObject {
            categoryObject.book = book
            categoryObject.category = category.rawValue as NSNumber?
            categoryObject.userId = user?.userId
        } else {
            categoryObject = context?.newObject()
            categoryObject?.book = book
            categoryObject?.category = category.rawValue as NSNumber?
            categoryObject?.userId = user?.userId
        }

        context?.AsynchronouslySave {
            completion()
        }
    }
}
