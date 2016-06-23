
//
//  Animator.swift
//  ModalPresentation
//
//  Created by Shreesha on 19/01/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit
import CoreLocation

class Animator: UIPercentDrivenInteractiveTransition , UIViewControllerAnimatedTransitioning , UIViewControllerTransitioningDelegate {

    var presenting = true

    var imageView : UIImageView?

    var imageViewRect : CGRect?

    var interactive = false

    private var navigationController : UINavigationController?
    private var interactionHandler =  UIPercentDrivenInteractiveTransition()

    private weak var presentedViewController : UIViewController!
    private weak var mainViewController : UIViewController!

    init(mainViewController : UIViewController, presentedViewController : UIViewController ,presentWithImageView imageView: UIImageView, withRect rect : CGRect, dissmissWithImageView:UIImageView?) {// add indexOf the image in the current project and the delegate in the current project
        super.init()

        self.imageView = imageView
        imageViewRect = rect
        self.presentedViewController = presentedViewController
        self.mainViewController = mainViewController

        attachToViewController(presentedViewController)

    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return self
    }


    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }

    func attachToViewController(viewController : UIViewController) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(Animator.handelPan(_:)))
        presentedViewController.view.addGestureRecognizer(gesture)
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {


        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewControllre = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        if presenting {

            toViewControllre?.view.center = transitionContext.containerView()!.center

            let imageView = getTheImageView()

            imageView.frame = CGRect(x: 0.0, y: CGRectGetMinY(imageViewRect!) + 64, width: CGRectGetWidth(imageViewRect!), height: CGRectGetHeight(imageViewRect!))
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = self.imageView?.image

            toViewControllre?.view.alpha = 0.0

            transitionContext.containerView()?.addSubview(imageView)
            transitionContext.containerView()?.addSubview(toViewControllre!.view)
            transitionContext.containerView()?.bringSubviewToFront(imageView)

            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                if let view = toViewControllre?.view {
                    imageView.center = view.center
                }

                toViewControllre?.view.alpha = 1.0

                }, completion: { (bool) -> Void in

                    let success = !(transitionContext.transitionWasCancelled())

                    imageView.removeFromSuperview()

                    if (self.presenting && !success) || (!(self.presenting) && success) {
                        toViewControllre?.view?.removeFromSuperview()
                    }

                    transitionContext.completeTransition(true)
                    self.presenting  = false
            })

        } else {

            fromViewController?.view.alpha = 1.0
            let imageView = getTheImageView()

            transitionContext.containerView()?.addSubview(imageView)
            imageView.center = transitionContext.containerView()!.center
            var rect = imageViewRect
            var height = 0.f
            if let navigationController = toViewControllre?.navigationController {
                height = navigationController.navigationBar.frame.height
            } else if let navigationController = toViewControllre as? UINavigationController {
                height = navigationController.navigationBar.frame.height
            }
            rect?.origin.y = height + UIApplication.sharedApplication().statusBarFrame.size.height
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                if let rect = rect {
                    imageView.frame = rect
                }
                fromViewController?.view.alpha = 0.0
                }, completion: { (bool) -> Void in
                    if transitionContext.transitionWasCancelled() {
                        imageView.removeFromSuperview()
                    }

                    transitionContext.completeTransition(!(transitionContext.transitionWasCancelled()))
                    
            })
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

    func animationEnded(transitionCompleted: Bool) {
        presenting  = false
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? interactionHandler : nil
    }


//    MARK: take the interactive into consideration

    func handelPan(gesture: UIPanGestureRecognizer) {
        let location = gesture.locationInView(gesture.view)
        let velocity = gesture.velocityInView(gesture.view?.superview)

        if gesture.state == UIGestureRecognizerState.Began {

            interactive = true

            presentedViewController.dismissViewControllerAnimated(true, completion: nil)

        } else if gesture.state == UIGestureRecognizerState.Changed {
            let ratio = location.y / UIScreen.mainScreen().bounds.height
            interactionHandler.updateInteractiveTransition(ratio)
        }else if gesture.state == UIGestureRecognizerState.Ended {

            interactive = false

            if fabs(velocity.x) > 500.0 || fabs(velocity.y) > 500.0 {

                interactionHandler.finishInteractiveTransition()
            } else {
                interactionHandler.cancelInteractiveTransition()
            }
        }else {
            print(gesture.state)
            interactive = false
            interactionHandler.cancelInteractiveTransition()
        }
    }
}