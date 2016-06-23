//
//  RangeSelector.swift
//  RangeSelector
//
//  Created by Shreesha on 06/01/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

protocol RangeSelectorDataSource : class {
    func numberOfSegmentsForRangeSelector(rangeSelector: RangeSelector) -> Int
    func startIndexForRangeSelector(rangeSelector : RangeSelector) -> Int
    func endIndexForRangeSelector(rangeSelector:RangeSelector) -> Int
    func textsForRangeSelector(rangeSelector: RangeSelector, atIndex index: Int) -> String
}

protocol RangeSelectorDelegate :class {
    func rangeSelector(rangeSelector : RangeSelector , movedFromIndex fromIndex : Int, toIndex : Int)
}


enum PreviouslyMoved {
    case Start
    case End
}

class RangeSelector: UIControl {

    struct Constants {

        static let width = 30.f
        static let height = 30.f
    }

    private var unHighlightedView = UIView()

    private var highlightedView = UIView()

    private var highlightedLayer = CAShapeLayer()

    private var startThumbView = ThumbView()

    private var endThumbView = ThumbView()

    //MARK:constants
    private let kPadding = 20.f

    private var thicknessForHighlightedView = 3.f

    private var thicknessForUnhighlightedView = 1.f

    private var widthForLabel = 30.f

    private var sizeForDotView = 15.f

    //End of constants

    private var shouldMoveStartThumb = false

    private var shouldMoveEndThumb = false

    private var dotViews = [DotView]()

    private var previoslyMovedView : PreviouslyMoved?

    private var labels : [UILabel]?

    weak var delegate : RangeSelectorDelegate?

    weak var dataSource : RangeSelectorDataSource? {
        didSet {
            if let dataSource = dataSource {
                noOfSegments = dataSource.numberOfSegmentsForRangeSelector(self)
                startIndex = dataSource.startIndexForRangeSelector(self)
                if dataSource.endIndexForRangeSelector(self) >= noOfSegments {
                    endIndex = noOfSegments - 1
                } else {
                    endIndex = dataSource.endIndexForRangeSelector(self)
                }

                setupLabels()
                reloadDataInternally()
            }
        }
    }

    private var startIndex = 3

    private var endIndex = 5

    var noOfSegments = 6

    var highlightedColor = UIColor.greenColor()

    var unhighlightedColor = UIColor.blackColor()

    var labelTextColor = UIColor.blackColor()

    override func awakeFromNib() {
        setupTheInitialViews()
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTheInitialViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTheInitialViews()
    }

    private func reloadDataInternally() {
        startThumbView.center = getTheCenterPositionForIndex(startIndex)
        endThumbView.center = getTheCenterPositionForIndex(endIndex)
        changeTheStateOfDotViews()
        highlightTheHighlightView(fromPosition: startThumbView.center.x, toPosition: endThumbView.center.x)
    }

    private func setupTheInitialViews() {

        backgroundColor = UIColor.grayColor()

        for view in subviews {
            view.removeFromSuperview()
        }
        
        unHighlightedView.frame = CGRect(x: kPadding, y: CGRectGetMidY(bounds) - thicknessForHighlightedView/2, width: bounds.width - 2 * kPadding, height: thicknessForHighlightedView)
        unHighlightedView.backgroundColor = unhighlightedColor

        startThumbView.frame = getFrameForIndex(startIndex, withWidth: Constants.width)
        endThumbView.frame = getFrameForIndex(endIndex, withWidth: Constants.width)
        setupViews([startThumbView, endThumbView])

        let origin = getTheOriginForIndex(startIndex)
        let width = getTheDistanceBetweenSegments() * endIndex.f

        highlightedView.frame = CGRect(x: origin.x, y: origin.y  - thicknessForHighlightedView / 2, width: width, height:thicknessForHighlightedView)
        highlightedView.backgroundColor = highlightedColor

        addAllSubViews()
        addGesture()
        setupLabels()
        setupDotViews()
        changeTheStateOfDotViews()

        highlightTheLabelsAtIndexes([startIndex , endIndex])
        bringSubviewToFront(startThumbView)
        bringSubviewToFront(endThumbView)
    }

    override func layoutSubviews() {
        setupFrames()
    }

    private func setupFrames() {
        unHighlightedView.frame = CGRect(x: kPadding, y: CGRectGetMidY(bounds) - thicknessForHighlightedView/2, width: frame.width - 2 * kPadding, height: thicknessForHighlightedView)

        let origin = getTheOriginForIndex(startIndex)
        let width = getTheDistanceBetweenSegments() * (endIndex.f - startIndex.f)

        highlightedView.frame = CGRect(x: origin.x, y: origin.y  - thicknessForHighlightedView / 2, width: width, height:thicknessForHighlightedView)

        startThumbView.frame = getFrameForIndex(startIndex, withWidth:  Constants.width)
        endThumbView.frame = getFrameForIndex(endIndex, withWidth:  Constants.width)

        setupDotViews()
        setupLabels()
        highlightTheLabelsAtIndexes([startIndex, endIndex])
        changeTheStateOfDotViews()
    }

    private func setupDotViews() {

        for view in dotViews {
            view.removeFromSuperview()
        }
        dotViews = []
        for i in 0...endIndex {

            let view = DotView(frame: getFrameForIndex(i, withWidth: sizeForDotView))
            view.backgroundColor = UIColor.clearColor()
            view.colorForDotView = highlightedColor
            addSubview(view)
            dotViews.append(view)
        }
    }

    private func setupLabels() {
        if let labels = labels {
            for label in labels{
                label.removeFromSuperview()
            }
        }
        labels = []
        for i in 0..<noOfSegments {
            let label = UILabel()
            label.userInteractionEnabled = false
            let x = getTheDistanceBetweenSegments() * i.f
            label.frame = CGRect(x: x + kPadding - widthForLabel / 2, y: CGRectGetMaxY(startThumbView.frame), width: widthForLabel, height: widthForLabel)
            label.hidden = true
            label.backgroundColor = UIColor.clearColor()
            label.textColor = labelTextColor
            label.textAlignment = NSTextAlignment.Center

            if let dataSource = dataSource {
                label.text = dataSource.textsForRangeSelector(self, atIndex: i)
            }else {
                label.text = ""
            }
            addSubview(label)
            labels?.append(label)
        }
    }

    private func addAllSubViews() {
        addSubview(unHighlightedView)
        addSubview(startThumbView)
        addSubview(endThumbView)
        unHighlightedView.addSubview(highlightedView)
    }

    private func addGesture() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(RangeSelector.handlePan(_:)))
        addGestureRecognizer(gestureRecognizer)
    }



    func handlePan(gesture: UIPanGestureRecognizer) {
        let state = gesture.state
        let locationInView = gesture.locationInView(self)

        if state == UIGestureRecognizerState.Began {

            if CGRectContainsPoint(startThumbView.frame, CGPoint(x: locationInView.x, y: locationInView.y)) {
                shouldMoveStartThumb = true
                shouldMoveEndThumb = false
                startThumbView.animateTheOpacity(true)
            } else if CGRectContainsPoint(endThumbView.frame, CGPoint(x: locationInView.x, y: locationInView.y)) {
                shouldMoveStartThumb = false
                shouldMoveEndThumb = true
                endThumbView.animateTheOpacity(true)
            }
            didTapOnTheViewInLocation(locationInView)
        }
        if state == UIGestureRecognizerState.Changed {
            moveTheThumbsToPoint(locationInView)
        } else if state == UIGestureRecognizerState.Ended || state == UIGestureRecognizerState.Failed || state == UIGestureRecognizerState.Cancelled  {

            moveToRespectivePositions()

            shouldMoveEndThumb = false
            shouldMoveStartThumb = false
            endThumbView.animateTheOpacity(false)
            startThumbView.animateTheOpacity(false)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touchesStart = event?.allTouches()
        let touch = touchesStart?.first
        let location = touch?.locationInView(self)

        if let locationInView = location {
            if CGRectContainsPoint(startThumbView.frame, CGPoint(x: locationInView.x , y: locationInView.y)) {
                shouldMoveStartThumb = true
                shouldMoveEndThumb = false
                startThumbView.animateTheOpacity(true)
            } else if CGRectContainsPoint(endThumbView.frame, CGPoint(x: locationInView.x, y: locationInView.y)) {
                shouldMoveStartThumb = false
                shouldMoveEndThumb = true
                endThumbView.animateTheOpacity(true)
            }
            didTapOnTheViewInLocation(locationInView)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        endThumbView.animateTheOpacity(false)
        startThumbView.animateTheOpacity(false)
    }

    private func moveTheThumbsToPoint(point : CGPoint) {
        if shouldMoveStartThumb {
            startThumbView.animateTheOpacity(true)
            if canMoveStartThumbToPoint(point) {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.placeStartThumb(inPosition: point)
                    self.previoslyMovedView = PreviouslyMoved.Start
                    self.highlightTheHighlightView(fromPosition: point.x, toPosition: CGRectGetMidX(self.endThumbView.frame))
                    self.changeTheStateOfDotViews()
                })
            }

        } else if shouldMoveEndThumb {
            endThumbView.animateTheOpacity(true)
            if canMoveEndThumbToPoint(point) {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.placeEndThumb(inPosition: point)
                    self.previoslyMovedView = PreviouslyMoved.End
                    self.highlightTheHighlightView(fromPosition: CGRectGetMidX(self.startThumbView.frame), toPosition: point.x)
                    self.changeTheStateOfDotViews()
                })
            }
        }
    }

    private func didTapOnTheViewInLocation(location: CGPoint) {
        for view in dotViews {
            let viewIndex = dotViews.indexOf(view)

            if CGRectContainsPoint(view.frame, location) {
                if !(abs(viewIndex! - startIndex) == abs(viewIndex! - endIndex)) {
                    if isViewIsNearerToTheStartThumb(view) {

                        UIView.animateWithDuration(0.1, animations: { () -> Void in
                            self.placeStartThumb(inPosition: view.center)
                            self.highlightTheHighlightView(fromPosition: view.center.x, toPosition: CGRectGetMidX(self.endThumbView.frame))
                            self.changeTheStateOfDotViews()

                        })
                        previoslyMovedView = PreviouslyMoved.Start
                        startIndex = viewIndex!
                        highlightTheLabelsAtIndexes([startIndex , endIndex])

                        return
                    } else {
                        UIView.animateWithDuration(0.1, animations: { () -> Void in
                            self.placeEndThumb(inPosition: view.center)
                            self.highlightTheHighlightView(fromPosition: CGRectGetMidX(self.startThumbView.frame), toPosition: view.center.x)
                            self.changeTheStateOfDotViews()

                        })
                        previoslyMovedView = PreviouslyMoved.End
                        endIndex = viewIndex!
                        highlightTheLabelsAtIndexes([startIndex , endIndex])

                        return
                    }
                } else {
                    if let prevMoved = previoslyMovedView {

                        if prevMoved == .Start {

                            UIView.animateWithDuration(0.1, animations: { () -> Void in
                                self.placeStartThumb(inPosition: view.center)
                                self.highlightTheHighlightView(fromPosition: view.center.x, toPosition: CGRectGetMidX(self.endThumbView.frame))
                                self.changeTheStateOfDotViews()
                            })
                            previoslyMovedView = PreviouslyMoved.Start
                            startIndex = viewIndex!
                            highlightTheLabelsAtIndexes([startIndex , endIndex])


                            return
                        } else if prevMoved == .End {
                            UIView.animateWithDuration(0.1, animations: { () -> Void in
                                self.placeEndThumb(inPosition: view.center)
                                self.highlightTheHighlightView(fromPosition: CGRectGetMidX(self.startThumbView.frame), toPosition: view.center.x)
                                self.changeTheStateOfDotViews()

                            })
                            previoslyMovedView = PreviouslyMoved.End
                            endIndex = viewIndex!
                            highlightTheLabelsAtIndexes([startIndex , endIndex])
                            return
                        }
                    }
                }
            }
        }
    }

    private func isViewIsNearerToTheStartThumb(view:UIView)-> Bool {
        let differenceStart = fabs(view.center.x - startThumbView.center.x)
        let differenceEnd = fabs(view.center.x - endThumbView.center.x)

        return differenceStart < differenceEnd
    }

    func reloadData(withAnimation animation : Bool) {
        if let dataSource = dataSource {
            noOfSegments = dataSource.numberOfSegmentsForRangeSelector(self)
            startIndex = dataSource.startIndexForRangeSelector(self)
            if dataSource.endIndexForRangeSelector(self) >= noOfSegments {
                endIndex = noOfSegments - 1
            } else {
                endIndex = dataSource.endIndexForRangeSelector(self)
            }

            if animation {

                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.setupLabels()
                    self.reloadDataInternally()
                })
            } else {
                setupLabels()
                reloadDataInternally()
            }
        }
    }
}

//MARK: generic method

extension RangeSelector {
    private func setupViews<T>(views:[T]) {
        for v in views {
            let view = v as? UIView
            view?.layer.cornerRadius = Constants.width / 2
            view?.layer.borderColor = highlightedColor.CGColor
            view?.layer.borderWidth = 2.f
            view?.backgroundColor = UIColor.clearColor()
        }
    }
}

//MARK: Frame calculation methods

extension RangeSelector {
    private func getTheDistanceBetweenSegments() -> CGFloat {
        layoutIfNeeded()
        return (unHighlightedView.bounds.width) / (noOfSegments.f - 1)
    }

    private func getFrameForIndex(index : Int ,withWidth width : CGFloat) -> CGRect {
        let originPontX = getTheDistanceBetweenSegments() * index.f + kPadding - width / 2.f
        let midY = CGRectGetMidY(bounds) - width / 2.f

        return CGRect(x: originPontX , y: midY , width: width, height: width)
    }
    private func getTheCenterPositionForIndex(index: Int) -> CGPoint {
        let centerPontX = getTheDistanceBetweenSegments() * index.f + kPadding
        let midY = CGRectGetMidY(bounds)
        return CGPoint(x: centerPontX, y: midY)
    }
    private func getTheOriginForIndex(index : Int) -> CGPoint {
        let originPointX = getTheDistanceBetweenSegments() * index.f
        let midY = thicknessForHighlightedView / 2.f

        return CGPoint(x: originPointX, y: midY)
    }

    private func canMoveStartThumbToPoint(point:CGPoint) -> Bool{

        let diff = fabs(endThumbView.center.x - point.x)

        var ret = true

        if (endThumbView.center.x - startThumbView.center.x) >= getTheDistanceBetweenSegments() - 1.f && !(point.x < kPadding) && diff >= getTheDistanceBetweenSegments() && point.x < endThumbView.center.x {
            ret = true
        } else {
            ret = false
        }

        return ret
    }

    private func canMoveEndThumbToPoint(point:CGPoint) -> Bool {

        let diff = fabs(startThumbView.center.x - point.x)
        var ret = true

        if (endThumbView.center.x - startThumbView.center.x)  >= getTheDistanceBetweenSegments() - 1.f && !(point.x > unHighlightedView.bounds.width + kPadding) && diff >= getTheDistanceBetweenSegments() && point.x > startThumbView.center.x {
            ret = true
        } else {
            ret = false
        }

        return ret
    }

    //TODO: implement this
    private func moveToRespectivePositions() {

        if shouldMoveStartThumb {
            moveStartThumbToNearestposition()

        }else if shouldMoveEndThumb {

            moveEndThumbToNearestPosition()

        }
    }

    //TODO: implement this
    private func changeTheStateOfDotViews() {

        for view in dotViews{
            let index = dotViews.indexOf(view)
            let frame = CGRect(x: view.frame.origin.x - kPadding , y: view.frame.origin.y - CGRectGetMidY(bounds) + sizeForDotView / 2, width: view.bounds.width, height: view.bounds.height)

            if CGRectIntersectsRect(frame, highlightedView.frame) {
                view.colorForDotView = highlightedColor
            } else {
                view.colorForDotView = unhighlightedColor
            }

            if index == startIndex || index == endIndex {
                view.userInteractionEnabled = false
            } else {
                view.userInteractionEnabled = true
            }
        }
    }
}

//MARK: placing start thumb and endthumb

extension RangeSelector {

    private func placeStartThumb(inPosition postion: CGPoint){
        startThumbView.center.x = postion.x
    }
    private func placeEndThumb(inPosition postion: CGPoint){
        endThumbView.center.x = postion.x
    }

    private func placeStartThumb(toFrame frame : CGRect ){
        startThumbView.frame = frame
    }

    private func placeEndthumb(toFrame frame: CGRect){
        endThumbView.frame = frame
    }

    private func highlightTheHighlightView(fromPosition start : CGFloat , toPosition end : CGFloat) {

        let width = fabs(start - end)
        let originY = 0.f

        highlightedView.frame = CGRect(x: start - kPadding , y: originY, width: width, height: thicknessForHighlightedView)

    }

    private func moveEndThumbToNearestPosition() {

        let div = getTheDistanceBetweenSegments() / 2

        if endIndex - startIndex >= 1 {
            for i in 0..<dotViews.count-1 {
                if isEndThumbIsBetweenDots(dotViews[i], dot2: dotViews[i+1]) {
                    let diff1 = fabs(endThumbView.center.x - dotViews[i].center.x)
                    let diff2 = fabs( dotViews[i + 1].center.x - endThumbView.center.x)
                    var index = i

                    if diff1 < div {
                        index = i

                    }else if diff2 < div {
                        index = i + 1
                    }
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.placeEndThumb(inPosition: self.dotViews[index].center)
                        self.highlightTheHighlightView(fromPosition: CGRectGetMidX(self.startThumbView.frame), toPosition: self.dotViews[index].center.x)
                        self.changeTheStateOfDotViews()
                        }, completion: { (bool) -> Void in
                    })
                    endIndex = index
                    highlightTheLabelsAtIndexes([startIndex , endIndex])
                    delegate?.rangeSelector(self, movedFromIndex: startIndex, toIndex: endIndex)
                    previoslyMovedView = PreviouslyMoved.End
                }
            }
        }
    }

    private func moveStartThumbToNearestposition() {

        let div = getTheDistanceBetweenSegments() / 2

        if (endThumbView.center.x - startThumbView.center.x) >= getTheDistanceBetweenSegments() {

            for dotIndex in 0..<dotViews.count-1 {
                if isStartThumbIsBetweenDots(dotViews[dotIndex], dot2: dotViews[dotIndex + 1]) {

                    let diff1 = fabs(startThumbView.center.x - dotViews[dotIndex].center.x)
                    let diff2 = fabs(dotViews[dotIndex + 1].center.x - startThumbView.center.x)
                    var index = dotIndex

                    if diff1 < div {
                        index = dotIndex
                    } else if diff2 < div {
                        index = dotIndex + 1
                    }
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.placeStartThumb(inPosition: self.dotViews[index].center)
                        self.highlightTheHighlightView(fromPosition: self.startThumbView.center.x, toPosition: CGRectGetMidX(self.endThumbView.frame))
                        self.changeTheStateOfDotViews()
                        }, completion:  {(bool) -> Void in
                    })
                    startIndex = index
                    highlightTheLabelsAtIndexes([startIndex , endIndex])
                    delegate?.rangeSelector(self, movedFromIndex: startIndex, toIndex: endIndex)
                    previoslyMovedView = PreviouslyMoved.Start
                }
            }
        }
    }

    private func isStartThumbIsBetweenDots(dot1 : UIView, dot2: UIView ) -> Bool {
        let ret = startThumbView.center.x > dot1.center.x && startThumbView.center.x < dot2.center.x
        return ret
    }

    private func isEndThumbIsBetweenDots(dot1: UIView , dot2: UIView) -> Bool {
        let ret = endThumbView.center.x > dot1.center.x && endThumbView.center.x < dot2.center.x
        return ret
    }

    private func highlightTheLabelsAtIndexes(indexes : [Int]) {

        if let labels = labels {

            for i in 0..<noOfSegments {
                labels[i].hidden = true
            }
            for i in 0..<indexes.count {
                labels[indexes[i]].hidden = false
            }
        }
    }
}

class DotView: FlashView {
    private var dotView = UIView()
    var sizeForDot = 13.f
    var colorForDotView = UIColor.greenColor() {
        didSet {
            dotView.backgroundColor = colorForDotView
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearence()
    }
    private func setupAppearence() {

        dotView.frame = CGRect(x: CGRectGetMidX(bounds) - sizeForDot / 2.f, y: CGRectGetMidY(bounds) - sizeForDot / 2.f, width: sizeForDot, height: sizeForDot)
        dotView.layer.cornerRadius = sizeForDot / 2.f
        dotView.backgroundColor = colorForDotView
        addSubview(dotView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dotView.frame = CGRect(x: CGRectGetMidX(bounds) - sizeForDot / 2.f, y: CGRectGetMidY(bounds) - sizeForDot / 2.f, width: sizeForDot, height: sizeForDot)
    }
}

class ThumbView: FlashView {
    private var circleShapeLayer = CAShapeLayer()
    var colorForDot = UIColor.greenColor() {
        didSet {
            circleShapeLayer.fillColor = colorForDot.CGColor
        }
    }

    override func layoutSubviews() {
        circleShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds)), radius: 6.5.f, startAngle: 0.f, endAngle: 2 * M_PI.f, clockwise: true).CGPath
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearence()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAppearence()
    }

   private func setupAppearence() {
        addCircleLayer()
    }

    private func addCircleLayer() {

        circleShapeLayer.frame = bounds

        circleShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds)), radius: 6.5.f, startAngle: 0.f, endAngle: 2 * M_PI.f, clockwise: true).CGPath
        circleShapeLayer.position = CGPoint(x: CGRectGetMidX(bounds), y:CGRectGetMidY(bounds))
        circleShapeLayer.fillColor = colorForDot.CGColor

        layer.masksToBounds = false
        layer.addSublayer(circleShapeLayer)
    }
}


class FlashView: UIView {
    private var flashLayer = CAShapeLayer()
    private var button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addFlashLayer()
        button.frame = bounds
        button.backgroundColor = UIColor.clearColor()

        addSubview(button)
//        button.addTarget(self, action: "animateTheFlashLayer:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    private func addFlashLayer() {
        flashLayer.frame = bounds
        flashLayer.path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: CGRectGetWidth(bounds), height: CGRectGetWidth(bounds))).CGPath
        flashLayer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        flashLayer.opacity = 0.0
        if !(backgroundColor == UIColor.clearColor()) {
            flashLayer.fillColor = backgroundColor?.colorWithAlphaComponent(0.1).CGColor
        } else {
            flashLayer.fillColor = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        }
    }

    func animateTheFlashLayer(sender : UIButton ) {

        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.0, 1.0, 0.0]
        opacityAnimation.duration = 0.3
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        flashLayer.addAnimation(opacityAnimation, forKey: "TouchFadeAnimation")

        let transform = CATransform3DMakeScale(1.2, 1.2, 1.2)

        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = NSValue(CATransform3D: transform)
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        scaleAnimation.duration = 0.3
        flashLayer.addAnimation(scaleAnimation, forKey: "TouchScaleAnimation")
    }

    func animateTheOpacity(bool: Bool) {
        alpha = bool ? 0.5 : 1.0
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

