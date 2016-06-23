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

    private var cXConstraint : NSLayoutConstraint!
    private var cYConstraint : NSLayoutConstraint!
    private var widthConstraint : NSLayoutConstraint!
    private var heightConstraint : NSLayoutConstraint!

    var highlightedBackgroundColor = UIColor.brownColor()
    var highlightedBackgroundColorForDateItem = UIColor.lightGrayColor()
    var unhighlightedColorForDateItem = UIColor.redColor()
    var unhighlightedColor = UIColor.blueColor()

    var indexPath = NSIndexPath(forItem: 0, inSection: 0)

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
        super.init(frame : CGRectZero)
        sharedInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func hightlightAsDateItem(dateItem : Bool, highlight :Bool) {
        if highlight {
            dateButton.backgroundColor = dateItem ? UIColor.redColor() : (setAsCurrentDateItem ? highlightedBackgroundColorForDateItem : highlightedBackgroundColor)
        } else {
            dateButton.backgroundColor = setAsCurrentDateItem ? unhighlightedColorForDateItem: unhighlightedColor
        }
    }
    private func sharedInit() {

        dateButton = UIButton()
        dateButton.addTarget(self, action: #selector(CalendarViewCell.dateButtonDidClick(_:)), forControlEvents:.TouchUpInside)
        dateButton.titleLabel?.textColor = UIColor.whiteColor()

        backgroundColor = UIColor.blueColor()
        dateButton.frame = bounds
        dateButton.translatesAutoresizingMaskIntoConstraints = false

        for subview in subviews {
            subview.removeFromSuperview()
        }

        addSubviews()
        addConstraints()
    }

    func dateButtonDidClick(sender:UIButton) {

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dateButton.frame = bounds
        dateButton.titleLabel?.textAlignment = .Center
    }

    private func addSubviews() {
        addSubview(dateButton)
    }

    private func addConstraints() {

        if let dateButton = dateButton {
            if let _ = cXConstraint, _ = cYConstraint , _ = widthConstraint, _ = heightConstraint {
            } else {
                cXConstraint = NSLayoutConstraint(item: dateButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
                cYConstraint = NSLayoutConstraint(item: dateButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)

                widthConstraint = NSLayoutConstraint(item: dateButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: bounds.width)
                heightConstraint = NSLayoutConstraint(item: dateButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: bounds.height)

                dateButton.addConstraints([widthConstraint, heightConstraint])
                addConstraints([cYConstraint,cXConstraint])
            }
        }
    }
}
