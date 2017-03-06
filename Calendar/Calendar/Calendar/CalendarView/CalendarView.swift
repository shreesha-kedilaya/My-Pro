//
//  CalendarView.swift
//  Calendar
//
//  Created by Shreesha on 12/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

enum Months : Int {
    case january = 1,
    february,
    march,
    april,
    may,
    june,
    july,
    august,
    september,
    october,
    november,
    december

    func name() -> String {
        return "\(self)"
    }
}

enum Week : Int{
    case sunday = 1,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday

    func name(_ style : WeekStyles, casingStyle : CasingStyle) -> String {

        var range = ClosedRange(0...0)
        switch style {
        case .one:
            range = 0...0
        case .two:
            range = 0...1
        case .three :
            range = 0...2
        default :
            range = 0...("\(self)".characters.count - 1)
        }

        return casingStyle.letter("\(self)"[range])
    }
}
enum WeekStyles : Int{
    case one = 10,
    two,
    three,
    full
}

enum CasingStyle {
    case firstLetterUpper,
    allUpper,
    allLower

    func letter(_ forString : String) -> String {
        switch self {
        case .firstLetterUpper:
            return forString
        case .allLower:
            return forString.lowercased()
        case .allUpper :
            return forString.uppercased()
        }
    }
}

enum PanningDirection: Equatable {

    case forward
    case backward
}

func ==(lhs: PanningDirection, rhs: PanningDirection) -> Bool {

    var retVal = false

    switch lhs {
    case .forward:

        switch rhs {
        case .forward:
            retVal = true
        case .backward:
            retVal = false
        }

    case .backward:
        switch rhs {
        case .forward:
            retVal = false
        case .backward:
            retVal = true
        }
    }

    switch (lhs, rhs) {
    case (.forward, .forward):
        retVal = true
    default:
        break
    }

    return retVal
}

class CalendarView: UIView {


    //MARK:Private properties

    fileprivate var calendarCollectionView : UICollectionView!
    fileprivate var calendarPanGesture : UILongPressGestureRecognizer!
    fileprivate let kDefaultNumberOfSections = 5
    fileprivate var initialDateIndex = 0

    fileprivate var presentingDay = 0
    fileprivate var presentingMonth = 0
    fileprivate var presentingYear = 0

    fileprivate var numberOfIterations = 0
    fileprivate let kCellsVisibleToTheUser = 3
    fileprivate let kNumberOfDaysInAWeek = 7
    fileprivate var scrolledInitially = false

    enum BoundaryPositions : Int {
        case forward = 1,
        backward
    }
    fileprivate var flowLayout : CalendarFlowLayout?

    fileprivate let kNumberOfSections = 5
    fileprivate var currentSection = 0
    fileprivate var currentMonth = 0
    fileprivate var currentYear = 0
    fileprivate var collectionViewWidth: CGFloat!
    fileprivate var collectionViewHeight: CGFloat!
    fileprivate var weekLabels : [UILabel]!
    fileprivate var yearMonthButton : UIButton!
    fileprivate var panningDirection = PanningDirection.forward
    fileprivate var panStartingIndexPath = IndexPath(item: 0, section: 0)

    fileprivate var currentPanningPoint = CGPoint(x: 0, y: 0)
    fileprivate var currentPanningIndexPath = IndexPath(item: 0, section: 0)
    fileprivate var startPanningPoint = CGPoint(x: 0, y: 0)
    fileprivate var shouldChangeDirection = true

    //MARK:Public properties

    //Here either you can give the staring year or the starting year limit either of them gives the result
    //These things states the range of the calendar from-to
    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    var startingYearLimit = 0 // the value should be minus if the calendar should show the year limit of the previous year/years
    var endingYearLimit = 20
    var startingYear : Foundation.Date?
    var endingYear : Foundation.Date?

    //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    var presentingDate = Foundation.Date() {
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
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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

    fileprivate func sharedInit() {

        currentSection = 1
        backgroundColor = UIColor.blue
        addAttributesToFlowLayout()


        if let calendarCollectionView = calendarCollectionView {
            calendarCollectionView.backgroundColor = UIColor.blue
            calendarCollectionView.delegate = self
            calendarCollectionView.frame = bounds
            calendarCollectionView.dataSource = self
            calendarCollectionView.isPagingEnabled = true
            calendarCollectionView.backgroundColor = UIColor.blue
            calendarCollectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: "Cell")
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

    fileprivate func createMonthAndYearLabels() {

        if yearMonthButton == nil {

            yearMonthButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width / 2, height: 30))
            yearMonthButton.setTitle("Jan 2016", for: UIControlState())

            yearMonthButton.titleLabel?.textColor = UIColor.white
            yearMonthButton.backgroundColor = UIColor.blue
            yearMonthButton.translatesAutoresizingMaskIntoConstraints = false
            yearMonthButton.titleLabel?.textAlignment = .center
            yearMonthButton.addTarget(self, action: #selector(CalendarView.yearMonthButtonDidClick(_:)), for: .touchUpInside)
        }
    }

    func yearMonthButtonDidClick(_ sender : UIButton) {
        print("Year month button clicked")
    }
    //MARK: creating the week labels
    fileprivate func createWeekLabels() {

        if let weekLabels = weekLabels {
            for label in weekLabels {
                label.removeFromSuperview()
            }
        }
        weekLabels = []

        for index in 0..<kNumberOfDaysInAWeek {
            let label = UILabel()
            if let text = Week(rawValue: index + 1)?.name(.three, casingStyle: .allUpper) {
                label.text = text
            }
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = UIColor.blue
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

                topConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: yearMonthButton, attribute: .bottom, multiplier: 1, constant: 10)
                bottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: calendarCollectionView, attribute: .top, multiplier: 1, constant: 0)
                leadingConstraint = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
                //No trailing constraint required

            //Last label
            case kNumberOfDaysInAWeek-1:

                topConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: yearMonthButton, attribute: .bottom, multiplier: 1, constant: 10)
                bottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: calendarCollectionView, attribute: .top, multiplier: 1, constant: 0)
                leadingConstraint = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem:weekLabels[index-1] , attribute: .trailing, multiplier: 1, constant: 0)
                trailingConstraint = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)

            default :

                topConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: yearMonthButton, attribute: .bottom, multiplier: 1, constant: 10)
                bottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: calendarCollectionView, attribute: .top, multiplier: 1, constant: 0)
                leadingConstraint = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: weekLabels[index-1], attribute: .trailing, multiplier: 1, constant: 0)

            }

            let widthAttribute = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bounds.width / kNumberOfDaysInAWeek.f)
            widthAttribute.priority = 900
            if let trailingConstraint = trailingConstraint {
                addConstraint(trailingConstraint)
            }
            addConstraints([leadingConstraint,topConstraint,bottomConstraint])
            label.addConstraint(widthAttribute)
            weekLabels.append(label)
        }
    }

    fileprivate func addLongGestureToTheCollectionView() {
        if let _ = calendarPanGesture {

        } else {
            calendarPanGesture = UILongPressGestureRecognizer(target: self, action: #selector(CalendarView.handleLongGesture(_:)))
        }

        calendarCollectionView.addGestureRecognizer(calendarPanGesture)

        calendarPanGesture.minimumPressDuration = 0.3
        calendarPanGesture.delegate = self
        calendarPanGesture.allowableMovement = max(bounds.size.height, bounds.size.width)
        calendarPanGesture.isEnabled = true
    }


    //MARK: Handling the long gesture recognizer

    func handleLongGesture(_ gestureRecognizer : UILongPressGestureRecognizer) {

        let state = gestureRecognizer.state

        let locationInView = gestureRecognizer.location(in: calendarCollectionView)

        switch state {
        case .began:
            calendarCollectionView.isScrollEnabled = false
            highlightTheCellAtPoint(locationInView, isStartingPoint: true)
        case .changed:

            if shouldChangeDirection {
                panningDirection = pointIsGreaterThanCurrentPoint(locationInView) ? .forward : .backward
                shouldChangeDirection = false
            }

            calendarCollectionView.isScrollEnabled = false
            highlightTheCellAtPoint(locationInView, isStartingPoint: false)
        case .ended:
            calendarCollectionView.isScrollEnabled = true
            shouldChangeDirection = true
        case .cancelled ,.failed:
            calendarCollectionView.isScrollEnabled = true
            shouldChangeDirection = true
        default :
            calendarCollectionView.isScrollEnabled = true
            shouldChangeDirection = true
        }
    }

    fileprivate func highlightTheCellAtPoint(_ point : CGPoint, isStartingPoint : Bool) {

        guard let indexPath = calendarCollectionView.indexPathForItem(at: point) else {
            return
        }

        let startIndex = panningDirection == .forward ? currentPanningIndexPath.item: indexPath.item
        let endIndex = panningDirection == .forward ? indexPath.item: currentPanningIndexPath.item

        if endIndex > startIndex {
            for item in startIndex...endIndex {
                let cell = calendarCollectionView.cellForItem(at: IndexPath(item: item, section: indexPath.section)) as? CalendarViewCell
                cell?.highlightedItem = false
            }
        }

        if isStartingPoint {
            panStartingIndexPath = indexPath
            currentPanningIndexPath = indexPath
            startPanningPoint = point
        }

        var highlight = false

        highlight = panningDirection == .forward ? pointIsGreaterThanCurrentPoint(point) : !pointIsGreaterThanCurrentPoint(point)

        if panningDirection == .forward {
            shouldChangeDirection = pointIsGreaterThanStartingPoint(point) ? false : true
        } else {
            shouldChangeDirection = pointIsGreaterThanStartingPoint(point) ? true : false
        }

        currentPanningPoint = point

        let start = currentPanningIndexPath.item < panStartingIndexPath.item ? currentPanningIndexPath.item: panStartingIndexPath.item
        let end = currentPanningIndexPath.item > panStartingIndexPath.item ? currentPanningIndexPath.item: panStartingIndexPath.item

        for item in start...end {
            let cell = calendarCollectionView.cellForItem(at: IndexPath(item: item, section: indexPath.section)) as? CalendarViewCell
            cell?.highlightedItem = indexPath == panStartingIndexPath ? true :  highlight
        }

        currentPanningIndexPath = indexPath
    }

    fileprivate func rangeTo(_ point: CGPoint) -> (start: Int, end: Int) {
        let startIndexPath = panStartingIndexPath
        guard let endingIndexPath = calendarCollectionView.indexPathForItem(at: point) else {
            return (0,0)
        }

        let range = (start: startIndexPath.item, end: endingIndexPath.item)

        return range

    }

    fileprivate func pointIsGreaterThanCurrentPoint(_ point : CGPoint) -> Bool {
        var retVal = true
        if point.x >= currentPanningPoint.x {
            retVal = true
        } else if point.x < currentPanningPoint.x {
            retVal = false
        }
        return retVal
    }
    fileprivate func pointIsGreaterThanStartingPoint(_ point : CGPoint) -> Bool {
        var retVal = true
        if point.x >= startPanningPoint.x {
            retVal = true
        } else if point.x < startPanningPoint.x {
            retVal = false
        }
        return retVal
    }

    fileprivate func getTheCurrentRowColumnFor(_ indexPath : IndexPath) -> (Int, Int) {
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

        if let _ = startingYear, let _ = endingYear {

        } else {
            dateGenerator?.delegate = self
            if let dateGenerator = dateGenerator {
                initialDateIndex = dateGenerator.getInitialIndexForDate(Foundation.Date()) ?? 0
            }
            nsDateComponents.year = startingYearLimit
            let yearMinus20 = nsDateComponents
            startingYear = (calendar as NSCalendar).date(byAdding: yearMinus20, to: presentingDate, options: .wrapComponents)

            //Creating the starting year according to the endingYearLimit
            nsDateComponents.year = endingYearLimit
            let yearPlus20 = nsDateComponents
            endingYear = (calendar as NSCalendar).date(byAdding: yearPlus20, to: presentingDate, options: .wrapComponents)
        }

        if let startingYear = startingYear , let endingYear = endingYear {

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

    fileprivate func scrollInitially() {
        if !scrolledInitially {
            calendarCollectionView.setContentOffset(CGPoint(x: calendarCollectionView.bounds.width, y: 0.f), animated: false)
            scrolledInitially = true
        }
    }
    fileprivate func addAttributesToFlowLayout() {

        if let _ = calendarCollectionView {
            calendarCollectionView.removeFromSuperview()
            self.calendarCollectionView = nil
        }
        if let _ = flowLayout {
        } else {
            flowLayout = CalendarFlowLayout()
        }

        flowLayout?.scrollDirection = .horizontal
        flowLayout?.itemSize = CGSize(width: bounds.size.width / 7, height: bounds.size.height / 5)
        flowLayout?.minimumInteritemSpacing = 0.0
        flowLayout?.minimumLineSpacing = 0.0

        //TODO : remove the horizontal scroll indicator

        if let flowLayout = flowLayout {
            calendarCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionViewWidth = calendarCollectionView.frame.size.width
            collectionViewHeight = calendarCollectionView.frame.size.height
        }
    }

    fileprivate func addSubviews() {
        if let calendarCollectionView = calendarCollectionView {
            addSubview(calendarCollectionView)
        }
        addSubview(yearMonthButton)
    }

    fileprivate func addConstraints() {
        addConstraintToCalendar()
        addConstraintToMonthAndYearLabels()
    }

    fileprivate func addConstraintToMonthAndYearLabels() {

        let topConstraint = NSLayoutConstraint(item: yearMonthButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: yearMonthButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
        let heightConstraint = NSLayoutConstraint(item: yearMonthButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)

        addConstraints([topConstraint, leadingConstraint])
        yearMonthButton.addConstraint(heightConstraint)
    }
    //MARK: adding constraint calendar collection view and self
    fileprivate func addConstraintToCalendar() {
        if let calendarCollectionView = calendarCollectionView {

            let leading = NSLayoutConstraint(item: calendarCollectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
            let traling = NSLayoutConstraint(item: calendarCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
            let bottom = NSLayoutConstraint(item: calendarCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)

            addConstraints([leading,traling,bottom])
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
        }

        print("Reloaded")
    }
}

extension CalendarView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        nsDateComponents.day = 1
        nsDateComponents.month = getCurrentMonthForSection(section, month: true) + 1
        nsDateComponents.year = getCurrentMonthForSection(section, month: false)

        return dateComponent.totalDaysInAMonthForTheCurrentDate()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarViewCell
        cell.dateButton.setTitle("\(indexPath.item + 1)", for: UIControlState())


        cell.dateButton.backgroundColor = UIColor.blue
        cell.setAsCurrentDateItem = false

        if isPresentDateFor(indexPath){
            cell.dateButton.backgroundColor = UIColor.red
            cell.setAsCurrentDateItem = true
        }
        return cell
    }

    func isPresentDateFor(_ indexPath : IndexPath) -> Bool {
        return (numberOfIterations == getTheCurrentIterationIndexForCurrentDate().0 && indexPath == (getTheCurrentIterationIndexForCurrentDate().1) && highlightCurrentDate)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let _ = dateGenerator {
            return kDefaultNumberOfSections
        }
        return 0
    }

    //Gives the current date index and the iteration index for the present day
    fileprivate func getTheCurrentIterationIndexForCurrentDate() -> (Int, IndexPath) {

        dateComponent.changeDateComponentsForDate(presentingDate)
        let year1 = nsDateComponents.year
        let month1 = nsDateComponents.month

        dateComponent.changeDateComponentsForDate(Foundation.Date())
        let year2 = nsDateComponents.year
        let day2 = nsDateComponents.day
        let month2 = nsDateComponents.month

        let yearDifference = year1! - year2!
        let differenceBWMonths = (yearDifference * (12 - month1! + 12 - month2!))

        let currentNumberOfIterationForCurrentDay = floor(differenceBWMonths.f / 3)

        let currentMonthIndex = differenceBWMonths % 3 + 1
        let indexPath = IndexPath(item: day2! - 1, section: currentMonthIndex)


        return (Int(currentNumberOfIterationForCurrentDay), indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        //present section will be helpful to calculate the present month

        currentSection = Int(floor(targetContentOffset.pointee.x / calendarCollectionView.bounds.width)) + 1

        currentMonth = getCurrentMonthForSection(currentSection - 1, month: true) + 1
        currentYear = getCurrentMonthForSection(currentSection - 1, month: false)

        if currentSection.f >= kDefaultNumberOfSections.f {

            //set the content offset of the collection view to the initial section after some time say 0.15 seconds to look the scroll animation look smoother
            numberOfIterations += 1
            let delayTime = DispatchTime.now() + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.reloadCollectionViewAttributesFor(.forward)
            }
        }else if currentSection <= 1 {

            numberOfIterations -= 1
            let delayTime = DispatchTime.now() + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.reloadCollectionViewAttributesFor(.backward)
            }
        }

        changeTheTextOfYearMonthLabel()
    }

    fileprivate func changeTheTextOfYearMonthLabel() {

        UIView.animate(withDuration: 0.2, animations: { 
            self.yearMonthButton.alpha = 0
            }, completion: { (completion) in
                UIView.animate(withDuration: 0.2, animations: { 
                    self.yearMonthButton.alpha = 1.0
                    if let name = Months(rawValue: self.currentMonth)?.name() {
                        self.yearMonthButton.setTitle("\(name) \(self.currentYear)", for: UIControlState())
                    }
                })
        }) 
    }

    fileprivate func reloadCollectionViewAttributesFor(_ position : BoundaryPositions){

        //dispatch every UI updates in the main queue

        DispatchQueue.main.async {
            var positionPoint = CGPoint.zero
            switch position {
            case .backward:

                let contentSize = self.calendarCollectionView.contentSize
                self.calendarCollectionView.setContentOffset(CGPoint(x: contentSize.width.f - 2 * self.collectionViewWidth, y: 0.f), animated: false) //2* collectionViewWidth because to the second section the width = 2 * the collection view width

            case .forward:

                positionPoint = CGPoint(x: self.calendarCollectionView.bounds.width, y: 0.f)
                self.calendarCollectionView.setContentOffset(positionPoint, animated: false)
            }

            self.reloadData()
            self.flowLayout?.currentIterationIndex = self.numberOfIterations
            print("numberOfIterations: ", self.numberOfIterations)
            self.flowLayout?.invalidateLayout()
        }
    }
}


extension CalendarView : DateGeneratorDelegate {
    func dateGeneratorDidFinishUpatingTheDates(_ generator: DateGenerator) {
        reloadData()
    }
}

//MARK : Date related calculation
extension CalendarView {
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
    
    fileprivate func changeTheDateComponent() {
        dateComponent.changeDateComponentsForDate(presentingDate)
        presentingDay = nsDateComponents.day!
        presentingMonth = nsDateComponents.month!
        
        currentMonth = presentingMonth
        currentYear = presentingYear
        
        presentingYear = nsDateComponents.year!
        
        flowLayout?.presentingMonth = presentingMonth
        flowLayout?.presentingYear = presentingYear
    }
    
    fileprivate func rangeOfMonthToBeAdded() -> Int {
        return numberOfIterations * kCellsVisibleToTheUser - 1
    }
}
extension CalendarView : UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
