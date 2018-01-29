//
//  DateHelper.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/8/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation

// This class represents a ranged calendar, the range is based on today's date, and contains
// x years back and y years forward.
// The range can be adjusted by setting the variables: yearsBack,yearsAhead.
// By default, local timezon and calendar is used. This can be adjusted by setting the variable: calendar.
class RangedCalendar {
   
    // a shared instance (Singleton)
    static let shared = RangedCalendar()
    
    // number of years back, from dotay
    var yearsBack = defaultYearsBack
    
    // number of years ahead, from dotay
    var yearsAhead = defaultYearsAhead
    
    var calendar = Calendar.current
    
    var startDate : Date? {
        // set start date to be the first date in the interval, with same time as now
        let now = Date()
        var components = calendar.dateComponents([.hour, .minute, .second], from: now)
        components.year = calendar.component(.year, from: interval.start)
        components.month = calendar.component(.month, from: interval.start)
        
        return calendar.date(from: components)
    }
    
    // Total number of months in the range
    lazy var numberOfMonthsInRange : Int = {
        return calendar.numberOf(component: .month, inInterval: interval)
    }()
    
    // Total number of days in the range
    lazy var numberOfDaysInRange : Int = {
        return calendar.numberOf(component: .day, inInterval: interval)
    }()
    
    // default number of years back, from dotay
    private static let defaultYearsBack = 8
    
    // default number of years ahead, from dotay
    private static let defaultYearsAhead = 2
    
    // The date interval for the calendar range
    private lazy var interval : DateInterval = {
        if let interval = self.dateIntervalFromToday(yearsBack: self.yearsBack, yearsAhead: self.yearsAhead) {
            return interval
        }
        else {
            // When using the default yearsBack and yearsAhead we should always get back a valid DateInterval
            return dateIntervalFromToday(yearsBack: RangedCalendar.defaultYearsBack, yearsAhead: RangedCalendar.defaultYearsAhead)!
        }
    }()
    
    // Returns a new Date representing the date calculated by adding an amount of days to the calendar start date
    func dateFromStartDateByAddingDays(days: Int) -> Date? {
        guard let startDate = startDate else {
            return nil
        }
        return calendar.date(byAdding: .day, value: days, to: startDate)
    }
    
    // Returns a new Date representing the date calculated by adding an amount of months and days
    // to the calendar start date
    func dateFromStartDateByAddingMonths(months: Int, andDays days: Int) -> Date? {
        guard let startDate = startDate,
            let dateByAddingMonths = calendar.date(byAdding: .month, value: months, to: startDate)
            else {
                return nil
        }
        return calendar.date(byAdding: .day, value: days, to: dateByAddingMonths)
    }
    
    // Returns the day number within the range for the given date
    func dayNumberInRange(forDate date:Date) -> Int? {
        assert(date > interval.start && date < interval.end, "RangedCalendar.dayNumberInRange: date \(date) is out of calendar range")
        return calendar.dateComponents([.day], from: interval.start, to: date).day
    }
    
    // Returns the month number within the range for the given date
    func monthNumberInRange(forDate date:Date) -> Int? {
        assert(date > interval.start && date < interval.end, "RangedCalendar.monthNumberInRange: date \(date) is out of calendar range")
        return calendar.dateComponents([.month], from: interval.start, to: date).month
    }
    
    // Given a month number within the range, returns the number of days in that month
    func numberOfDaysInMonth(forMonthNumberInRange monthNumber: Int) -> Int? {
        assert(monthNumber >= 0 && monthNumber < numberOfMonthsInRange, "RangedCalendar.numberOfDaysInMonth: month \(monthNumber) is out of calendar range")
        guard let date = dateFromStartDateByAddingMonths(months: monthNumber, andDays: 0) else {
            return nil
        }
        return calendar.range(of: .day, in: .month, for: date)?.count
    }
    
    // Returns a date interval for a dates range around today, with the given amount of years
    // back and forward
    private func dateIntervalFromToday(yearsBack: Int, yearsAhead: Int) ->  DateInterval? {
        let today = Date()
        guard
            let todayBySubtructingYearsBack = calendar.date(byAdding: .year, value: -yearsBack, to: today),
            let startDate = calendar.date(from: calendar.dateComponents([.year,.month], from: todayBySubtructingYearsBack))
            else {
                return nil
        }
        
        guard
            let todayBygAddinYearsBack = calendar.date(byAdding: .year, value: yearsAhead, to: today),
            let numberOfDaysInLastMonth = calendar.range(of: .day, in: .month, for: todayBygAddinYearsBack)?.count,
            let endDate = calendar.date(bySetting: .day, value: numberOfDaysInLastMonth, of: todayBygAddinYearsBack)
            else {
                return nil
        }
        
        return DateInterval(start: startDate, end: endDate)
    }
}
