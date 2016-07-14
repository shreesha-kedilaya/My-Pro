//
//  UserModel.swift
//  Books Dairy
//
//  Created by Shreesha on 28/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
typealias ViewModelCompletion = () -> Void

class UserViewModel {

    var users : [User]?

    func fetchUsers(completion : ViewModelCompletion) {
        let context = PersistenceStack.sharedInstance.mainContext
        context.performBlock { 
            let usersData : [User]? = context.executeTheFetchRequest()
            self.users = usersData
            completion()
        }

    }

    func deleteTheUserAt(index : Int, completion : ViewModelCompletion) {
        let context = PersistenceStack.sharedInstance.mainContext
        let user = users?[index]
        if let user = user {
            context.deleteObject(user)
            users?.removeAtIndex(index)
            PersistenceStack.sharedInstance.save()
            completion()
        }
    }
}