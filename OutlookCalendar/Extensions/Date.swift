//
//  date.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/28/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation

extension Date {
    
    // Returns the date's month symbol (using local timezone)
    var monthSymbol : String {
        let monthNumber = Calendar.current.component(.month, from: self)
        return DateFormatter().monthSymbols[monthNumber - 1]
    }
    
    // Returns the date's day symbol (using local timezone)
    var daySymbol : String {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        return DateFormatter().weekdaySymbols[dayNumber - 1]
    }
    
    // Initialize a date from the given string and format (using local timezone)
    static func fromString(string: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    // Convert the date into a string (using local timezone)
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    // Returns a time interval string description from another date, for example: "2d", "1h 30m", etc.
    func durationDescription(from date: Date) -> String {
        var duration = ""
        
        let daysOffset = days(from: date)
        let hoursOffset = hours(from: date)
        let minutesOffset = minutes(from: date) - 60 * hoursOffset
        
        if  daysOffset > 0 {
            duration = "\(daysOffset)d"
        }
        else {
            if hoursOffset > 0 {
                duration = "\(hoursOffset)h "
            }
            if minutesOffset > 0 {
                duration += "\(minutesOffset)m"
            }
        }
        return duration
    }
}
