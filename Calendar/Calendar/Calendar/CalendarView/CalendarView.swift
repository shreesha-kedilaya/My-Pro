//
//  CalendarView.swift
//  Calendar
//
//  Created by Shreesha on 12/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

enum Months : Int {
    case January = 1,
    February,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December

    func name() -> String {
        return "\(self)"
    }
}

enum Week : Int{
    case Sunday = 1,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday

    func name(style : WeekStyles, casingStyle : CasingStyle) -> String {

        var range = Range(0...0)
        switch style {
        case .One:
            range = 0...0
        case .Two:
            range = 0...1
        case .Three :
            range = 0...2
        default :
            range = 0...("\(self)".characters.count - 1)
        }

        return casingStyle.letter("\(self)"[range])
    }
}
enum WeekStyles : Int{
    case One = 10,
    Two,
    Three,
    Full
}

enum CasingStyle {
    case FirstLetterUpper,
    AllUpper,
    AllLower

    func letter(forString : String) -> String {
        switch self {
        case .FirstLetterUpper:
            return forString
        case .AllLower:
            return forString.lowercaseString
        case .AllUpper :
            return forString.uppercaseString
        }
    }
}

enum PanningDirection: Equatable {

    case Forward
    case Backward
}

func ==(lhs: PanningDirection, rhs: PanningDirection) -> Bool {

    var retVal = false

    switch lhs {
    case .Forward:

        switch rhs {
        case .Forward:
            retVal = true
        case .Backward:
            retVal = false
        }

    case .Backward:
        switch rhs {
        case .Forward:
            retVal = false
        case .Backward:
            retVal = true
        }
    }

    switch (lhs, rhs) {
    case (.Forward, .Forward):
        retVal = true
    default:
        break
    }

    return retVal
}

class CalendarView: UIView {


    //MARK:Private properties

    private var calendarCollectionView : UICollectionView!
    private var calendarPanGesture : UILongPressGestureRecognizer!
    private let kDefaultNumberOfSections = 5
    private var initialDateIndex = 0

    private var presentingDay = 0
    private var presentingMonth = 0
    private var presentingYear = 0

    private var numberOfIterations = 0
    private let kCellsVisibleToTheUser = 3
    private let kNumberOfDaysInAWeek = 7
    private var scrolledInitially = false

    enum BoundaryPositions : Int {
        case Forward = 1,
        Backward
    }
    private var flowLayout : CalendarFlowLayout?

    private let kNumberOfSections = 5
    private var currentSection = 0
    private var currentMonth = 0
    private var currentYear = 0
    private var collectionViewWidth: CGFloat!
    private var collectionViewHeight: CGFloat!
    private var weekLabels : [UILabel]!
    private var yearMonthButton : UIButton!
    private var panningDirection = PanningDirection.Forward
    private var panStartingIndexPath = NSIndexPath(forItem: 0, inSection: 0)

    private var currentPanningPoint = CGPoint(x: 0, y: 0)
    private var currentPanningIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    private var startPanningPoint = CGPoint(x: 0, y: 0)
    private var shouldChangeDirection = true

    //MARK:Public properties

    //Here either you can give the staring year or the starting year limit either of them gives the result
    //These things states the range of the calendar from-to
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    var startingYearLimit = 0 // the value should be minus if the calendar should show the year limit of the previous year/years
    var endingYearLimit = 20
    var startingYear : NSDate?
    var endingYear : NSDate?

    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    var presentingDate = NSDate() {
        didSet {
            changeTheDateComponent()
            reloadData()
        }
    }
    var highlightCurrentDate = true {
        didSet {
            reloadData()
        }
    }

    var dateGenerator :DateGenerator?

    //MARK : Initializers and awake from nib
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func awakeFromNib(){
        super.awakeFromNib()
        sharedInit()
    }

    private func sharedInit() {

        backgroundColor = UIColor.blueColor()
        addAttributesToFlowLayout()


        if let calendarCollectionView = calendarCollectionView {
            calendarCollectionView.backgroundColor = UIColor.blueColor()
            calendarCollectionView.delegate = self
            calendarCollectionView.frame = bounds
            calendarCollectionView.dataSource = self
            calendarCollectionView.pagingEnabled = true
            calendarCollectionView.backgroundColor = UIColor.blueColor()
            calendarCollectionView.registerClass(CalendarViewCell.self, forCellWithReuseIdentifier: "Cell")
        }

        createMonthAndYearLabels()

        addSubviews()
        addConstraints()

        //The week labels should be created after the calendar is initialized
        createWeekLabels()

        createTheDateGenerator()
        changeTheDateComponent()

        addLongGestureToTheCollectionView()
        changeTheTextOfYearMonthLabel()
    }

    private func createMonthAndYearLabels() {

        if yearMonthButton == nil {

            yearMonthButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width / 2, height: 30))
            yearMonthButton.setTitle("Jan 2016", forState: .Normal)

            yearMonthButton.titleLabel?.textColor = UIColor.whiteColor()
            yearMonthButton.backgroundColor = UIColor.blueColor()
            yearMonthButton.translatesAutoresizingMaskIntoConstraints = false
            yearMonthButton.titleLabel?.textAlignment = .Center
            yearMonthButton.addTarget(self, action: #selector(CalendarView.yearMonthButtonDidClick(_:)), forControlEvents: .TouchUpInside)
        }
    }

    func yearMonthButtonDidClick(sender : UIButton) {
        print("Year month button clicked")
    }
    //MARK: creating the week labels
    private func createWeekLabels() {

        if let weekLabels = weekLabels {
            for label in weekLabels {
                label.removeFromSuperview()
            }
        }
        weekLabels = []

        for index in 0..<kNumberOfDaysInAWeek {
            let label = UILabel()
            if let text = Week(rawValue: index + 1)?.name(.Three, casingStyle: .AllUpper) {
                label.text = text
            }
            label.font = UIFont.systemFontOfSize(14)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = UIColor.blueColor()
            label.frame = CGRect(x: index.f * bounds.width / kNumberOfDaysInAWeek.f , y: 0, width: bounds.width / kNumberOfDaysInAWeek.f, height: 30)
            addSubview(label)


            //adding constraint to week labels
            var topConstraint : NSLayoutConstraint
            var bottomConstraint : NSLayoutConstraint
            var leadingConstraint : NSLayoutConstraint
            var trailingConstraint : NSLayoutConstraint?

            switch index {
            //first item
            case 0:

                topConstraint = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: yearMonthButton, attribute: .Bottom, multiplier: 1, constant: 10)
                bottomConstraint = NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: calendarCollectionView, attribute: .Top, multiplier: 1, constant: 0)
                leadingConstraint = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0)
                //No trailing constraint required

            //Last label
            case kNumberOfDaysInAWeek-1:

                topConstraint = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: yearMonthButton, attribute: .Bottom, multiplier: 1, constant: 10)
                bottomConstraint = NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: calendarCollectionView, attribute: .Top, multiplier: 1, constant: 0)
                leadingConstraint = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem:weekLabels[index-1] , attribute: .Trailing, multiplier: 1, constant: 0)
                trailingConstraint = NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)

            default :

                topConstraint = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: yearMonthButton, attribute: .Bottom, multiplier: 1, constant: 10)
                bottomConstraint = NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: calendarCollectionView, attribute: .Top, multiplier: 1, constant: 0)
                leadingConstraint = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: weekLabels[index-1], attribute: .Trailing, multiplier: 1, constant: 0)

            }

            let widthAttribute = NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: bounds.width / kNumberOfDaysInAWeek.f)
            widthAttribute.priority = 900
            if let trailingConstraint = trailingConstraint {
                addConstraint(trailingConstraint)
            }
            addConstraints([leadingConstraint,topConstraint,bottomConstraint])
            label.addConstraint(widthAttribute)
            weekLabels.append(label)
        }
    }

    private func addLongGestureToTheCollectionView() {
        if let _ = calendarPanGesture {

        } else {
            calendarPanGesture = UILongPressGestureRecognizer(target: self, action: #selector(CalendarView.handleLongGesture(_:)))
        }

        calendarCollectionView.addGestureRecognizer(calendarPanGesture)

        calendarPanGesture.minimumPressDuration = 0.3
        calendarPanGesture.delegate = self
        calendarPanGesture.allowableMovement = max(bounds.size.height, bounds.size.width)
        calendarPanGesture.enabled = true
    }


    //MARK: Handling the long gesture recognizer

    func handleLongGesture(gestureRecognizer : UILongPressGestureRecognizer) {

        let state = gestureRecognizer.state

        let locationInView = gestureRecognizer.locationInView(calendarCollectionView)

        switch state {
        case .Began:
            calendarCollectionView.scrollEnabled = false
            highlightTheCellAtPoint(locationInView, isStartingPoint: true)
        case .Changed:

            if shouldChangeDirection {
                panningDirection = pointIsGreaterThanCurrentPoint(locationInView) ? .Forward : .Backward
                shouldChangeDirection = false
            }

            calendarCollectionView.scrollEnabled = false
            highlightTheCellAtPoint(locationInView, isStartingPoint: false)
        case .Ended:
            calendarCollectionView.scrollEnabled = true
            shouldChangeDirection = true
        case .Cancelled ,.Failed:
            calendarCollectionView.scrollEnabled = true
            shouldChangeDirection = true
        default :
            calendarCollectionView.scrollEnabled = true
            shouldChangeDirection = true
        }
    }

    private func highlightTheCellAtPoint(point : CGPoint, isStartingPoint : Bool) {

        guard let indexPath = calendarCollectionView.indexPathForItemAtPoint(point) else {
            return
        }
        if isStartingPoint {
            panStartingIndexPath = indexPath
            currentPanningIndexPath = indexPath
            startPanningPoint = point
        }
        let cell = calendarCollectionView.cellForItemAtIndexPath(indexPath) as? CalendarViewCell

//        let rowColumn = getTheCurrentRowColumnFor(indexPath)

//        let row = rowColumn.0
//        let column = rowColumn.1

        var highlight = false

//        let previousPanningDirection = panningDirection

//        switch pointIsGreaterThanCurrentPoint(point) {
//
//        case true:
//            panningDirection = .Forward(atPoint: point)
//        case false:
//            panningDirection = .Backward(atPoint: point)
//        }


        highlight = panningDirection == .Forward ? pointIsGreaterThanCurrentPoint(point) : !pointIsGreaterThanCurrentPoint(point)

        if panningDirection == .Forward {
            shouldChangeDirection = pointIsGreaterThanStartingPoint(point) ? false : true
        } else {
            shouldChangeDirection = pointIsGreaterThanStartingPoint(point) ? true : false
        }
        
        currentPanningPoint = point


        if let cell = cell {
            if !(currentPanningIndexPath == indexPath) || indexPath == panStartingIndexPath{
                cell.highlightedItem = indexPath == panStartingIndexPath ? true :  highlight
            }
        }
        currentPanningIndexPath = indexPath
    }

    private func pointIsGreaterThanCurrentPoint(point : CGPoint) -> Bool {
        var retVal = true
        if point.x >= currentPanningPoint.x {
            retVal = true
        } else if point.x < currentPanningPoint.x {
            retVal = false
        }
        return retVal
    }
    private func pointIsGreaterThanStartingPoint(point : CGPoint) -> Bool {
        var retVal = true
        if point.x >= startPanningPoint.x {
            retVal = true
        } else if point.x < startPanningPoint.x {
            retVal = false
        }
        return retVal
    }

    private func getTheCurrentRowColumnFor(indexPath : NSIndexPath) -> (Int, Int) {
        nsDateComponents.day = 1
        nsDateComponents.month = currentMonth
        nsDateComponents.year = currentYear

        let firstDay = dateComponent.startingRangeOfDay()

        let thePresentDayTotal = firstDay + indexPath.item
        let thePresentRow = thePresentDayTotal % 7
        let column = thePresentDayTotal / dateComponent.getNumberOfWeekForCurrentDate()
        return (thePresentRow,column)

    }
    func createTheDateGenerator() {

        //Creating the starting year according to the startingYearLimit

        if let _ = startingYear, _ = endingYear {

        } else {
            dateGenerator?.delegate = self
            if let dateGenerator = dateGenerator {
                initialDateIndex = dateGenerator.getInitialIndexForDate(NSDate()) ?? 0
            }
            nsDateComponents.year = startingYearLimit
            let yearMinus20 = nsDateComponents
            startingYear = calendar.dateByAddingComponents(yearMinus20, toDate: presentingDate, options: .WrapComponents)

            //Creating the starting year according to the endingYearLimit
            nsDateComponents.year = endingYearLimit
            let yearPlus20 = nsDateComponents
            endingYear = calendar.dateByAddingComponents(yearPlus20, toDate: presentingDate, options: .WrapComponents)
        }

        if let startingYear = startingYear , endingYear = endingYear {

            if dateGenerator == nil {
                dateGenerator = DateGenerator(startingDate: startingYear, endingDate: endingYear, delegate : self)
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout?.itemSize = CGSize(width: bounds.size.width / 7, height: bounds.size.height / 5)
        collectionViewWidth = calendarCollectionView.frame.size.width
        collectionViewHeight = calendarCollectionView.frame.size.height
        createWeekLabels()

        if let layout = flowLayout {
            calendarCollectionView.collectionViewLayout = layout
        }

        scrollInitially()
    }

    private func scrollInitially() {
        if !scrolledInitially {
            calendarCollectionView.setContentOffset(CGPoint(x: calendarCollectionView.bounds.width, y: 0.f), animated: false)
            scrolledInitially = true
        }
    }
    private func addAttributesToFlowLayout() {

        if let _ = calendarCollectionView {
            calendarCollectionView.removeFromSuperview()
            self.calendarCollectionView = nil
        }
        if let _ = flowLayout {
        } else {
            flowLayout = CalendarFlowLayout()
        }

        flowLayout?.scrollDirection = .Horizontal
        flowLayout?.itemSize = CGSize(width: bounds.size.width / 7, height: bounds.size.height / 5)
        flowLayout?.minimumInteritemSpacing = 0.0
        flowLayout?.minimumLineSpacing = 0.0

        //TODO : remove the horizontal scroll indicator

        if let flowLayout = flowLayout {
            calendarCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
            calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionViewWidth = calendarCollectionView.frame.size.width
            collectionViewHeight = calendarCollectionView.frame.size.height
        }
    }

    private func addSubviews() {
        if let calendarCollectionView = calendarCollectionView {
            addSubview(calendarCollectionView)
        }
        addSubview(yearMonthButton)
    }

    private func addConstraints() {
        addConstraintToCalendar()
        addConstraintToMonthAndYearLabels()
    }

    private func addConstraintToMonthAndYearLabels() {

        let topConstraint = NSLayoutConstraint(item: yearMonthButton, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: yearMonthButton, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 10)
        let heightConstraint = NSLayoutConstraint(item: yearMonthButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30)

        addConstraints([topConstraint, leadingConstraint])
        yearMonthButton.addConstraint(heightConstraint)
    }
    //MARK: adding constraint calendar collection view and self
    private func addConstraintToCalendar() {
        if let calendarCollectionView = calendarCollectionView {

            let leading = NSLayoutConstraint(item: calendarCollectionView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0)
            let traling = NSLayoutConstraint(item: calendarCollectionView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0)
            let bottom = NSLayoutConstraint(item: calendarCollectionView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)

            addConstraints([leading,traling,bottom])
        }
    }

    func reloadData() {
        dispatch_async(dispatch_get_main_queue()) {
            self.calendarCollectionView.reloadData()
        }
    }
}

extension CalendarView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        nsDateComponents.day = 1
        nsDateComponents.month = getCurrentMonthForSection(section, month: true) + 1
        nsDateComponents.year = getCurrentMonthForSection(section, month: false)

        return dateComponent.totalDaysInAMonthForTheCurrentDate()
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CalendarViewCell
        cell.dateButton.setTitle("\(indexPath.item + 1)", forState: .Normal)


        cell.dateButton.backgroundColor = UIColor.blueColor()
        cell.setAsCurrentDateItem = false

        if isPresentDateFor(indexPath){
            cell.dateButton.backgroundColor = UIColor.redColor()
            cell.setAsCurrentDateItem = true
        }
        return cell
    }

    func isPresentDateFor(indexPath : NSIndexPath) -> Bool {
        return (numberOfIterations == getTheCurrentIterationIndexForCurrentDate().0 && indexPath == (getTheCurrentIterationIndexForCurrentDate().1) && highlightCurrentDate)
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let _ = dateGenerator {
            return kDefaultNumberOfSections
        }
        return 0
    }

    //Gives the current date index and the iteration index for the present day
    private func getTheCurrentIterationIndexForCurrentDate() -> (Int, NSIndexPath) {

        dateComponent.changeDateComponentsForDate(presentingDate)
        let year1 = nsDateComponents.year
        let month1 = nsDateComponents.month

        dateComponent.changeDateComponentsForDate(NSDate())
        let year2 = nsDateComponents.year
        let day2 = nsDateComponents.day
        let month2 = nsDateComponents.month

        let yearDifference = year1 - year2
        let differenceBWMonths = (yearDifference * (12 - month1 + 12 - month2))

        let currentNumberOfIterationForCurrentDay = floor(differenceBWMonths.f / 3)

        let currentMonthIndex = differenceBWMonths % 3 + 1
        let indexPath = NSIndexPath(forItem: day2 - 1, inSection: currentMonthIndex)


        return (Int(currentNumberOfIterationForCurrentDay), indexPath)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }

    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

    }

    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

    }

    func scrollViewDidScroll(scrollView: UIScrollView) {

    }

    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        //present section will be helpful to calculate the present month

        currentSection = Int(floor(targetContentOffset.memory.x / calendarCollectionView.bounds.width)) + 1

        currentMonth = getCurrentMonthForSection(currentSection - 1, month: true) + 1
        currentYear = getCurrentMonthForSection(currentSection - 1, month: false)

        if currentSection.f >= kDefaultNumberOfSections.f {

            //set the content offset of the collection view to the initial section after some time say 0.15 seconds to look the scroll animation look smoother
            numberOfIterations += 1
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.15 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.reloadCollectionViewAttributesFor(.Forward)
            }
        }else if currentSection <= 1 {

            numberOfIterations -= 1
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.15 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.reloadCollectionViewAttributesFor(.Backward)
            }
        }

        changeTheTextOfYearMonthLabel()
    }

    private func changeTheTextOfYearMonthLabel() {

        UIView.animateWithDuration(0.2, animations: { 
            self.yearMonthButton.alpha = 0
            }) { (completion) in
                UIView.animateWithDuration(0.2, animations: { 
                    self.yearMonthButton.alpha = 1.0
                    if let name = Months(rawValue: self.currentMonth)?.name() {
                        self.yearMonthButton.setTitle("\(name) \(self.currentYear)", forState: .Normal)
                    }
                })
        }
    }

    private func reloadCollectionViewAttributesFor(position : BoundaryPositions){

        //dispatch every UI updates in the main queue

        dispatch_async(dispatch_get_main_queue()) {
            var positionPoint = CGPointZero
            switch position {
            case .Backward:

                let contentSize = self.calendarCollectionView.contentSize
                self.calendarCollectionView.setContentOffset(CGPoint(x: contentSize.width.f - 2 * self.collectionViewWidth, y: 0.f), animated: false) //2* collectionViewWidth because to the second section the width = 2 * the collection view width

            case .Forward:

                positionPoint = CGPoint(x: self.calendarCollectionView.bounds.width, y: 0.f)
                self.calendarCollectionView.setContentOffset(positionPoint, animated: false)
            }

            self.reloadData()
            self.flowLayout?.currentIterationIndex = self.numberOfIterations
            self.flowLayout?.invalidateLayout()
        }
    }
}


extension CalendarView : DateGeneratorDelegate {
    func dateGeneratorDidFinishUpatingTheDates(generator: DateGenerator) {
        reloadData()
    }
}

//MARK : Date related calculation
extension CalendarView {
    private func getCurrentMonthForSection(section : Int, month : Bool) -> Int{
        switch month {
        case true:
            let retMonth = (section + presentingMonth + rangeOfMonthToBeAdded() - 1) % 12
            return retMonth
        case false:
            let retYear = presentingYear.f + floor((section.f + presentingMonth.f + rangeOfMonthToBeAdded().f - 1.f) / 12.f)
            return Int(retYear)
        }
    }
    
    private func changeTheDateComponent() {
        dateComponent.changeDateComponentsForDate(presentingDate)
        presentingDay = nsDateComponents.day
        presentingMonth = nsDateComponents.month
        
        currentMonth = presentingMonth
        currentYear = presentingYear
        
        presentingYear = nsDateComponents.year
        
        flowLayout?.presentingMonth = presentingMonth
        flowLayout?.presentingYear = presentingYear
    }
    
    private func rangeOfMonthToBeAdded() -> Int {
        return numberOfIterations * kCellsVisibleToTheUser - 1
    }
}
extension CalendarView : UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
}