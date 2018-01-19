//
//  Event.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/17/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation

enum EventCategory : String {
    case Holiday = "Holiday"
    case Work = "Work"
    case Personal = "Personal"
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
        self.attendees = []
    }
}

extension Date {
    static func fromString(string: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = Calendar.current.timeZone
        return dateFormatter.date(from: string)
    }
}
