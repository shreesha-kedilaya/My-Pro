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

    func fetchUsers(_ completion : @escaping ViewModelCompletion) {
        let context = PersistenceStack.sharedInstance.mainContext
        context.perform { 
            let usersData : [User]? = context.executeTheFetchRequest()
            self.users = usersData
            completion()
        }

    }

    func deleteTheUserAt(_ index : Int, completion : ViewModelCompletion) {
        let context = PersistenceStack.sharedInstance.mainContext
        let user = users?[index]
        if let user = user {
            context.delete(user)
            users?.remove(at: index)
            PersistenceStack.sharedInstance.save()
            completion()
        }
    }
}
