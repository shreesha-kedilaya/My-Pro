////
////  RangeSelector.swift
////  Range selector
////
////  Created by Shreesha on 02/12/15.
////  Copyright © 2015 YML. All rights reserved.
////
//
//import UIKit
//import Foundation
//
////protocol RangeSelectorDelegate : class {
////    func theSelectorMoved(rangeSelector: Range, toIndex Index: Int)
////    func theCurrentRangeOfSelector(rangeSelector:Range, start : Int , end : Int)
////
////}
////protocol RangeSelectorDatasource : class {
////    func numberOfSegmentsForRangeSelector(rangeSelector: Range) -> Int
////    func startIndexForRangeSelector(rangeSelector : Range) -> Int
////    func endIndexForRangeSelector(rangeSelector:Range) -> Int
////    func textsForRangeSelector(rangeSelector: Range, atIndex index: Int) -> String
////}
//
//class Range: UIControl {
//
//    //MARK: public properties
//
////    weak var delegate: RangeSelectorDelegate?
//
////    weak var dataSource : RangeSelectorDatasource?
//
//    var segmentHighlightedColor = UIColor(red: 0/255, green: 199/255, blue: 239/255, alpha: 1.0)
//
//    var segmentUnhighlightedColor = UIColor.grayColor()
//
//    var startIndex : Int = 0 {
//        didSet {
//            reloadData()
//        }
//    }
//    var endIndex : Int = 3 {
//        didSet {
//            reloadData()
//        }
//    }
//    var numberOfSegments : Int = 5 {
//        didSet {
//            setUp()
//        }
//    }
//
//    var startThumdPosition = CGPoint()
//
//    var endThumbPosition = CGPoint()
//
//    var kThumbRadius = 13
//
//    var kDotRadius = 5
//
//    var kStrokeWidth = 2
//
//    var kSliderHeight = 3
//
//    var shouldMoveStartThumb = false
//
//    var shouldMoveEndThumb = false
//
//    //MARK: private properties
//    //    private var midPoint = CGFloat()
//
//    private var clickedIndex = Int()
//
//    private var labelTexts : String? {
//        didSet {
//
//        }
//    }
//
//    private var distceBetweenSegments : CGFloat = 10
//
//    private var labels = [UILabel]()
//
//    private var segmentDots : [CAShapeLayer]? = [CAShapeLayer]()
//
//    private var startingThumb : CAShapeLayer? = CAShapeLayer()
//
//    private var endingThumb :CAShapeLayer? = CAShapeLayer()
//
//    private let kPaddingForDot = 20
//
//    private var sliderView = UIView()
//
//    //MARK: public methods
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setUp()
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setUp()
//
//    }
//
//    override func layoutSubviews() {
//
//        distceBetweenSegments = (frame.size.width) / (numberOfSegments.f - 1) - (kPaddingForDot.f / 2) // distance between segments
//
//        let xs = startIndex.f * distceBetweenSegments + kPaddingForDot.f + kThumbRadius.f
//        let xe = endIndex.f * distceBetweenSegments + kPaddingForDot.f + kThumbRadius.f
//
//        startThumdPosition = CGPointMake(xs, CGRectGetMidY(bounds) - (kThumbRadius.f / 2.f))
//        endThumbPosition = CGPointMake(xe , CGRectGetMidY(bounds) - (kThumbRadius.f / 2.f))
//
//        for view in subviews {
//            view.removeFromSuperview()
//        }
//
//        if let layer = layer.sublayers {
//            for layer in layer {
//                layer.removeFromSuperlayer()
//            }
//        }
//
//        sliderView.frame = CGRectMake(kPaddingForDot.f , CGRectGetMidY(bounds) - kSliderHeight.f / 2.f, bounds.size.width - (kPaddingForDot.f * 2), kSliderHeight.f)
//        sliderView.backgroundColor = segmentUnhighlightedColor
//        addSubview(sliderView)
//
//        setUpDotSegment()
//        addStartingThumb(inPosition: startThumdPosition)
//        addEndingThumb(inPosition: endThumbPosition)
//        setupLabel()
//
//        let fromValue = startIndex.f * distceBetweenSegments
//        let toValue = endIndex.f * distceBetweenSegments
//
//        addHighlightSlideLayer(fromValue, to: toValue)
//
//    }
//
//    //MARK: private methods
//
//    private func setUp() {
//        setupSliderView()
//        backgroundColor = UIColor.blackColor()
//    }
//
//    private func setupSliderView() {
//        sliderView.frame = CGRectMake(0, CGRectGetMidY(bounds) - 20, frame.size.width, 40)
//        addSubview(sliderView)
//        sliderView.backgroundColor = segmentUnhighlightedColor
//    }
//
//    private func setupLabel() {
//
//        labels.removeAll()
//
//        for i in 0..<numberOfSegments {
//            let distanceBetween = CGFloat(distceBetweenSegments)
//            let radiusOfDot = 2
//            let label = UILabel()
//            label.userInteractionEnabled = false
//            let x = i.f * distanceBetween
//            label.frame = CGRect(x: x + (kPaddingForDot.f / 2), y: CGRectGetMidY(bounds) + radiusOfDot.f + 10.f , width: distanceBetween - 20 , height: 20)
//            label.text = "me"
//            label.textColor = UIColor.whiteColor()
//            labels.append(label)
//            addSubview(label)
//            print(i)
//        }
//    }
//
//    private func setUpDotSegment() {
//
//        segmentDots?.removeAll()
//
//        let distanceBetween = CGFloat(distceBetweenSegments)
//
//        for i in 0..<numberOfSegments {
//            let dot = CAShapeLayer()
//            let x = i.f * distanceBetween + kPaddingForDot.f + kDotRadius.f
//
//            dot.frame = CGRect(origin: CGPoint(x: 0 , y: CGRectGetMidY(bounds) - kDotRadius.f / 2), size: CGSize(width: kDotRadius.f * 2, height: kDotRadius.f * 2))
//
//            dot.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: kDotRadius.f / 2.f), radius: kDotRadius.f, startAngle: 0.f, endAngle: 2 * 3.1415, clockwise: true).CGPath
//            dot.position = CGPointMake(x, CGRectGetMidY(bounds) + kDotRadius.f / 2)
//
//            dot.fillColor = segmentHighlightedColor.CGColor
//            dot.strokeColor = segmentHighlightedColor.CGColor
//            dot.lineWidth = 0
//            dot.masksToBounds = false
//
//            layer.addSublayer(dot)
//            segmentDots?.append(dot)
//        }
//    }
//
//    private func reloadData() {
//
//    }
//
//    private func addStartingThumb(inPosition position : CGPoint) {
//
//        startingThumb = getThumbShapeLayer(position)
//        startingThumb!.position.x = position.x
//        startingThumb!.position.y = CGRectGetMidY(bounds) + (kThumbRadius.f / 2)
//
//        layer.addSublayer(startingThumb!)
//    }
//
//    private func addEndingThumb(inPosition position: CGPoint) {
//
//        endingThumb = getThumbShapeLayer(position)
//        endingThumb?.position = position
//        endingThumb?.position.y = CGRectGetMidY(bounds) + (kThumbRadius.f / 2)
//
//        layer.addSublayer(endingThumb!)
//    }
//
//    private func getThumbShapeLayer(position: CGPoint) -> CAShapeLayer {
//        let thumb = CAShapeLayer()
//
//        thumb.frame = CGRect(origin: CGPoint(x: 0, y: CGRectGetMidY(bounds) - kThumbRadius.f), size: CGSize(width: kThumbRadius.f * 2, height: kThumbRadius.f * 2))
//
//        thumb.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: kThumbRadius.f / 2.f), radius: kThumbRadius.f, startAngle: 0.f, endAngle: 2 * 3.1415, clockwise: true).CGPath
//
//        thumb.fillColor = UIColor.clearColor().CGColor
//        thumb.strokeColor = segmentHighlightedColor.CGColor
//        thumb.lineWidth = kStrokeWidth.f
//        thumb.masksToBounds = false
//
//        return thumb
//    }
//
//    private func addHighlightSlideLayer(from: CGFloat, to: CGFloat) {
//        let hLayer = CAShapeLayer()
//
//        let width = to - from
//
//        hLayer.path = UIBezierPath(rect: CGRect(x: from, y: 0 , width: width , height: kSliderHeight.f)).CGPath
//        hLayer.fillColor = segmentHighlightedColor.CGColor
//        hLayer.strokeColor = segmentHighlightedColor.CGColor
//        hLayer.lineWidth = kStrokeWidth.f
//        hLayer.masksToBounds = false
//
//        print("highlight layer frame \n \n ", hLayer.frame)
//
//        if let layers = sliderView.layer.sublayers {
//            for layer in layers {
//                layer.removeFromSuperlayer()
//            }
//        }
//
//        sliderView.layer.addSublayer(hLayer)
//    }
//
//    private func changeTheStateOfSegmentedDot(atIndex index: Int , changeStateTo state: Int) {
//
//        print((segmentDots?.count)!)
//        for i in 0...segmentDots!.count {
//            if i == index {
//                if state == 0 {
//                    segmentDots?[i].fillColor = UIColor.grayColor().CGColor
//                    segmentDots?[i].strokeColor = UIColor.grayColor().CGColor
//                }
//                else {
//                    segmentDots?[i].fillColor = segmentHighlightedColor.CGColor
//                    segmentDots?[i].strokeColor = segmentHighlightedColor.CGColor
//                }
//            }
//        }
//    }
//
//    private func moveStartThumb(toPosition position : CGPoint, withIndex index : Int) {
//        if let startingThumb = startingThumb {
//
//            let xDiff = endThumbPosition.x - position.x
//
//            print("xDiff",xDiff)
//            print("distceBetweenSegments", distceBetweenSegments)
//
//            let bool = xDiff  > distceBetweenSegments
//
//            print("bool", bool)
//
//            if bool {
//                startingThumb.position.x = position.x + kThumbRadius.f / 2
//                startingThumb.position.y = CGRectGetMidY(bounds) + (kThumbRadius.f / 2.f)
//
//                startThumdPosition = startingThumb.position
//                addHighlightSlideLayer(startThumdPosition.x, to: endThumbPosition.x)
//                startIndex = index
//                highlightTheLabelsAtIndexes(startIndex + 1, end: endIndex + 1)
//            }
//        }
//    }
//
//    private func moveEndThumb(toPosition position : CGPoint, withIndex index : Int) {
//        if let endingThumb = endingThumb {
//
//            let xDiff = abs(position.x - startThumdPosition.x)
//
//            print("xDiff",xDiff)
//            print("distceBetweenSegments", distceBetweenSegments)
//            print("startThumdPosition",startThumdPosition.x)
//
//            let bool = xDiff >= distceBetweenSegments
//            print("bool", bool)
//
//            if position.x <= CGRectGetMaxX(bounds) - kPaddingForDot.f / 2 - kThumbRadius.f / 4 && bool{
//                endingThumb.position.x = position.x + kThumbRadius.f / 2
//                endingThumb.position.y = CGRectGetMidY(bounds) + (kThumbRadius.f / 2.f)
//
//                endThumbPosition = endingThumb.position
//                endIndex = index
//                addHighlightSlideLayer(startThumdPosition.x, to: endThumbPosition.x)
//                highlightTheLabelsAtIndexes(startIndex + 1, end: endIndex + 1)
//            }
//        }
//    }
//
//    //MARK: Touches Handling
//
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//
//        let touchesStart = event?.allTouches()
//        let touch = touchesStart?.first
//        let location = touch!.locationInView(self)
//
//        if CGRectContainsPoint((startingThumb?.frame)!, location) {
//            shouldMoveStartThumb = true
//            shouldMoveEndThumb = false
//        } else  if CGRectContainsPoint((endingThumb?.frame)!, location) {
//            shouldMoveEndThumb = true
//            shouldMoveStartThumb = false
//        } else {
//            for dotIndex in 0..<segmentDots!.count {
//                //
//                //                print("dot frame",dot.frame )
//                //                print("location", location)
//                //                print("condition", CGRectContainsPoint(dot.frame, location))
//                //
//                //                print("\n")
//
//                if CGRectContainsPoint(segmentDots![dotIndex].frame, location) {
//
//                    clickedIndex = dotIndex
//
//                    let diffStart = abs(dotIndex - startIndex)
//                    let diffEnd = abs(dotIndex - endIndex)
//
//
//                    if clickedIndex != startIndex  && diffStart < diffEnd {
//                        moveStartThumb(toPosition: CGPoint(x: segmentDots![dotIndex].position.x, y: 0), withIndex: clickedIndex)
//
//                        return
//
//                    } else if clickedIndex != endIndex && diffStart > diffEnd {
//                        moveEndThumb(toPosition: CGPoint(x: segmentDots![dotIndex].position.x + kDotRadius.f / 4, y: 0), withIndex : clickedIndex)
//
//                        return
//
//                    } else if diffStart == diffEnd {
//                        moveStartThumb(toPosition: CGPoint(x: segmentDots![dotIndex].position.x /*+ kDotRadius.f / 4*/, y: 0), withIndex : clickedIndex)
//                        return
//                    }
//                }
//            }
//        }
//
//        //        if (endIndex - startIndex >= 1) {
//        //            shouldMoveStartThumb = false
//        //            shouldMoveEndThumb = false
//        //        }
//
//        //        print("Location when touch began", location)
//        //        print("startingThumb?.frame", (startingThumb?.frame)!)
//        //        print("endingThumb?.frame", (endingThumb?.frame)!)
//
//        print("startIndex",startIndex)
//        print("endIndex",endIndex)
//        print("shouldMoveEndThumb and shouldMoveStartThumb ", shouldMoveEndThumb , shouldMoveStartThumb )
//
//
//    }
//
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//
//    }
//
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//
//        moveToRespectivePositions()
//        //        print("shouldMoveEndThumb and shouldMoveStartThumb ", shouldMoveEndThumb , shouldMoveStartThumb )
//        shouldMoveEndThumb = false
//        shouldMoveStartThumb = false
//        delegate?.theCurrentRangeOfSelector(self, start: startIndex, end: endIndex)
//
//    }
//
//    private func moveToRespectivePositions() {
//
//        let div = distceBetweenSegments / 2
//
//        //        print("\n")
//        //        print("startIndex",startIndex)
//        //        print("endIndex",endIndex)
//        //        print("\n")
//
//        if endIndex - startIndex >= 1 {
//            for dotIndex in 0..<segmentDots!.count - 1 {
//                if startThumdPosition.x > segmentDots![dotIndex].position.x && startThumdPosition.x < segmentDots![dotIndex + 1].position.x {
//                    let diff1 = startThumdPosition.x - segmentDots![dotIndex].position.x
//                    let diff2 = segmentDots![dotIndex + 1].position.x - startThumdPosition.x
//
//                    //                    print("startThumdPosition is",startThumdPosition.x)
//                    //
//                    //                    print("segmentDots![dotIndex]. is",segmentDots![dotIndex].position.x)
//                    //                    print("segmentDots![dotIndex + 1]. is",segmentDots![dotIndex + 1].position.x)
//                    //
//                    //                    print("diff1 is",diff1)
//                    //                    print("diff2 is",diff2)
//                    //                    print("div is",div)
//                    //                    print("dot Index", dotIndex)
//                    //                    print("\n")
//
//                    if diff1 < div {
//                        if shouldMoveStartThumb {
//                            moveStartThumb(toPosition: CGPoint(x: segmentDots![dotIndex].position.x + kDotRadius.f / 2, y: segmentDots![dotIndex].position.y), withIndex : dotIndex)
//                            return
//                        }
//
//                    } else if diff2 < div {
//                        if shouldMoveStartThumb {
//                            moveStartThumb(toPosition: segmentDots![dotIndex + 1].position, withIndex : dotIndex + 1)
//                            return
//                        }
//                    }
//
//                } else if endThumbPosition.x > segmentDots![dotIndex].position.x && startThumdPosition.x < segmentDots![dotIndex + 1].position.x {
//
//                    let diff1 = startThumdPosition.x - segmentDots![dotIndex].position.x
//                    let diff2 = segmentDots![dotIndex + 1].position.x - startThumdPosition.x
//
//                    //                    print("endThumbPosition is",endThumbPosition.x)
//                    //
//                    //                    print("segmentDots![dotIndex]. is",segmentDots![dotIndex].position.x)
//                    //                    print("segmentDots![dotIndex + 1]. is",segmentDots![dotIndex + 1].position.x)
//                    //
//                    //                    print("diff1 is",diff1)
//                    //                    print("diff2 is",diff2)
//                    //                    print("div is",div)
//                    //                    print("dot Index", dotIndex)
//                    //                    print("\n")
//
//
//                    if diff1 < div {
//                        if shouldMoveEndThumb {
//                            moveEndThumb(toPosition: segmentDots![dotIndex].position, withIndex : dotIndex)
//                            return
//                        }
//                    } else if diff2 < div{
//                        if shouldMoveEndThumb {
//                            moveEndThumb(toPosition: segmentDots![dotIndex + 1].position, withIndex : dotIndex + 1)
//                            return
//                        }
//                    }
//                }
//            }
//        }
//    }
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//
//        let touchesStart = event?.allTouches()
//        let touch = touchesStart?.first
//        let location = touch!.locationInView(self)
//
//        if shouldMoveStartThumb{
//            moveStartThumb(toPosition: location, withIndex : startIndex)
//        }
//        if shouldMoveEndThumb{
//            moveEndThumb(toPosition: location, withIndex : endIndex)
//        }
//        //        print("Moved to ", location.x)
//
//        //        print("startIndex",startIndex)
//        //        print("endIndex",endIndex)
//        //        print("shouldMoveEndThumb and shouldMoveStartThumb ", shouldMoveEndThumb , shouldMoveStartThumb )
//        //        print("Bool", (endIndex - startIndex > 1))
//
//    }
//
//    private func getIndexForPosition(position: CGFloat) -> Int?{
//        var indexToReturn = Int?()
//        for index in 0..<segmentDots!.count{
//
//            let dotPosition = segmentDots![index].position.x
//            print("dot postion", dotPosition)
//            print("location postion", position)
//            print("difference is \(abs(dotPosition - position))")
//            print("condition is \(abs(position - dotPosition) <= 20.f)")
//            print("\n")
//
//            if abs(dotPosition - position) <= 20 {
//                indexToReturn = index
//            } else  {
//                //                indexToReturn = nil
//            }
//        }
//
//        //        print("index returned \(indexToReturn) \n")
//
//        return indexToReturn
//    }
//    private func getPositionForIndex(index:Int ) -> CGFloat? {
//        let position = segmentDots?[index].position.x
//        return position
//    }
////    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
////        let touchesStart = event?.allTouches()
////        for touch in touchesStart! {
////            let location = touch.locationInView(self)
////
////            //            if CGRectContainsPoint((startingThumb?.frame)!, location) {
////            //                moveStartThumb(toPosition: location)
////            //            } else  if CGRectContainsPoint((endingThumb?.bounds)!, location) {
////            //                moveEndThumb(toPosition: location)
////            //            }
////        }
////        return true
////    }
////    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
////        
////        let touchesStart = event?.allTouches()
////        for touch in touchesStart! {
////            let location = touch.locationInView(self)
////            
////            //            if CGRectContainsPoint((startingThumb?.frame)!, location) {
////            //                moveStartThumb(toPosition: location)
////            //            } else  if CGRectContainsPoint((endingThumb?.bounds)!, location) {
////            //                moveEndThumb(toPosition: location)
////            //            }
////        }
////        return true
////    }
//    override func sendActionsForControlEvents(controlEvents: UIControlEvents) {
//        super.sendActionsForControlEvents(controlEvents)
//    }
//
//    override func didMoveToSuperview() {
//        
//        if let dataSource = dataSource {
//            startIndex = dataSource.startIndexForRangeSelector(self)
//            endIndex = dataSource.endIndexForRangeSelector(self)
//            numberOfSegments = dataSource.numberOfSegmentsForRangeSelector(self)
//            for segment in 0...(dataSource.numberOfSegmentsForRangeSelector(self)) - 1{
//                labels[segment].text = dataSource.textsForRangeSelector(self, atIndex: segment)
//            }
//        }
//    }
//    private func highlightTheLabelsAtIndexes(start:Int,end:Int) {
//
//        print("start index is", start)
//        print("end index is", end)
//
//        for index in 0..<labels.count {
//            
//            if index == start - 1 {
//                labels[index].hidden = false
//            }else if index == end - 1 {
//                labels[index].hidden = false
//            }else{
//                labels[index].hidden = true
//            }
//
//            print("Label state at index \(index) is ", labels[index].hidden)
//            
//        }
//    }
//}
//
//extension Int {
//    var f: CGFloat {
//        return CGFloat(self)
//    }
//}
//
//extension Float {
//    var f: CGFloat {
//        return CGFloat(self)
//    }
//}
//
//extension Double {
//    var f: CGFloat {
//        return CGFloat(self)
//    }
//}