//
//  AnimatedTransitionDelegate.swift
//  ModalPresentation
//
//  Created by Shreesha on 06/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
import UIKit
protocol AnimatorTransitioningDelegate  : UIViewControllerAnimatedTransitioning{
    var isPositive : Bool! {get set}
}