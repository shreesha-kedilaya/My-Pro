//
//  CalendarViewCell.swift
//  Calendar
//
//  Created by Shreesha on 12/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit



class CalendarViewCell: UICollectionViewCell {
    var dateButton : UIButton!

    fileprivate var cXConstraint : NSLayoutConstraint!
    fileprivate var cYConstraint : NSLayoutConstraint!
    fileprivate var widthConstraint : NSLayoutConstraint!
    fileprivate var equalConstraints : NSLayoutConstraint!

    var highlightedBackgroundColor = UIColor.brown
    var highlightedBackgroundColorForDateItem = UIColor.lightGray
    var unhighlightedColorForDateItem = UIColor.red
    var unhighlightedColor = UIColor.blue
    var roundLayer: CAShapeLayer!
    var halfRoundLayer: CAShapeLayer!
    var fullLayer: CAShapeLayer!

    var indexPath = IndexPath(item: 0, section: 0)

    var highlightedItem = false {
        didSet {
            hightlightAsDateItem(false, highlight: highlightedItem)
        }
    }
    var setAsCurrentDateItem = false {
        didSet{
            hightlightAsDateItem(true, highlight: setAsCurrentDateItem)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    init() {
        super.init(frame : CGRect.zero)
        sharedInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    fileprivate func sharedInit() {

        dateButton = UIButton()
        dateButton.titleLabel?.textColor = UIColor.white

        backgroundColor = UIColor.blue
        dateButton.backgroundColor = UIColor.clear
        dateButton.translatesAutoresizingMaskIntoConstraints = false

        for subview in subviews {
            subview.removeFromSuperview()
        }

        addSubviews()
        addConstraints()
        setupLayers()
    }

    fileprivate func hightlightAsDateItem(_ dateItem : Bool, highlight :Bool) {
        if highlight {
            backgroundColor = dateItem ? UIColor.red : (setAsCurrentDateItem ? highlightedBackgroundColorForDateItem : highlightedBackgroundColor)
        } else {
            backgroundColor = setAsCurrentDateItem ? unhighlightedColorForDateItem: unhighlightedColor
        }
    }

    override func draw(_ rect: CGRect) {
        roundLayer = CAShapeLayer()
        roundLayer.frame = bounds
        roundLayer.backgroundColor = UIColor.clear.cgColor
        roundLayer.fillColor = UIColor.yellow.cgColor

        halfRoundLayer = CAShapeLayer()
        halfRoundLayer.frame = bounds
        halfRoundLayer.backgroundColor = UIColor.clear.cgColor

        fullLayer = CAShapeLayer()
        fullLayer.frame = bounds
        fullLayer.backgroundColor = UIColor.clear.cgColor

        let lowestOne = frame.width > frame.height ? frame.height: frame.width

        let roundPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: lowestOne / 2, startAngle: 0, endAngle: M_PI.f * 2.f, clockwise: true)
        roundLayer.path = roundPath.cgPath
        layer.insertSublayer(roundLayer, at: 0)
    }

    func setupLayers() {

    }

    func highlightAsRound() {

    }

    func highlightAsHalfRound() {

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dateButton.titleLabel?.textAlignment = .center
    }

    fileprivate func addSubviews() {
        addSubview(dateButton)
    }

    fileprivate func addConstraints() {

        let lowestItem = frame.width > frame.height ? frame.height : frame.width

        if let cXConstraint = cXConstraint, let cYConstraint = cYConstraint , let widthConstraint = widthConstraint, let equalConstraints = equalConstraints {
            dateButton.removeConstraints([cXConstraint, cYConstraint, widthConstraint, equalConstraints])
        }

        cXConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: dateButton, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        cYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: dateButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)

        widthConstraint = NSLayoutConstraint(item: dateButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: lowestItem / 2)

        equalConstraints = NSLayoutConstraint(item: dateButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: lowestItem / 2)

        dateButton.addConstraints([widthConstraint, equalConstraints])

        addConstraints([cYConstraint,cXConstraint])
        print(dateButton.frame)
    }

}
