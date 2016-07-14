//
//  BookAddingViewModel.swift
//  Books Dairy
//
//  Created by Shreesha on 28/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BookAddingViewModel {

    var book : Book?
    var user : User?

    func updateTheBook(name : String, authorName : String, category : Book.Category, details: String?, rating : Float?, update : Bool, completion : ViewModelCompletion) {
        let context = update ? self.book?.managedObjectContext : PersistenceStack.sharedInstance.createChildContext()

        let book : Book? = update ? self.book : context?.newObject()

        book?.category = category.rawValue

        let newRatingObject : Rating? = context?.newObject()
        let predicate = NSPredicate(format: "bookId == max(bookId)")
        let bookIDBook: Book? = PersistenceStack.sharedInstance.mainContext.executeTheFetchRequest(nil) { (request) in
            request.predicate = predicate
        }?.last

        let id = bookIDBook?.bookId as? Double
        var actualId = Double(0)
        if let id = id {

            actualId = update ? id : id + 1

        } else {

            actualId = 100

        }

        newRatingObject?.userId = user?.userId
        newRatingObject?.rating = rating

        book?.bookId = actualId
        if let newRatingObjects = book?.ratings?.allObjects {
            let newRatingSet = NSMutableSet(array: newRatingObjects)
            if let newRatingObject = newRatingObject {
                newRatingSet.addObject(newRatingObject)
            }
            book?.ratings = newRatingSet
        }

        if let details = details {
            book?.details = details
        }
        if let rating = rating {
            if let ratings = book?.ratings {
                let count = update ? ratings.count : 1

                var ratingSum = 0.f
                if let rating = newRatingObject?.rating {
                    ratingSum = CGFloat(rating)
                }
                for rating in ratings {
                    if let rating = rating.rating as? Int {
                        ratingSum += CGFloat(rating)
                    }
                }
                book?.averageRating = (ratingSum / count.f)
            } else {
                book?.averageRating = rating
            }
        }
        book?.name = name
        book?.authorId = getUserId()
        book?.authorName = authorName
        book?.timeStamp = NSDate().timeIntervalSince1970

        //WARNING: Still to implement

        context?.AsynchronouslySave {
            self.book = book
            let newUser : User? = context?.executeTheFetchRequest(nil, builder: { (request) in
                if let userId = self.user?.userId {
                    request.predicate = NSPredicate(format: "userId == %@", userId)
                }
            })?.first
            if let book = book {
                if let newBooks = newUser?.books {
                    let books = NSMutableSet(array: newBooks.allObjects)
                    books.addObject(book)
                    newUser?.books = books
                } else {
                    newUser?.books = NSSet(array: [book])
                }
            }
            if let newUser = newUser {
                self.user = newUser
            }
            context?.AsynchronouslySave({
                completion()
            })
        }
    }

    private func getUserId() -> NSNumber? {
        let context = PersistenceStack.sharedInstance.mainContext
        let user : User? = context.executeTheFetchRequest(nil) { (request) in
            if let userId = self.user?.userId {
                request.predicate = NSPredicate(format: "userId == %@", userId)
            }
            }?.first
        return user?.userId
    }
}
