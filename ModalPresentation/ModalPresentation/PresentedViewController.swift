//
//  PresentedViewController.swift
//  ModalPresentation
//
//  Created by Shreesha on 19/01/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

protocol PresentedViewControllerDelegate : class {
    func presentedViewControllerDismissed(viewController : PresentedViewController)
}
class PresentedViewController: UIViewController,UIViewControllerTransitioningDelegate {

    @IBOutlet weak var imageView: UIImageView!

    var image : UIImage?
    var finalFrameForImageView : CGRect?

    private var panGesture : UIPanGestureRecognizer!

    private var interactive = false

    private var interactiveView : UIView?
    private var interactiveImageView : UIImageView?

    weak var delegate : PresentedViewControllerDelegate?

    //FIXME:

    private let kThresholfVelocity = CGFloat(400)

    private var initialRectBeforePanning = CGRectZero

    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

//        panGesture = UIPanGestureRecognizer(target: self, action: "handelPan:")

//        view.addGestureRecognizer(panGesture)
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        imageView.image = image

    }

    deinit {
//        view.removeGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func done(sender: AnyObject) {
//        view.alpha = 1.0

//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.view.alpha = 0.0
//            }) { (completed) -> Void in
                dismissViewControllerAnimated(true, completion: nil)
//        }
    }

//    func handelPan(sender: UIPanGestureRecognizer) {
//        let velocity = sender.velocityInView(view)
//        switch sender.state {
//        case .Began :
//            interactive = true
//            startInteractiveTransition(imageView)
//        case .Changed :
//            if interactive {
//                moveTheInteractiveViewWith(sender)
//                updateInteractiveTransition()
//            }
//        case .Ended :
//
//            print(velocity)
//            if let interactiveView = interactiveView {
//
//                let differenceY = CGRectGetMidY(view.frame) - (interactiveView.center.y)
//                let differenceX = CGRectGetMidX(view.frame) - (interactiveView.center.x)
//                let shouldDismissY = differenceY > (UIScreen.mainScreen().bounds.height / 2)
//                let shouldDismissX = differenceX > (UIScreen.mainScreen().bounds.width / 2)
//                if max(fabs(velocity.x) , fabs(velocity.y)) > kThresholfVelocity {
//
//                    dismissViewController()
//
//                }else if shouldDismissY || shouldDismissX {
//                    dismissViewController()
//
//                } else {
//                    cancellIneractiveTransition()
//                }
//            }
//        case .Failed, .Cancelled :
//            cancellIneractiveTransition()
//            break
//        default :
//            break
//        }
//    }
//
//    private func updateInteractiveTransition() {
//        if let interactiveView = interactiveView {
//            let differenceY = fabs(CGRectGetMidY(view.frame) - interactiveView.center.y)
//            let differenceX = fabs(CGRectGetMidX(view.frame) - interactiveView.center.x)
//            let percent =  max(differenceY / (UIScreen.mainScreen().bounds.height / 2), differenceX / (UIScreen.mainScreen().bounds.width / 2))
//            view.alpha = 1 - percent
//            interactiveView.alpha = 1.0
//        }
//
//    }
//
//    private func startInteractiveTransition(withImageView : UIImageView) {
//        imageView.hidden = true
//        setupInteractiveTransitionViews()
//    }
//
//    private func setupInteractiveTransitionViews() {
//
//        interactiveView = UIView(frame: view.frame)
//        interactiveImageView = UIImageView()
//
//        interactiveImageView?.frame = imageView.frame
//        interactiveImageView?.center = interactiveView!.center
//        interactiveImageView?.image = imageView.image
//        interactiveImageView?.contentMode = UIViewContentMode.ScaleAspectFit
//
//        interactiveView?.clipsToBounds = false
//        interactiveView?.backgroundColor = UIColor.clearColor()
//
//        if let interactiveView = interactiveView {
//            UIApplication.sharedApplication().keyWindow?.addSubview(interactiveView)
//        }
//
//        if let interactiveImageView = interactiveImageView {
//            interactiveView?.addSubview(interactiveImageView)
//        }
//    }
//
//    private func moveTheInteractiveViewWith(gesture:UIPanGestureRecognizer) {
//
//        let traslation = gesture.translationInView(view)
//        if let interactiveView = interactiveView {
//            interactiveView.center = CGPoint(x: interactiveView.center.x + traslation.x, y: interactiveView.center.y + traslation.y)
//        }
//        gesture.setTranslation(CGPointZero, inView: view)
//    }
//
//    private func dismissViewController() {
//
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.moveTheInteractiveViewToFinalFrame()
//            self.view.alpha = 0.0
//            }) { (completed) -> Void in
//                self.setupForDismissAndCancell()
//                self.delegate?.presentedViewControllerDismissed(self)
//                self.dismissViewControllerAnimated(false, completion: nil)
//        }
//    }
//
//    private func cancellIneractiveTransition() {
//
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.interactiveView?.center = self.view.center
//            self.view.alpha = 1.0
//            }) { (completed) -> Void in
//
//                self.setupForDismissAndCancell()
//        }
//    }
//
//    private func setupForDismissAndCancell() {
//
//        interactive = false
//        imageView.hidden = false
//
//        interactiveImageView?.hidden = true
//        interactiveView?.hidden = true
//        interactiveImageView?.removeFromSuperview()
//        interactiveView?.removeFromSuperview()
//        interactiveImageView = nil
//        interactiveView = nil
//    }
//
//    private func moveTheInteractiveViewToFinalFrame() {
//        if let finalFrameForImageView = finalFrameForImageView {
//            interactiveView?.center = CGPoint(x: CGRectGetMidX(finalFrameForImageView), y: CGRectGetMidY(finalFrameForImageView))
//        }
//    }
}
