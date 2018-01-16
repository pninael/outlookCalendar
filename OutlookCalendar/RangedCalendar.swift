//
//  DateHelper.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/8/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation

class RangedCalendar {
    
    var calendar = Calendar.current
    var yearsBack : Int
    var yearsAhead : Int
    
    private lazy var interval = dateIntervalFromToday(yearsBack: yearsBack, yearsAhead: yearsAhead)
    
    lazy var numberOfMonthsInRange : Int = {
        return calendar.numberOf(component: .month, inInterval: interval)
    }()
    
    lazy var numberOfDaysInRange : Int = {
        return calendar.numberOf(component: .day, inInterval: interval)
    }()
    
    init(yearsBack: Int, yearsAhead: Int) {
        self.yearsAhead = yearsAhead
        self.yearsBack = yearsBack
    }
    
    func dateFromStartDateByAddingDays(days: Int) -> Date? {
        return calendar.date(byAdding: .day, value: days, to: interval.start)
    }
    
    func dateFromStartDateByAddingMonths(months: Int, andDays days: Int) -> Date? {
        
        // set start date to be the first date in the interval, with same time as now
        let now = Date()
        var components = calendar.dateComponents([.hour, .minute, .second], from: now)
        components.year = calendar.component(.year, from: interval.start)
        components.month = calendar.component(.month, from: interval.start)
        
        guard let startDate = calendar.date(from: components) else { return nil }
        guard let dateByAddingMonths = calendar.date(byAdding: .month, value: months, to: startDate) else {return nil }
        return calendar.date(byAdding: .day, value: days, to: dateByAddingMonths)
    }
    
    func dayNumberInRange(forDate date:Date) -> Int? {
        assert(date > interval.start && date < interval.end, "RangedCalendar.dayNumberInRange: date \(date) is out of calendar range")
        return calendar.dateComponents([.day], from: interval.start, to: date).day
    }
    
    func monthNumberInRange(forDate date:Date) -> Int? {
        assert(date > interval.start && date < interval.end, "RangedCalendar.monthNumberInRange: date \(date) is out of calendar range")
        return calendar.dateComponents([.month], from: interval.start, to: date).month
    }
    
    func numberOfDaysInMonth(monthNumberInRange: Int) -> Int? {
        assert(monthNumberInRange >= 0 && monthNumberInRange < numberOfMonthsInRange, "RangedCalendar.numberOfDaysInMonth: month \(monthNumberInRange) is out of calendar range")
        guard let date = dateFromStartDateByAddingMonths(months: monthNumberInRange, andDays: 0) else { return nil }
        return calendar.range(of: .day, in: .month, for: date)?.count
    }
    
    private func dateIntervalFromToday(yearsBack: Int, yearsAhead: Int) ->  DateInterval {
        let today = Date()
        guard
            let todayBySubtructingYearsBack = calendar.date(byAdding: .year, value: -yearsBack, to: today),
            let startDate = calendar.date(from: calendar.dateComponents([.year,.month], from: todayBySubtructingYearsBack))
            else { return DateInterval() }
        
        guard
            let todayBygAddinYearsBack = calendar.date(byAdding: .year, value: yearsAhead, to: today),
            let numberOfDaysInLastMonth = calendar.range(of: .day, in: .month, for: todayBygAddinYearsBack)?.count,
            let endDate = calendar.date(bySetting: .day, value: numberOfDaysInLastMonth, of: todayBygAddinYearsBack)
            else { return DateInterval() }
        
        return DateInterval(start: startDate, end: endDate)
    }
}

extension Calendar {
    func numberOf(component: Component, inInterval interval: DateInterval) -> Int {
        guard let start = ordinality(of: component, in: .era, for: interval.start) else { return 0 }
        guard let end = ordinality(of: component, in: .era, for: interval.end) else { return 0 }
        
        return end - start
    }
}
