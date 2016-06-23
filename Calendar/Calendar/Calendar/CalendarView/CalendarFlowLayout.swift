//
//  CalendarFlowLayout.swift
//  Calendar
//
//  Created by Shreesha on 12/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class CalendarFlowLayout: UICollectionViewFlowLayout {

    private var collectionViewAttributes = [String : UICollectionViewLayoutAttributes]()
    private let kCellsVisibleToTheUser = 3

    var presentingMonth = 0
    var presentingYear = 0
    var currentIterationIndex = 0

    override func prepareLayout() {
        super.prepareLayout()

        applyAttributes()
    }
    override func collectionViewContentSize() -> CGSize {
        super.collectionViewContentSize()
        if let collectionView = collectionView {
            return CGSize(width: collectionView.numberOfSections().f * collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else {
            return CGSizeZero
        }
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElementsInRect(rect)

        var filteredAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {
            for section in 0..<collectionView.numberOfSections()  {
                for item in 0..<collectionView.numberOfItemsInSection(section) {
                    
                    if CGRectIntersectsRect(rect, collectionViewAttributes[layoutKeyForItemAtIndexPath(NSIndexPath(forItem: item, inSection: section))]!.frame) {
                        filteredAttributes.append(collectionViewAttributes[layoutKeyForItemAtIndexPath(NSIndexPath(forItem: item, inSection: section))]!)
                    }
                }
            }
        } else {
            return nil
        }

        return filteredAttributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItemAtIndexPath(indexPath)
        let key = layoutKeyForItemAtIndexPath(indexPath)
        return collectionViewAttributes[key]
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        super.shouldInvalidateLayoutForBoundsChange(newBounds)

        if let collectionView = collectionView {
            return !(CGSizeEqualToSize(newBounds.size, collectionView.frame.size))
        }else {
            return false
        }
    }

    private func applyAttributes() {

        collectionViewAttributes.removeAll()

        if let collectionView = collectionView {
            let numberOfSections = collectionView.numberOfSections()
            var yOffset = 0.f

            for section in 0..<numberOfSections {

                nsDateComponents.day = 1
                nsDateComponents.month = getCurrentMonthForSection(section, month: true)
                nsDateComponents.year = getCurrentMonthForSection(section, month: false)

                let firstDay = dateComponent.startingRangeOfDay() - 1

                let heightForThisSectionItems = collectionView.frame.height / dateComponent.getNumberOfWeekForCurrentDate().f

                let numberOfItems = collectionView.numberOfItemsInSection(section)
                var xOffset = (section.f * collectionView.frame.size.width) + firstDay.f * itemSize.width

                for item in 0..<numberOfItems {
                    let indexPath = NSIndexPath(forItem: item, inSection: section)

                    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

                    let key = layoutKeyForItemAtIndexPath(indexPath)

                    attributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, heightForThisSectionItems)

                    collectionViewAttributes[key] = attributes

                    let nextItem = item + 1
                    xOffset = getTheXOffsetFor(indexPath: NSIndexPath(forItem: nextItem, inSection: section) , increaseWidth: attributes.frame.size.width, oldXOffset: xOffset, firstDay: firstDay)

                    yOffset = ((nextItem + firstDay) % 7 == 0) ? (yOffset + attributes.size.height) : yOffset
                }

                yOffset = 0.f
            }
        }
    }
    private func getTheXOffsetFor(indexPath indexPath : NSIndexPath, increaseWidth : CGFloat, oldXOffset : CGFloat, firstDay : Int) -> CGFloat {
        if let collectionView = collectionView {

            let xOffset = ((indexPath.item + firstDay) % 7 == 0) ? (indexPath.section.f * collectionView.frame.size.width) : oldXOffset + increaseWidth

            return xOffset

        } else {
            return 0.f
        }
    }
}
extension CalendarFlowLayout {
    private func layoutKeyForItemAtIndexPath(indexPath : NSIndexPath)-> String {
        return "\(indexPath.section)_\(indexPath.item)"
    }
}
extension CalendarFlowLayout {
    private func getCurrentMonthForSection(section : Int, month : Bool) -> Int{
        switch month {
        case true:
            let retMonth = (section + presentingMonth + rangeOfMonthToBeAdded() - 1) % 12
            return retMonth
        case false:
            let retYear = presentingYear.f + floor((section.f + presentingMonth.f + currentIterationIndex.f + rangeOfMonthToBeAdded().f - 1.f) / 12.f)
            return Int(retYear)
        }
    }

    private func rangeOfMonthToBeAdded() -> Int{
        return currentIterationIndex * kCellsVisibleToTheUser
    }
}

extension Dictionary {
    func valuesForKeys(keys : [Key]) -> [Value?] {
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
