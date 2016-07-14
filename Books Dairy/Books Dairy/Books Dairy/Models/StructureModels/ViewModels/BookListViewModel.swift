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
    var books : [Book]?
    var userBooks: [Book]?

    var currentBooks : [Book]?

    func fetchAllData(completion : ViewModelCompletion) {
        let context = PersistenceStack.sharedInstance.mainContext
        userBooks = user?.books?.allObjects as? [Book]
        context.performBlock {
            self.fetchAllBooks(context) {
                self.fetchReadList(context)
                self.fetchWishList(context)
                completion()
            }
        }
    }

    func fetchUser(completion : ViewModelCompletion) {
        let context = PersistenceStack.sharedInstance.mainContext
        let user : User? = context.executeTheFetchRequest(nil) { (request) in
            if let userId = self.user?.userId {
                request.predicate = NSPredicate(format: "userId == %@", userId)
            }
        }?.first
        context.performBlock {
            self.user = user
            completion()
        }
    }

    private func fetchReadList(context : NSManagedObjectContext) {

//        let readBooks = userBooks?.filter({ (book) -> Bool in
//            if let reading = book.readingListCategoty {
//                if reading == .ReadList {
//                    return true
//                } else {
//                    return false
//                }
//            } else {
//                return false
//            }
//        })

        self.readList = userBooks

        let sortedArray = readList?.sort({ (book1, book2) -> Bool in
            if let timestamp1 = book1.timeStamp as? Double, timestamp2 = book2.timeStamp as? Double {
                return timestamp1 > timestamp2
            } else {
                return false
            }
        })

        self.readList = sortedArray
    }

    private func fetchWishList(context:NSManagedObjectContext) {
//        let wishBooks = userBooks?.filter({ (book) -> Bool in
//            if let reading = book.readingListCategoty {
//                if reading == .WishList {
//                    return true
//                } else {
//                    return false
//                }
//            } else {
//                return false
//            }
//        })

        let wishCategory : [BookCategory]? = context.executeTheFetchRequest(nil) {
            if let userId = self.user?.userId {
                $0.predicate = NSPredicate(format: "userId == %@", userId)
            }
        }

        self.wishList = userBooks

        let sortedArray = wishList?.sort({ (book1, book2) -> Bool in
            if let timestamp1 = book1.timeStamp as? Double, timestamp2 = book2.timeStamp as? Double {
                return timestamp1 > timestamp2
            } else {
                return false
            }
        })

        self.wishList = sortedArray
    }

    private func fetchAllBooks(context: NSManagedObjectContext, completion : ViewModelCompletion) {
        let books : [Book]? = context.executeTheFetchRequest()
        let sortedArray = books?.sort({ (book1, book2) -> Bool in
            if let timestamp1 = book1.timeStamp as? Double, timestamp2 = book2.timeStamp as? Double {
                return timestamp1 > timestamp2
            } else {
                return false
            }
        })
        context.performBlockAndWait { 
            self.books = sortedArray
            completion()
        }
    }

    func getAllOwnedBooks() -> [Book]? {

        let ownedBooks = books?.filter({ (book) -> Bool in
            if book.authorId == self.user?.userId {
                return true
            } else {
                return false
            }
        })

        return ownedBooks
    }
    func addToReadList(book : Book, completion : ViewModelCompletion) {
        addBookToTypeOfCategoty(book, category: .ReadList) { 
            completion()
        }
    }

    func addToWishList(book:Book, completion : ViewModelCompletion){
        addBookToTypeOfCategoty(book, category: .WishList) { 
            completion()
        }
    }

    private func addBookToTypeOfCategoty(book : Book, category : BookCategory.ReadingCategory, completion : ViewModelCompletion) {

        let context = book.managedObjectContext
        var categoryObject : BookCategory? = context?.executeTheFetchRequest(nil) {
            if let userId = self.user?.userId , bookId = book.bookId {
                $0.predicate = NSPredicate(format: "userId == %@ AND book.bookId == %@", userId, bookId)
            }
        }?.first

        if let categoryObject = categoryObject {
            categoryObject.book = book
            categoryObject.category = category.rawValue
            categoryObject.userId = user?.userId
        } else {
            categoryObject = context?.newObject()
            categoryObject?.book = book
            categoryObject?.category = category.rawValue
            categoryObject?.userId = user?.userId
        }

        context?.AsynchronouslySave {
            completion()
        }
    }
}