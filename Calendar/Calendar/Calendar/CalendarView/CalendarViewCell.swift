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
    fileprivate var heightConstraint : NSLayoutConstraint!

    var highlightedBackgroundColor = UIColor.brown
    var highlightedBackgroundColorForDateItem = UIColor.lightGray
    var unhighlightedColorForDateItem = UIColor.red
    var unhighlightedColor = UIColor.blue

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

    fileprivate func hightlightAsDateItem(_ dateItem : Bool, highlight :Bool) {
        if highlight {
            dateButton.backgroundColor = dateItem ? UIColor.red : (setAsCurrentDateItem ? highlightedBackgroundColorForDateItem : highlightedBackgroundColor)
        } else {
            dateButton.backgroundColor = setAsCurrentDateItem ? unhighlightedColorForDateItem: unhighlightedColor
        }
    }
    fileprivate func sharedInit() {

        dateButton = UIButton()
        dateButton.addTarget(self, action: #selector(CalendarViewCell.dateButtonDidClick(_:)), for:.touchUpInside)
        dateButton.titleLabel?.textColor = UIColor.white

        backgroundColor = UIColor.blue
        dateButton.frame = bounds
        dateButton.translatesAutoresizingMaskIntoConstraints = false

        for subview in subviews {
            subview.removeFromSuperview()
        }

        addSubviews()
        addConstraints()
    }

    func dateButtonDidClick(_ sender:UIButton) {

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dateButton.frame = bounds
        dateButton.titleLabel?.textAlignment = .center
    }

    fileprivate func addSubviews() {
        addSubview(dateButton)
    }

    fileprivate func addConstraints() {

        if let dateButton = dateButton {
            if let _ = cXConstraint, let _ = cYConstraint , let _ = widthConstraint, let _ = heightConstraint {
            } else {
                cXConstraint = NSLayoutConstraint(item: dateButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                cYConstraint = NSLayoutConstraint(item: dateButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)

                widthConstraint = NSLayoutConstraint(item: dateButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: bounds.width)
                heightConstraint = NSLayoutConstraint(item: dateButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: bounds.height)

                dateButton.addConstraints([widthConstraint, heightConstraint])
                addConstraints([cYConstraint,cXConstraint])
            }
        }
    }
}
