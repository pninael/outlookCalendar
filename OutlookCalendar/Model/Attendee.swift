//
//  Attendee.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/17/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation

// An event atendee
struct Attendee {
    let name : String
    let email : String
    
    // Initialize an attendee from a json
    // Throws a DataError if the josn could not be deserialized into an attendee
    init(json: [String: Any]) throws {
        guard let name = json["Name"] as? String,
            let email = json["EmailAddress"] as? String
            else {
                throw DataError.JSONSerialization("json could not be serialized to a User : \(json) ")
        }
        self.name = name
        self.email = email
    }
}
