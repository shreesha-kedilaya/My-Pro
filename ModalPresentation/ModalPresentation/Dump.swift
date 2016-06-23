//
//  Dump.swift
//  ModalPresentation
//
//  Created by Shreesha on 18/02/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
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

