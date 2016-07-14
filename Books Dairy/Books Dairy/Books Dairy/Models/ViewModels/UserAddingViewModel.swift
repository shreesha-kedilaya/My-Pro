//
//  UserAddingViewModel.swift
//  Books Dairy
//
//  Created by Shreesha on 29/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
typealias CoreDataCompletion = (() -> Void)
class UserAddingViewModel {
    var userName : String?
    var info :String?

    func addTheUserToCoreData(completion : CoreDataCompletion) {
        if let userName = userName , info = info {
            let context = PersistenceStack.sharedInstance.createChildContext()
            let user : User? = context.newObject()
            user?.name = userName
            user?.info = info
            user?.userId = 1
            context.performBlock({ 
                context.saveData({
                    completion()
                })
            })
        }
    }
}

struct User {
    var name
}