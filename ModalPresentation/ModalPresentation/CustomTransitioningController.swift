//
//  CustomTransitioningController.swift
//  ModalPresentation
//
//  Created by Shreesha on 06/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import UIKit
enum Action : Int {
    case Push = 10
    case Pop
    case Present
    case Dismiss
}

protocol TransitionInteractionControllerDelegate : class {
    func nextViewControllerForInteractor(interactor : CustomTransitioningController) -> UIViewController
}
protocol CustomTransitioningController : class {

    var isInteractive : Bool! {get set}
    var action : Action! {get set}
    var shouldCompleteTransition : Bool! {get set}
    var nextViewControllerDelegate :TransitionInteractionControllerDelegate! {get set}
    func attachToViewController(viewController : UIViewController, withAction :Action)
}
