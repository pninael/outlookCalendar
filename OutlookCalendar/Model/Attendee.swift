//
//  Attendee.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/17/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation

struct Attendee {
    let name : String
    let email : String
    
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
