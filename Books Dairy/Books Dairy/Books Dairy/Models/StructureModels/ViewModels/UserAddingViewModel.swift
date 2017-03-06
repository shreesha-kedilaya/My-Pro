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

    func addTheUserToCoreData(_ name : String?, info : String?, completion : @escaping CoreDataCompletion) {
        if let userName = name , let info = info {
            let context = PersistenceStack.sharedInstance.createChildContext()
            let user : User? = context.newObject()

            user?.name = userName
            user?.info = info
            
            let predicate = NSPredicate(format: "userId == max(userId)")
            let userIdUser: User? = PersistenceStack.sharedInstance.mainContext.executeTheFetchRequest(nil) { (request) in
                request.predicate = predicate
                }?.last

            if let userIdUserId = userIdUser?.userId as? Double {
                user?.userId = userIdUserId + 1
            } else {
                user?.userId = 100
            }
            user?.timeStamp = Date().timeIntervalSince1970 as NSNumber?
            context.perform({ 
                context.AsynchronouslySave({ 
                    completion()
                })
            })
        }
    }
}
