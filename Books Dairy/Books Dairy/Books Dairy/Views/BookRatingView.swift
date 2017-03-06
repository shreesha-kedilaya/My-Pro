//
//  BookRatingView.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

protocol BookRatingViewDelegate : class {
    func bookRatingViewDidSelectRatingButtonsUptoIndex(_ ratingIndex : Int)
}

class BookRatingView: UIView {

    var ratingButtons : [UIButton]?
    var rangeOfRatings = 5

    var initialRatings = 0 {
        didSet {
            currentRating = initialRatings
            updateRatingButtonDidClickAtIndex(initialRatings)
            if let ratingButtons = ratingButtons {
                if initialRatings == 0 {
                    for i in 0..<rangeOfRatings {
                        ratingButtons[i].backgroundColor = UIColor.lightGray
                    }
                    firstButtonSelected = false
                }
            }
        }
    }
    var delegate: BookRatingViewDelegate?

    fileprivate let highlightedColor = UIColor(red: 255/255, green: 225/255, blue: 93/255, alpha: 1.0)

    fileprivate var firstButtonSelected = true
    fileprivate var currentRating = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        sharedInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    fileprivate func sharedInit() {
        backgroundColor = UIColor.clear
        addRatingButtons()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addRatingButtons()
    }

    fileprivate func addRatingButtons() {
        ratingButtons = []

        for view in subviews {
            if view.isKind(of: UIButton.self) {
                view.removeFromSuperview()
            }
        }

        firstButtonSelected = rangeOfRatings > 1
        for i in 0..<rangeOfRatings {
            let button = UIButton(frame: CGRect(x: 2 + i.f * ((frame.size.width) / rangeOfRatings.f), y: 3.f, width: ((frame.size.width)/5) - 2.f, height: (frame.size.height) - 6.f))
            button.backgroundColor = i > (initialRatings - 1) ? UIColor.lightGray : highlightedColor
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
            button.tag = i
            button.addTarget(self, action: #selector(BookRatingView.ratingButtonDidClick(_:)), for: .touchUpInside)
            addSubview(button)
            ratingButtons?.append(button)
        }
    }

    func ratingButtonDidClick(_ button : UIButton) {

        updateRatingButtonDidClickAtIndex(button.tag)
    }


    fileprivate func updateRatingButtonDidClickAtIndex(_ index : Int)  {

        currentRating = index + 1
        var ratingIndex = index + 1
        if let ratingButtons = ratingButtons {
            if index <= ratingButtons.count {
                if !firstButtonSelected && currentRating == 1 && index + 1 == currentRating{

                    ratingButtons[0].backgroundColor = highlightedColor
                    firstButtonSelected = true
                    ratingIndex = index + 1
                }else if currentRating == 1 && index + 1 == currentRating {
                    for i in 0..<rangeOfRatings {
                        ratingButtons[i].backgroundColor = UIColor.lightGray
                    }
                    firstButtonSelected = false
                    ratingIndex = 0
                } else {
                    for i in 0...index {
                        ratingButtons[i].backgroundColor = highlightedColor
                    }

                    for i in (index+1)..<rangeOfRatings {
                        ratingButtons[i].backgroundColor = UIColor.lightGray
                    }
                    firstButtonSelected = true
                    ratingIndex = index + 1
                }
            }
        }
        delegate?.bookRatingViewDidSelectRatingButtonsUptoIndex(ratingIndex)
    }
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
