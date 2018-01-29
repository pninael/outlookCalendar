//
//  Event.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/17/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation
import UIKit

// Event Category
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

// A Data serialization error
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
    
    // Returns a string representation for the event time
    var timeDescription : String {
        return isAllDayEvent ? allDayString : startTime.toString(format: "hh:mm")
    }
    
    // Returns a string representation for the event duration
    var durationDescription : String {
        return endTime.durationDescription(from: startTime)
    }
    
    // Initialize an event from a json
    // Throws a DataError if the josn could not be deserialized into an event
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
