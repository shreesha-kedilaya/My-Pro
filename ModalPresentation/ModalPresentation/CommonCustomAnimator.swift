//
//  CommonCustomAnimator.swift
//  ModalPresentation
//
//  Created by Shreesha on 19/02/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import UIKit

class CommonCustomAnimator :  UIPercentDrivenInteractiveTransition ,UIViewControllerAnimatedTransitioning{
    private var transitionContext : UIViewControllerContextTransitioning?

    var imageView : UIImageView?
    var imageViewRect : CGRect?

    private var fromViewController : UIViewController!
    private var toViewController : UIViewController!
    private var gesture : UIPanGestureRecognizer!

    private var kThresholfVelocity = 500.f

    init(fromVC: UIViewController, toVC : UIViewController, withImageView : UIImageView,  initialImageViewRect : CGRect) {
        fromViewController = fromVC
        toViewController = toVC
        imageView = withImageView
        imageViewRect = initialImageViewRect
    }

    weak var gestureTargetView : UIView? {
        willSet {

        }
        didSet {

        }
    }

    private override init() { super.init()}

    private func registerPanGesture() {
        unregisterPanGesture()

        gesture = UIPanGestureRecognizer(target: self, action: #selector(CommonCustomAnimator.handlePan(_:)))
        gesture!.delegate = self
        gesture!.maximumNumberOfTouches = 1
        toViewController.view.addGestureRecognizer(self.gesture!)
    }

    private func unregisterPanGesture() {
        if let _gesture = self.gesture {
            if let _view = _gesture.view {
                _view.removeGestureRecognizer(_gesture)
            }
            _gesture.delegate = nil
        }
        gesture = nil
    }
    func handlePan(sender : UIPanGestureRecognizer) {

        var window : UIWindow? = nil
        window = toViewController.view.window

        var location = sender.locationInView(window)

        var velocity = sender.velocityInView(window)


        if sender.state == .Began {

            self.toViewController.dismissViewControllerAnimated(true, completion: nil)

        } else if sender.state == .Changed {

            var percentComplete = 0.0.f
            if location.y > location.x {
                percentComplete = ((CGRectGetHeight(window!.frame)/2) - location.x) / (CGRectGetHeight(window!.frame)/2)
            } else {
                percentComplete = ((CGRectGetWidth(window!.frame)/2) - location.y) / (CGRectGetWidth(window!.frame)/2)
            }
            updateInteractiveTransition(1 - percentComplete)
            sender.setTranslation(CGPointZero, inView: window)
            
        } else if sender.state == .Ended {

//            let differenceY = fabs(CGRectGetMidY(view.frame) - (interactiveView.center.y) + kDefaultHeightFromLabel)
//            let differenceX = fabs(CGRectGetMidX(view.frame) - (interactiveView.center.x))
//            let shouldDismissY = differenceY > (UIScreen.mainScreen().bounds.height / 3)
//            let shouldDismissX = differenceX > (UIScreen.mainScreen().bounds.width / 3)
            if max(fabs(velocity.x) , fabs(velocity.y)) > kThresholfVelocity {
                finishInteractiveTransition()
//            }else if shouldDismissY || shouldDismissX {
//                dismissViewController()
            } else {
                cancelInteractiveTransition()
            }

        } else if sender.state == .Cancelled {

        }
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let toViewController = getToViewControllerForContext(transitionContext)
        let toView = getToViewForContext(transitionContext)
        let containerView = transitionContext.containerView()
        let containerFrame = containerView?.frame

        var toViewStartFrame = getStartFrameFor(transitionContext, viewController: toViewController)

        if let containerFrame = containerFrame {
            toViewStartFrame = containerFrame
        }

        if let toViewController = toViewController {

            containerView?.addSubview(toViewController.view)

            let imageView = getTheImageView()
            if let imageViewRect = imageViewRect {
                imageView.frame.origin.y = imageViewRect.origin.y
            }


            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.clipsToBounds = true

//            containerView?.addSubview(imageView)
//            containerView?.bringSubviewToFront(imageView)

            if let toViewStartFrame = toViewStartFrame {
                toView?.frame = toViewStartFrame
            }
            toView?.alpha = 0.0

            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in

                toView?.alpha = 1.0
//                if let containerView = containerView {
//                    imageView.center = containerView.center
//                }

                }) { (completed) -> Void in

//                    imageView.removeFromSuperview()

                    transitionContext.completeTransition(!(transitionContext.transitionWasCancelled()))
            }
        }
    }

    func getTheImageView() -> UIImageView {
        let imageView = UIImageView()
        let rect = imageViewRect
        imageView.image = self.imageView?.image

        if let rect = rect {
            imageView.frame = rect
        }
        return imageView
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }

    private func getFromViewControllerForContext(context : UIViewControllerContextTransitioning) -> UIViewController? {
        return context.viewControllerForKey(UITransitionContextFromViewControllerKey)
    }

    private func getToViewControllerForContext(context : UIViewControllerContextTransitioning) -> UIViewController? {
        return context.viewControllerForKey(UITransitionContextToViewControllerKey)
    }

    private func getFromViewForContext(context : UIViewControllerContextTransitioning) -> UIView? {
        return context.viewForKey(UITransitionContextFromViewKey)
    }

    private func getToViewForContext(context : UIViewControllerContextTransitioning) -> UIView? {
        return context.viewForKey(UITransitionContextToViewKey)
    }

    private func getStartFrameFor(context : UIViewControllerContextTransitioning , viewController : UIViewController?) -> CGRect? {
        if let viewController = viewController {
            return context.initialFrameForViewController(viewController)
        }else {
            return nil
        }
    }

    private func getEndFrameFor(context : UIViewControllerContextTransitioning , viewController : UIViewController?) -> CGRect? {
        if let viewController = viewController {
            return context.finalFrameForViewController(viewController)
        }else {
            return nil
        }

    }

    override func updateInteractiveTransition(percentComplete: CGFloat) {
        super.updateInteractiveTransition(percentComplete)
    }
}

extension CommonCustomAnimator : UIGestureRecognizerDelegate {

}
extension Int {
    var f: CGFloat {
        return CGFloat(self)
    }
}

extension Float {
    var f: CGFloat {
        return CGFloat(self)
    }
}

extension Double {
    var f: CGFloat {
        return CGFloat(self)
    }
}