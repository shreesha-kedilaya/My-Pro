//
//  UserBookListViewModel.swift
//  Books Dairy
//
//  Created by Shreesha on 01/07/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
class UserBookListViewModel {
    var ownedBooks: [Book]?
    var user : User?

    func deleteBookAt(index : Int, completion : ViewModelCompletion) {

        let ownedBook = ownedBooks?[index]
        let context = PersistenceStack.sharedInstance.createChildContext()
        
        var predicate = NSPredicate()
        if let bookID = ownedBook?.bookId as? Double{
            predicate = NSPredicate(format: "bookId == %lf", bookID)
        }
        let books : [Book]? = context.executeTheFetchRequest(nil) { (request) in
            request.predicate = predicate
        }

        let book = books?.last

        context.performBlock {
            print(book)
            if let book = book {
                context.deleteObject(book)
                self.ownedBooks?.removeAtIndex(index)
                context.AsynchronouslySave{
                    completion()
                }
                
            }
        }
    }
}