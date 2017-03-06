//
//  MDCollectionViewFlowLayout.swift
//  Calendar
//
//  Created by Shreesha on 17/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class MDCollectionViewFlowLayout: UICollectionViewFlowLayout {

    fileprivate var collectionViewAttributes = [String : UICollectionViewLayoutAttributes]()

    fileprivate var yMinimuPadding = 20.f
    fileprivate var yMaximumPadding = 20.f

    fileprivate var minimumSizeForItem :CGSize!
    fileprivate var maximumSizeForItem : CGSize!
    fileprivate var selectedItemIndex = 0

    var xPadding = 10.f
    var startingXPadding = 10.f

    fileprivate var highlightedItemIndex : Int {
        var item = max(0, collectionView!.contentOffset.x / getAverageWidthOfTheItems())

        let itemRound = round(item)
        item = itemRound
        item = Int(item) >= collectionView!.numberOfItems(inSection: 0) ? item - 1: item
        return Int(item)
    }

    override func prepare() {
        super.prepare()

        yMaximumPadding = (collectionView!.bounds.height - minimumSizeForItem.height) / 2
        yMinimuPadding = (collectionView!.bounds.height - maximumSizeForItem.height) / 2

        applyAttributes()
    }

    init(minimumSizeForItem : CGSize, maximumSizeForItem : CGSize) {
        super.init()
        self.maximumSizeForItem = maximumSizeForItem
        self.minimumSizeForItem = minimumSizeForItem

        startingXPadding = (UIScreen.main.bounds.size.width - maximumSizeForItem.width) / 2
    }

    init(size: CGSize, aspectRatio: CGFloat) {
        super.init()
        maximumSizeForItem = size
        minimumSizeForItem = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        startingXPadding = (UIScreen.main.bounds.size.width - maximumSizeForItem.width) / 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override var collectionViewContentSize : CGSize {
        super.collectionViewContentSize
        if let collectionView = collectionView {
            let noOfItems = collectionView.numberOfItems(inSection: 0)

            let totalWidth = (noOfItems.f - 1) * minimumSizeForItem.width + maximumSizeForItem.width + xPadding.f * (noOfItems.f-1) + startingXPadding * 2
            return CGSize(width: totalWidth, height: collectionView.frame.size.height)
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
        return true
    }

    fileprivate func applyAttributes() {

        collectionViewAttributes.removeAll()

        if let collectionView = collectionView {
            let numberOfSections = collectionView.numberOfSections
            var yOffset = yMinimuPadding.f / 2

            for section in 0..<numberOfSections {
                var xOffset = startingXPadding

                for item in 0..<collectionView.numberOfItems(inSection: section) {
                    let indexPath = IndexPath(item: item, section: section)

                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                    yOffset = getTheYPaddingFor(indexPath)

                    let key = layoutKeyForItemAtIndexPath(indexPath)
                    let size = getSizeOfItemAt(indexPath)

                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: size.width , height: size.height)
                    attributes.zIndex = indexPath.item == highlightedItemIndex ? 3:1
                    attributes.alpha = max(0.3, percentageAlphaForItemAt(indexPath))
                    collectionViewAttributes[key] = attributes

                    xOffset += attributes.frame.size.width + xPadding.f
                }
            }
        }
    }

    fileprivate func percentageHighlightOfFeaturedIndex() -> CGFloat {
        let floatValueOfIndex = collectionView!.contentOffset.x / getAverageWidthOfTheItems()
        let difference = floatValueOfIndex - highlightedItemIndex.f
        return (difference)
    }

    fileprivate func percentageAlphaForItemAt(_ indexPath :IndexPath) -> CGFloat{
        var percentage = 0.f
        switch indexPath.item {

        case highlightedItemIndex:
            percentage = 1 - abs(percentageHighlightOfFeaturedIndex())
        case highlightedItemIndex + 1:
            let percent = percentageHighlightOfFeaturedIndex() > 0 ? percentageHighlightOfFeaturedIndex() : 0
            percentage = abs(percent)
        case highlightedItemIndex - 1:
            let percent = percentageHighlightOfFeaturedIndex() < 0 ? percentageHighlightOfFeaturedIndex() : 0
            percentage = abs(percent)
        default:
            percentage = 0
        }

        return percentage
    }

    fileprivate func getTheYPaddingFor(_ indexPath : IndexPath) -> CGFloat {

        var yPadding = 0.f
        if indexPath.item == highlightedItemIndex {
            let percentage = abs(percentageHighlightOfFeaturedIndex()) <= 1 ? abs(percentageHighlightOfFeaturedIndex()): 1
            yPadding = yMinimuPadding.f - percentage * differenceYPadding()
        } else if indexPath.item == highlightedItemIndex+1  {//|| indexPath.item == highlightedItemIndex + 2{   //The next item
            let percentage = percentageHighlightOfFeaturedIndex() > 0 ? percentageHighlightOfFeaturedIndex() : 0
            yPadding = yMaximumPadding.f + percentage * differenceYPadding()
        } else if indexPath.item == highlightedItemIndex-1  {    //The previous item
            let percentage = percentageHighlightOfFeaturedIndex() < 0 ? percentageHighlightOfFeaturedIndex() : 0
            yPadding = yMaximumPadding.f + abs(percentage) * differenceYPadding()
        } else {
            yPadding = yMinimuPadding.f - differenceYPadding()
        }
        return yPadding
    }

    fileprivate func differenceYPadding() -> CGFloat{
        return yMinimuPadding.f - yMaximumPadding.f
    }
    fileprivate func getSizeOfItemAt(_ indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero

        if indexPath.item == highlightedItemIndex {

            size = CGSize(width: maximumSizeForItem.width - abs(percentageHighlightOfFeaturedIndex()) * differenceBetweenWidths(), height: maximumSizeForItem.height - abs(percentageHighlightOfFeaturedIndex()) * differenceBetweenHeights())
            size.height = size.height >= minimumSizeForItem.height ? size.height: minimumSizeForItem.height
            size.width = size.width >= minimumSizeForItem.width ? size.width: minimumSizeForItem.width

        } else if indexPath.item == highlightedItemIndex + 1 {

            let percentage = percentageHighlightOfFeaturedIndex() > 0 ? percentageHighlightOfFeaturedIndex() : 0
            size = CGSize(width: minimumSizeForItem.width + abs(percentage) * differenceBetweenWidths(), height: minimumSizeForItem.height + percentage * differenceBetweenHeights())

        } else if indexPath.item == highlightedItemIndex - 1 {//|| indexPath.item == highlightedItemIndex - 2{

            let percentage = percentageHighlightOfFeaturedIndex() < 0 ? percentageHighlightOfFeaturedIndex() : 0

            size = CGSize(width: minimumSizeForItem.width + abs(percentage) * differenceBetweenWidths(), height: minimumSizeForItem.height + abs(percentage) * differenceBetweenHeights())

        }else {
            size = minimumSizeForItem
        }

        return size
    }

    fileprivate func differenceBetweenWidths() -> CGFloat {
        return maximumSizeForItem.width - minimumSizeForItem.width
    }
    fileprivate func differenceBetweenHeights() -> CGFloat {
        return maximumSizeForItem.height - minimumSizeForItem.height
    }

    fileprivate func getTheXOffsetFor(indexPath : IndexPath, increaseWidth : CGFloat, oldXOffset : CGFloat, firstDay : Int) -> CGFloat {
        if let collectionView = collectionView {

            let xOffset = ((indexPath.item + firstDay) % 7 == 0) ? (indexPath.section.f * collectionView.frame.size.width) : oldXOffset + increaseWidth

            return xOffset

        } else {
            return 0.f
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        let itemIndex = round(proposedContentOffset.x / getAverageWidthOfTheItems())
        selectedItemIndex = Int(itemIndex)
        let xOffset = itemIndex * getAverageWidthOfTheItems()
        return CGPoint(x: xOffset, y: 0.f)
    }

    fileprivate func getAverageWidthOfTheItems() -> CGFloat {
        if let collectionView = collectionView {
            let noOfItems = collectionView.numberOfItems(inSection: 0)

            let totalWidth = (noOfItems.f - 1) * minimumSizeForItem.width + maximumSizeForItem.width + xPadding.f * noOfItems.f - differenceBetweenWidths()

            let averageWidth = totalWidth / noOfItems.f
            return averageWidth
        } else {
            return 0.f
        }
    }
}
extension MDCollectionViewFlowLayout {
    fileprivate func layoutKeyForItemAtIndexPath(_ indexPath : IndexPath)-> String {
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
