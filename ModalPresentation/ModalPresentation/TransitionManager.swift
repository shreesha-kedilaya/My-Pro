//
//  TransitionManager.swift
//  ModalPresentation
//
//  Created by Shreesha on 06/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import UIKit
let kRZTransitionActionCount = 5

class TransitionManager: NSObject, UIViewControllerTransitioningDelegate , UINavigationControllerDelegate, UITabBarDelegate{
    var defaultPushPopAnimationController: AnimatorTransitioningDelegate!
    var defaultPresentDismissAnimationController : AnimatorTransitioningDelegate!
    var defaultTabBarAnimationController : AnimatorTransitioningDelegate!
    private var animationControllers :[NSObject : AnyObject]?
    private var animationControllerDirectionOverrides :[NSObject : AnyObject]?
    private var interactionControllers : [NSObject : AnyObject]?
    static let sharedManager = TransitionManager()
    func setAnimationController(animationController : AnimatorTransitioningDelegate, fromViewController : AnyObject, action : Action) -> UniqueTransitionData? {
        return setAnimationController(animationController, fromViewController: fromViewController, toViewController: nil, action: action)
    }
    func setAnimationController(animationController: AnimatorTransitioningDelegate, fromViewController : AnyObject, toViewController : AnyObject? , action : Action) -> UniqueTransitionData? {
        var keyValue: UniqueTransitionData?
        for x in 10...(kRZTransitionActionCount+10){
            let actionRawValue = Action(rawValue:x)
            if let actionRawValue = actionRawValue {
                switch actionRawValue {
                case Action.Pop where actionRawValue != Action.Push :
                    if let toViewController = toViewController {
                        keyValue = UniqueTransitionData(action: actionRawValue, fromViewController: fromViewController, toViewController: toViewController)
                    }
                case Action.Dismiss where actionRawValue != Action.Present:
                    if let toViewController = toViewController {
                        keyValue = UniqueTransitionData(action: actionRawValue, fromViewController: fromViewController, toViewController: toViewController)
                    }
                default :
                    break
                }
                if var animationControllers = animationControllers {
                    if let keyValue = keyValue {
                        animationControllers[keyValue] = animationController
                    }
                } else {
                    if let keyValue = keyValue {
                        animationControllers = [keyValue : animationController]
                    }
                }
            }
        }
        return keyValue
    }
    func overrideAnimationDirection(override : Bool, withTransition : UniqueTransitionData) {
        guard var animationControllerDirectionOverrides = animationControllerDirectionOverrides else {
            self.animationControllerDirectionOverrides = [withTransition : override]
            return
        }
        animationControllerDirectionOverrides[withTransition] = override
    }
    func setInteractionController(animationController: AnimatorTransitioningDelegate, fromViewController : AnyObject, toViewController : AnyObject? , action : Action) -> UniqueTransitionData? {
        var keyValue : UniqueTransitionData?
        for x in 10...(kRZTransitionActionCount+10){
            let actionRawValue = Action(rawValue:x)
            if let actionRawValue = actionRawValue {
                switch actionRawValue {
                case Action.Pop where actionRawValue != Action.Push :
                    if let toViewController = toViewController {
                        keyValue = UniqueTransitionData(action: actionRawValue, fromViewController: fromViewController, toViewController: toViewController)
                    }

                case Action.Dismiss where actionRawValue != Action.Present:
                    if let toViewController = toViewController {
                        keyValue = UniqueTransitionData(action: actionRawValue, fromViewController: fromViewController, toViewController: toViewController)
                    }
                default :
                    break
                }
                if var animationControllers = animationControllers {
                    if let keyValue = keyValue {
                        animationControllers[keyValue] = animationController
                    }
                } else {
                    if let keyValue = keyValue {
                        animationControllers = [keyValue : animationController]
                    }
                }
            }
        }
        return keyValue
    }
    //MARK :- UIViewControllerTransitionDelegate 
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let keyValue = UniqueTransitionData(action: .Present, fromViewController: source, toViewController: presented)
        var animationController : AnimatorTransitioningDelegate?
        if let animationControllers = animationControllers{
            animationController = animationControllers[keyValue] as? AnimatorTransitioningDelegate
        }
        if animationController == nil {
            keyValue.toViewController = nil
            animationController = animationControllers?[keyValue] as? AnimatorTransitioningDelegate
        }
        if animationController == nil {
            animationController = defaultTabBarAnimationController
        }
        if let animationController = animationController {

            if !(animationControllerDirectionOverrides![keyValue] as! Bool) {
                animationController.isPositive = true
            }
        }

        return animationController
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let keyValue = UniqueTransitionData(action: .Dismiss, fromViewController: dismissed, toViewController: nil)
        var animationController : AnimatorTransitioningDelegate?

        let presentingViewController = dismissed.presentingViewController
        if let presentingViewController = presentingViewController {
            if presentingViewController.isKindOfClass(UINavigationController) {
                let childVC = presentingViewController.childViewControllers.last
                if let childVC = childVC {
                    keyValue.toViewController = childVC
                    if let animationControllers = animationControllers {
                        animationController = animationControllers[keyValue] as? AnimatorTransitioningDelegate
                        if animationController == nil {
                            keyValue.toViewController = nil
                            animationController = animationControllers[keyValue] as? AnimatorTransitioningDelegate
                        }
                        if animationController == nil {
                            keyValue.toViewController = childVC
                            keyValue.fromViewController = nil
                            animationController = animationControllers[keyValue] as? AnimatorTransitioningDelegate
                        }
                    }
                }
            }
        }

        if animationController == nil {
            keyValue.toViewController = nil
            keyValue.fromViewController = dismissed
            if let animationControllers = animationControllers {
                animationController = animationControllers[keyValue] as? AnimatorTransitioningDelegate
            }
        }
        if animationController == nil {
            animationController = defaultPresentDismissAnimationController
        }

        if let animationController = animationController {
            if !(animationControllerDirectionOverrides![keyValue] as! Bool){
                animationController.isPositive = false
            }
        }

        return animationController
    }

    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        var returnInteraction : AnyObject? = nil
        if let animationControllers = animationControllers {
            for (_, object) in animationControllers.enumerate() {
                let animationController = object.1 as? AnimatorTransitioningDelegate
                let keyValue = object.0 as? UniqueTransitionData

                if let keyValue = keyValue , animationController = animationController{
                    if animator.isEqual(animationController) && (keyValue.transitionAction == .Present) {
                        if let interactionControllers = interactionControllers {
                            var interactionControllerCombined = interactionControllers[keyValue] as? CustomTransitioningController
                            if interactionControllerCombined == nil {
                                keyValue.toViewController = nil
                                interactionControllerCombined = interactionControllers[keyValue] as? CustomTransitioningController
                            }

                            if let interactionControllerCombined = interactionControllerCombined where interactionControllerCombined.isInteractive! {
                                returnInteraction = interactionControllerCombined
                                break
                            }
                        }
                    }
                }
            }
        }
        if let returnInteraction = returnInteraction {
            return (returnInteraction as! UIViewControllerInteractiveTransitioning)
        } else {
            return nil
        }
    }
}