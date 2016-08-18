//
//  CropView.swift
//  Calendar
//
//  Created by Shreesha on 20/07/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class CropView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()

        let path = UIBezierPath()
        UIColor.greenColor().setFill()
        path.moveToPoint(CGPointZero)
        path.moveToPoint(CGPoint(x: 250, y: 0))
        path.lineWidth = 3.0
        path.fill()
        path.stroke()

    }
}
