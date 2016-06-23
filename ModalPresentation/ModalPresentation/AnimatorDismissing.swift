////
////  AnimatorDismissing.swift
////  ModalPresentation
////
////  Created by Shreesha on 18/02/16.
////  Copyright © 2016 YML. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class AnimatorDismissing {
//
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//        return 0.5
//    }
//
//
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
//        let toViewControllre = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//        var finalFrameForVC = CGRectZero
//        var initialFrameForVC = CGRectZero
//
//        if let toViewControllre = toViewControllre {
//
//            finalFrameForVC = transitionContext.finalFrameForViewController(toViewControllre)
//            initialFrameForVC = transitionContext.initialFrameForViewController(toViewControllre)
//        }
//
//        toViewControllre?.view.userInteractionEnabled = false
//        fromViewController?.view.userInteractionEnabled = false
//
//        for view in transitionContext.containerView()!.subviews {
//            view.removeFromSuperview()
//        }
//        transitionContext.containerView()?.addSubview(toViewControllre!.view)
//
//
//
//        let snapShot = fromViewController?.view.snapshotViewAfterScreenUpdates(false)
//        fromViewController?.view.removeFromSuperview()
//        transitionContext.containerView()?.addSubview(snapShot!)
//        snapShot?.frame = fromViewController!.view.frame
//
//
//
//        transitionContext.containerView()?.addSubview(fromViewController!.view)
//        transitionContext.containerView()?.addSubview(fromViewController!.view)
//        transitionContext.containerView()?.bringSubviewToFront(toViewControllre!.view)
//
//
//        fromViewController?.view.alpha = 1.0
//        toViewControllre?.view.alpha = 0.0
//        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
//
//            snapShot?.frame = CGRectInset(fromViewController!.view.frame, fromViewController!.view.bounds.width / 2, fromViewController!.view.bounds.height / 2)
//            fromViewController?.view.alpha = 0.0
//            toViewControllre?.view.alpha = 1.0
//            }, completion: { (bool) -> Void in
//
//                transitionContext.finishInteractiveTransition()
//                transitionContext.completeTransition(!(transitionContext.transitionWasCancelled()))
//                print(transitionContext.transitionWasCancelled())
//                fromViewController?.view.userInteractionEnabled = true
//
//                toViewControllre?.view.userInteractionEnabled = true
//        })
//    }
//
//
//    func animationEnded(transitionCompleted: Bool) {
//        //        transitionContext = nil
//    }
//
//    override func updateInteractiveTransition(percentComplete: CGFloat) {
//        let transcon = transitionContext
//        if let transcon = transcon {
//
//            //            let fromViewController = transcon.viewControllerForKey(UITransitionContextFromViewControllerKey)
//            let toViewController = transcon.viewControllerForKey(UITransitionContextToViewControllerKey)
//            toViewController?.view.alpha = 1 - percentComplete
//        }
//    }
//
//
//    //    MARK: take the interactive into consideration
//
//    func userDidPan(gesture: UIPanGestureRecognizer) {
//        let location = gesture.locationInView(parentViewController?.view)
//        let velocity = gesture.velocityInView(parentViewController?.view)
//
//        if gesture.state == UIGestureRecognizerState.Began {
//            interactive = true
//
//        } else if gesture.state == UIGestureRecognizerState.Changed {
//            let ratio = location.x / CGRectGetWidth(parentViewController!.view.bounds)
//            self.updateInteractiveTransition(ratio)
//        }else if gesture.state == UIGestureRecognizerState.Ended {
//
//            if fabs(velocity.x) > 50.0 || fabs(velocity.y) > 50.0 {
//                finishInteractiveTransition()
//            } else {
//                cancelInteractiveTransition()
//            }
//        }
//    }
//    override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
//        self.transitionContext = transitionContext
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
//        let toViewControllre = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//
//        var frame = transitionContext.containerView()?.bounds
//
//        if presenting {
//            transitionContext.containerView()?.addSubview(fromViewController!.view)
//            transitionContext.containerView()?.addSubview(toViewControllre!.view)
//
//            frame?.origin.x -= CGRectGetWidth(transitionContext.containerView()!.bounds)
//        }else {
//            transitionContext.containerView()?.addSubview(toViewControllre!.view)
//            transitionContext.containerView()?.addSubview(fromViewController!.view)
//        }
//
//        toViewControllre?.view.frame = frame!
//    }
//
//
//
//    override func finishInteractiveTransition() {
//        let transcon = transitionContext
//        let fromViewController = transcon!.viewControllerForKey(UITransitionContextFromViewControllerKey)
//        let toViewControllre = transcon!.viewControllerForKey(UITransitionContextToViewControllerKey)
//
//        if presenting {
//            let endFrame = transcon?.containerView()?.bounds
//
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                toViewControllre?.view.frame = endFrame!
//                }, completion: { (bool) -> Void in
//                    transcon?.completeTransition(true)
//            })
//
//        }else  {
//
//            let frame = CGRectOffset(transcon!.containerView()!.bounds, CGRectGetWidth(transitionContext!.containerView()!.bounds), 0.0)
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                fromViewController?.view.frame = frame
//                }, completion: { (bool) -> Void in
//                    transcon?.completeTransition(true)
//            })
//        }
//    }
//
//    override func cancelInteractiveTransition() {
//        let transCon = transitionContext
//        let fromViewController = transCon!.viewControllerForKey(UITransitionContextFromViewControllerKey)
//        let toViewControllre = transCon!.viewControllerForKey(UITransitionContextToViewControllerKey)
//
//        if presenting {
//            let endFrame = CGRectOffset(transCon!.containerView()!.bounds, -CGRectGetWidth(transCon!.containerView()!.bounds), 0.0)
//
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                toViewControllre?.view.frame = endFrame
//                }, completion: { (bool) -> Void in
//                    transCon?.completeTransition(true)
//            })
//        }else {
//            let endFrame = transCon?.containerView()?.bounds
//            
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                fromViewController?.view.frame = endFrame!
//                
//                }, completion: { (bool) -> Void in
//                    transCon?.completeTransition(true)
//            })
//        }
//    }
//    
//}