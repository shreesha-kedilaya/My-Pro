//
//  UniqueTransitionData.swift
//  ModalPresentation
//
//  Created by Shreesha on 06/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import UIKit

class UniqueTransitionData : NSObject{

    var transitionAction  :Action?
    var fromViewController : AnyObject?
    var toViewController : AnyObject?

    init(action : Action?,fromViewController : AnyObject? , toViewController : AnyObject?){
        transitionAction = action
        self.fromViewController = fromViewController
        self.toViewController = toViewController
    }
}