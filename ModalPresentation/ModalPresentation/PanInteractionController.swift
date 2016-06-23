//
//  PanInteractionController.swift
//  ModalPresentation
//
//  Created by Shreesha on 06/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import UIKit
class PanInteractionController: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    var fromViewController : UIViewController!
    var gestureRecognizer : UIGestureRecognizer?
    var reverseGestureDirection : Bool!

    private var compSpeed : CGFloat {
        return 1-percentComplete
    }

    //MARK: protocol properties

    var isinteractive: Bool!
    var action: Action!
    var shouldCompleteTransition: Bool!
    var nextViewControllerDelegate: TransitionInteractionControllerDelegate!

    func attachToViewController(viewController : UIViewController, withAction :Action) {

    }

    func isGestureRecognizerPositive(gestureRecognizer : UIPanGestureRecognizer) -> Bool {
        print("You should override \(#function) funtion in subclass")
        return false
    }

    func swipeCompletionPercent() -> CGFloat {
        return 0.0
    }
    func translationPercentageWithPanGestureRecongizer(gestureRecognizer : UIPanGestureRecognizer) -> CGFloat {
        return 0.0
    }
    func translationWithPanGestureRecongizer(gestureRecognizer : UIPanGestureRecognizer) -> CGFloat {
        return 0.0
    }

    func handelPangesture(panGesture : UIPanGestureRecognizer) {

        let percent = translationWithPanGestureRecongizer(panGesture)
        let positiveDirection = reverseGestureDirection! ? !(isGestureRecognizerPositive(panGesture)) : isGestureRecognizerPositive(panGesture)

        switch panGesture.state {
        case .Began:
            isinteractive = true

            if let delegate = nextViewControllerDelegate where positiveDirection {

//                switch action! {
//                case .Present:
//                    fromViewController.presentViewController(delegate.nextViewControllerForInteractor(self), animated: true, completion: nil)
//                case .Push:
//                    fromViewController.navigationController?.pushViewController(delegate.nextViewControllerForInteractor(self), animated: true)
//                default :
//                    break
//                }
            }
            else {
                switch action! {
                case .Dismiss:
                    fromViewController.navigationController?.popViewControllerAnimated(true)
                case .Pop:
                    fromViewController.dismissViewControllerAnimated(true, completion: nil)
                default : break
                }
            }
        case .Changed:
            if isinteractive! {
                shouldCompleteTransition = (percent >= swipeCompletionPercent())
                updateInteractiveTransition(percent)
            }

        case .Cancelled :
            cancelInteractiveTransition()
        case .Ended :
            if !shouldCompleteTransition! {
                cancelInteractiveTransition()
            }else {
                finishInteractiveTransition()
            }
            isinteractive = false

        default :
            break
        }
    }

    private func panGesture () -> UIGestureRecognizer {
        if let gestureRecognizer = gestureRecognizer {
            return gestureRecognizer
        } else {
            gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(PanInteractionController.handelPangesture(_:)))
            //i know it will not be nil
            return gestureRecognizer!
        }
    }
}