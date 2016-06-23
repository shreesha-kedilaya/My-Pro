//
//  MDCollectionViewFlowLayout.swift
//  Calendar
//
//  Created by Shreesha on 17/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class MDCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private var collectionViewAttributes = [String : UICollectionViewLayoutAttributes]()

    private var yMinimuPadding = 20.f
    private var yMaximumPadding = 20.f

    private var minimumSizeForItem :CGSize!
    private var maximumSizeForItem : CGSize!
    private var selectedItemIndex = 0

    var xPadding = 10.f
    var startingXPadding = 10.f

    private var highlightedItemIndex : Int {
        var item = max(0, collectionView!.contentOffset.x / getAverageWidthOfTheItems())

        let itemRound = round(item)
        item = itemRound
        item = Int(item) >= collectionView!.numberOfItemsInSection(0) ? item - 1: item
        return Int(item)
    }

    override func prepareLayout() {
        super.prepareLayout()

        yMaximumPadding = (collectionView!.bounds.height - minimumSizeForItem.height) / 2
        yMinimuPadding = (collectionView!.bounds.height - maximumSizeForItem.height) / 2

        applyAttributes()
    }

    init(minimumSizeForItem : CGSize, maximumSizeForItem : CGSize) {
        super.init()
        self.maximumSizeForItem = maximumSizeForItem
        self.minimumSizeForItem = minimumSizeForItem

        startingXPadding = (UIScreen.mainScreen().bounds.size.width - maximumSizeForItem.width) / 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func collectionViewContentSize() -> CGSize {
        super.collectionViewContentSize()
        if let collectionView = collectionView {
            let noOfItems = collectionView.numberOfItemsInSection(0)

            let totalWidth = (noOfItems.f - 1) * minimumSizeForItem.width + maximumSizeForItem.width + xPadding.f * (noOfItems.f-1) + startingXPadding * 2
            return CGSize(width: totalWidth, height: collectionView.frame.size.height)
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
        return true
    }

    private func applyAttributes() {

        collectionViewAttributes.removeAll()

        if let collectionView = collectionView {
            let numberOfSections = collectionView.numberOfSections()
            var yOffset = yMinimuPadding.f / 2

            for section in 0..<numberOfSections {
                var xOffset = startingXPadding

                for item in 0..<collectionView.numberOfItemsInSection(section) {
                    let indexPath = NSIndexPath(forItem: item, inSection: section)

                    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

                    yOffset = getTheYPaddingFor(indexPath)

                    let key = layoutKeyForItemAtIndexPath(indexPath)
                    let size = getSizeOfItemAt(indexPath)

                    attributes.frame = CGRectMake(xOffset, yOffset, size.width , size.height)
                    attributes.zIndex = indexPath.item == highlightedItemIndex ? 3:1
                    attributes.alpha = max(0.3, percentageAlphaForItemAt(indexPath))
                    collectionViewAttributes[key] = attributes

                    xOffset += attributes.frame.size.width + xPadding.f
                }
            }
        }
    }

    private func percentageHighlightOfFeaturedIndex() -> CGFloat {
        let floatValueOfIndex = collectionView!.contentOffset.x / getAverageWidthOfTheItems()
        let difference = floatValueOfIndex - highlightedItemIndex.f
        return (difference)
    }

    private func percentageAlphaForItemAt(indexPath :NSIndexPath) -> CGFloat{
        var percentage = 0.f
        switch indexPath.item {

        case highlightedItemIndex:
            percentage = 1 - abs(percentageHighlightOfFeaturedIndex())
        case highlightedItemIndex+1, highlightedItemIndex+2:
            percentage = abs(percentageHighlightOfFeaturedIndex())
        case highlightedItemIndex - 1, highlightedItemIndex - 2 :
            percentage = abs(percentageHighlightOfFeaturedIndex())
        default:
            percentage = 1.0
        }

        return percentage
    }

    private func getTheYPaddingFor(indexPath : NSIndexPath) -> CGFloat {

        var yPadding = 0.f
        if indexPath.item == highlightedItemIndex {
            yPadding = yMinimuPadding.f - abs(percentageHighlightOfFeaturedIndex()) * differenceYPadding()
        } else if indexPath.item == highlightedItemIndex+1  || indexPath.item == highlightedItemIndex + 2{   //The next item
            yPadding = yMaximumPadding.f + percentageHighlightOfFeaturedIndex() * differenceYPadding()
        } else if indexPath.item == highlightedItemIndex-1  {    //The previous item
            yPadding = yMaximumPadding.f + abs(percentageHighlightOfFeaturedIndex()) * differenceYPadding()
        } else {
            yPadding = yMinimuPadding.f
        }
        return yPadding
    }

    private func differenceYPadding() -> CGFloat{
        return yMinimuPadding.f - yMaximumPadding.f
    }
    private func getSizeOfItemAt(indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeZero

        if indexPath.item == highlightedItemIndex{

            size = CGSize(width: maximumSizeForItem.width - abs(percentageHighlightOfFeaturedIndex()) * differenceBetweenWidths(), height: maximumSizeForItem.height - abs(percentageHighlightOfFeaturedIndex()) * differenceBetweenHeights())

        } else if indexPath.item == highlightedItemIndex + 1 {

            size = CGSize(width: maximumSizeForItem.width - percentageHighlightOfFeaturedIndex() * differenceBetweenWidths(), height: minimumSizeForItem.height + percentageHighlightOfFeaturedIndex() * differenceBetweenHeights())

        } else if indexPath.item == highlightedItemIndex - 1 || indexPath.item == highlightedItemIndex - 2{

            size = CGSize(width: minimumSizeForItem.width + abs(percentageHighlightOfFeaturedIndex()) * differenceBetweenWidths(), height: minimumSizeForItem.height + abs(percentageHighlightOfFeaturedIndex()) * differenceBetweenHeights())

        }else {
            size = minimumSizeForItem
        }

        return size
    }

    private func differenceBetweenWidths() -> CGFloat {
        return maximumSizeForItem.width - minimumSizeForItem.width
    }
    private func differenceBetweenHeights() -> CGFloat {
        return maximumSizeForItem.height - minimumSizeForItem.height
    }

    private func getTheXOffsetFor(indexPath indexPath : NSIndexPath, increaseWidth : CGFloat, oldXOffset : CGFloat, firstDay : Int) -> CGFloat {
        if let collectionView = collectionView {

            let xOffset = ((indexPath.item + firstDay) % 7 == 0) ? (indexPath.section.f * collectionView.frame.size.width) : oldXOffset + increaseWidth

            return xOffset

        } else {
            return 0.f
        }
    }

    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        let itemIndex = round(proposedContentOffset.x / getAverageWidthOfTheItems())
        selectedItemIndex = Int(itemIndex)
        let xOffset = itemIndex * getAverageWidthOfTheItems()
        return CGPoint(x: xOffset, y: 0.f)
    }

    private func getAverageWidthOfTheItems() -> CGFloat {
        if let collectionView = collectionView {
            let noOfItems = collectionView.numberOfItemsInSection(0)

            let totalWidth = (noOfItems.f - 1) * minimumSizeForItem.width + maximumSizeForItem.width + xPadding.f * noOfItems.f - differenceBetweenWidths()

            let averageWidth = totalWidth / noOfItems.f
            return averageWidth
        } else {
            return 0.f
        }
    }
}
extension MDCollectionViewFlowLayout {
    private func layoutKeyForItemAtIndexPath(indexPath : NSIndexPath)-> String {
        return "\(indexPath.section)_\(indexPath.item)"
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