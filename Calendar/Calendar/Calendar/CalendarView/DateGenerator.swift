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
var nsDateComponents = DateComponents()
var calendar = Foundation.Calendar.current
var dateFormatter = DateFormatter()

var dateComponent : DateComponent!

class DateComponent: NSObject {

}

extension DateComponent {

    fileprivate func getActualDatefromCalendar() -> Foundation.Date {
        if let date = calendar.date(from: nsDateComponents) {
            return date
        }
        return Foundation.Date()
    }

    func changeDateComponentsForDate(_ date : Foundation.Date) {
        nsDateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.weekday], from: date)
    }

    func totalDaysInAMonthForTheCurrentDate() -> Int {
        let total = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: getActualDatefromCalendar()).length
        return total
    }

    func startingRangeOfDay() -> Int {
        changeDateComponentsForDate(getActualDatefromCalendar())
        return nsDateComponents.weekday!
    }

    func getNumberOfWeekForCurrentDate() -> Int {
        let total = (calendar as NSCalendar).range(of: .weekOfMonth, in: .month, for: getActualDatefromCalendar()).length
        return total
    }
}


class DateGenerator: NSObject {
    var dates : [Foundation.Date]?

    fileprivate var startingDate : Foundation.Date?
    fileprivate var endingDate : Foundation.Date?
    weak var delegate : DateGeneratorDelegate?

    init(startingDate : Foundation.Date , endingDate : Foundation.Date, delegate : DateGeneratorDelegate) {
        super.init()

        self.delegate = delegate
        self.startingDate = startingDate
        self.endingDate = endingDate
        setTheInitialDates()
    }

    fileprivate func setTheInitialDates() {

        if dates == nil {
            updateTheDates()
        }
    }
    fileprivate func updateTheDates(){

        if let startingDate = startingDate , let endingDate = endingDate {

            let componenets = (calendar as NSCalendar).components(.day, from: startingDate, to: endingDate, options: .matchStrictly)

            for date in 0..<componenets.day! {

                let daysToAdd = date

                if let _ = dates {
                    self.dates?.append(startingDate.addingTimeInterval(60*60*24*Double(daysToAdd)))
                } else {
                    dates = [startingDate]
                }
            }
            delegate?.dateGeneratorDidFinishUpatingTheDates(self)
        }
    }

    func updateTheDatesWith(_ startingDate :Foundation.Date, endingDate : Foundation.Date ) {
        self.startingDate = startingDate
        self.endingDate = endingDate
        updateTheDates()
    }
}

extension DateGenerator {
    func getInitialIndexForDate(_ date : Foundation.Date) -> Int? {
        if let dates = dates {
            if dates.contains(date) {
                return dates.index(of: date)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}


protocol DateGeneratorDelegate : class{
    func dateGeneratorDidFinishUpatingTheDates(_ generator :DateGenerator)
}
