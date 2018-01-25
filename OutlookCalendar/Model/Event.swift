//
//  Event.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/17/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation
import UIKit

enum EventCategory : String {
    case Holiday = "Holiday"
    case Work = "Work"
    case Personal = "Personal"
    
    var color : UIColor {
        switch self {
            case .Holiday: return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            case .Work: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .Personal: return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }
    }
}

enum DataError : Error {
    case JSONSerialization(String)
}

struct Event {

    let id : Int
    let subject : String
    let category : EventCategory?
    let startTime : Date
    let endTime : Date
    let isAllDayEvent : Bool
    let location : String
    let attendees : [Attendee]
    
    private let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    private let timeFormat = "hh:mm"
    private let allDayString = "ALL DAY"
    
    var timeDescription : String {
        return isAllDayEvent ? allDayString : startTime.toString(format: "hh:mm")
    }
    
    var durationDescription : String {
        return endTime.durationDescription(from: startTime)
    }
    
    init(json: [String: Any]) throws {
        guard let id = json["Id"] as? Int,
            let subject = json["Subject"] as? String,
            let category = json["Category"] as? String,
            let startTimeString = json["Start"] as? String,
            let startTime = Date.fromString(string: startTimeString, withFormat: dateFormat),
            let endTimeString = json["End"] as? String,
            let endTime = Date.fromString(string: endTimeString, withFormat: dateFormat),
            let isAllDayEvent = json["IsAllDayEvent"] as? Bool,
            let location = json["Location"] as? String
        else {
            throw DataError.JSONSerialization("json could not be serialized to an Event : \(json) ")
        }
        self.id = id
        self.subject = subject
        self.category = EventCategory(rawValue: category)
        self.startTime = startTime
        self.endTime = endTime
        self.isAllDayEvent = isAllDayEvent
        self.location = location
        if let attendees = json["Attendees"] as? [[String : Any]] {
            self.attendees = try attendees.map{ item in
                return try Attendee(json: item)
            }
        }
        else {
            self.attendees = []
        }
    }
}

extension Date {
    
    var monthSymbol : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let monthNumber = Calendar.current.component(.month, from: self)
        return dateFormatter.monthSymbols[monthNumber - 1]
    }
    
    static func fromString(string: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the a custom time interval description from another date
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
