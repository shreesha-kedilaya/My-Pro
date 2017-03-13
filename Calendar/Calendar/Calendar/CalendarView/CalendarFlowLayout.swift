//
//  CalendarFlowLayout.swift
//  Calendar
//
//  Created by Shreesha on 12/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class CalendarFlowLayout: UICollectionViewFlowLayout {

    fileprivate var collectionViewAttributes = [String : UICollectionViewLayoutAttributes]()
    fileprivate let kCellsVisibleToTheUser = 3

    var presentingMonth = 0
    var presentingYear = 0
    var currentIterationIndex = 0

    override func prepare() {
        super.prepare()

        applyAttributes()
    }

    override var collectionViewContentSize : CGSize {
        if let collectionView = collectionView {
            return CGSize(width: collectionView.numberOfSections.f * collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else {
            return CGSize.zero
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)

        var filteredAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {
            for section in 0..<collectionView.numberOfSections  {
                for item in 0..<collectionView.numberOfItems(inSection: section) {
                    
                    if rect.intersects(collectionViewAttributes[layoutKeyForItemAtIndexPath(IndexPath(item: item, section: section))]!.frame) {
                        filteredAttributes.append(collectionViewAttributes[layoutKeyForItemAtIndexPath(IndexPath(item: item, section: section))]!)
                    }
                }
            }
        } else {
            return nil
        }

        return filteredAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        let key = layoutKeyForItemAtIndexPath(indexPath)
        return collectionViewAttributes[key]
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        super.shouldInvalidateLayout(forBoundsChange: newBounds)

        if let collectionView = collectionView {
            return !(newBounds.size.equalTo(collectionView.frame.size))
        }else {
            return false
        }
    }

    fileprivate func applyAttributes() {

        collectionViewAttributes.removeAll()

        if let collectionView = collectionView {
            let numberOfSections = collectionView.numberOfSections
            var yOffset = 0.f

            for section in 0..<numberOfSections {

                nsDateComponents.day = 1
                nsDateComponents.month = getCurrentMonthForSection(section, month: true)
                nsDateComponents.year = getCurrentMonthForSection(section, month: false)

                let firstDay = dateComponent.startingRangeOfDay() - 1

                let heightForThisSectionItems = collectionView.frame.width / 7

                let numberOfItems = collectionView.numberOfItems(inSection: section)
                var xOffset = (section.f * collectionView.frame.size.width) + firstDay.f * itemSize.width

                for item in 0..<numberOfItems {
                    let indexPath = IndexPath(item: item, section: section)

                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                    let key = layoutKeyForItemAtIndexPath(indexPath)

                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: heightForThisSectionItems)

                    collectionViewAttributes[key] = attributes

                    let nextItem = item + 1
                    xOffset = getTheXOffsetFor(indexPath: IndexPath(item: nextItem, section: section) , increaseWidth: attributes.frame.size.width, oldXOffset: xOffset, firstDay: firstDay)

                    yOffset = ((nextItem + firstDay) % 7 == 0) ? (yOffset + attributes.size.height) : yOffset
                }

                yOffset = 0.f
            }
        }
    }
    fileprivate func getTheXOffsetFor(indexPath : IndexPath, increaseWidth : CGFloat, oldXOffset : CGFloat, firstDay : Int) -> CGFloat {
        if let collectionView = collectionView {

            let xOffset = ((indexPath.item + firstDay) % 7 == 0) ? (indexPath.section.f * collectionView.frame.size.width) : oldXOffset + increaseWidth

            return xOffset

        } else {
            return 0.f
        }
    }
}
extension CalendarFlowLayout {
    fileprivate func layoutKeyForItemAtIndexPath(_ indexPath : IndexPath)-> String {
        return "\(indexPath.section)_\(indexPath.item)"
    }
}

extension CalendarFlowLayout {
    fileprivate func getCurrentMonthForSection(_ section : Int, month : Bool) -> Int{
        switch month {
        case true:
            let retMonth = (section + presentingMonth + rangeOfMonthToBeAdded() - 1) % 12
            return retMonth
        case false:
            let retYear = presentingYear.f + floor((section.f + presentingMonth.f + rangeOfMonthToBeAdded().f - 1.f) / 12.f)
            return Int(retYear)
        }
    }

    fileprivate func rangeOfMonthToBeAdded() -> Int{
        return currentIterationIndex * kCellsVisibleToTheUser
    }
}

extension Dictionary {
    func valuesForKeys(_ keys : [Key]) -> [Value?] {
        return keys.map{self[$0]}
    }
}

extension CGFloat {
    var f : CGFloat {
        return self
    }
}
extension Int {
    var f : CGFloat {
        return CGFloat(self)
    }
}

extension Float {
    var f : CGFloat {
        return CGFloat(self)
    }
}

extension Double {
    var f : CGFloat {
        return CGFloat(self)
    }

}
