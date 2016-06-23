//
//  DateGenerator.swift
//  Calendar
//
//  Created by Shreesha on 12/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import Foundation
struct Date {
    
}
var nsDateComponents = NSDateComponents()
var calendar = NSCalendar.currentCalendar()
var dateFormatter = NSDateFormatter()

var dateComponent : DateComponent!

class DateComponent: NSObject {

}

extension DateComponent {

    private func getActualDatefromCalendar() -> NSDate {
        if let date = calendar.dateFromComponents(nsDateComponents) {
            return date
        }
        return NSDate()
    }

    func changeDateComponentsForDate(date : NSDate) {
        nsDateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Weekday], fromDate: date)
    }

    func totalDaysInAMonthForTheCurrentDate() -> Int {
        let total = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: getActualDatefromCalendar()).length
        return total
    }

    func startingRangeOfDay() -> Int {
        changeDateComponentsForDate(getActualDatefromCalendar())
        return nsDateComponents.weekday
    }

    func getNumberOfWeekForCurrentDate() -> Int {
        let total = calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: getActualDatefromCalendar()).length
        return total
    }
}


class DateGenerator: NSObject {
    var dates : [NSDate]?

    private var startingDate : NSDate?
    private var endingDate : NSDate?
    weak var delegate : DateGeneratorDelegate?

    init(startingDate : NSDate , endingDate : NSDate, delegate : DateGeneratorDelegate) {
        super.init()

        self.delegate = delegate
        self.startingDate = startingDate
        self.endingDate = endingDate
        setTheInitialDates()
    }

    private func setTheInitialDates() {

        if dates == nil {
            updateTheDates()
        }
    }
    private func updateTheDates(){

        if let startingDate = startingDate , endingDate = endingDate {

            let componenets = calendar.components(.Day, fromDate: startingDate, toDate: endingDate, options: .MatchStrictly)

            for date in 0..<componenets.day {

                let daysToAdd = date

                if let _ = dates {
                    self.dates?.append(startingDate.dateByAddingTimeInterval(60*60*24*Double(daysToAdd)))
                } else {
                    dates = [startingDate]
                }
            }
            delegate?.dateGeneratorDidFinishUpatingTheDates(self)
        }
    }

    func updateTheDatesWith(startingDate :NSDate, endingDate : NSDate ) {
        self.startingDate = startingDate
        self.endingDate = endingDate
        updateTheDates()
    }
}

extension DateGenerator {
    func getInitialIndexForDate(date : NSDate) -> Int? {
        if let dates = dates {
            if dates.contains(date) {
                return dates.indexOf(date)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}


protocol DateGeneratorDelegate : class{
    func dateGeneratorDidFinishUpatingTheDates(generator :DateGenerator)
}