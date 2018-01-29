//
//  calendarExtensions.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/28/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation

extension Calendar {
    
    // Returns the ordinal number of a calendar component within a specified Date Interval.
    func numberOf(component: Component, inInterval interval: DateInterval) -> Int {
        guard let start = ordinality(of: component, in: .era, for: interval.start) else {
            return 0
        }
        guard let end = ordinality(of: component, in: .era, for: interval.end) else {
            return 0
        }
        
        return end - start
    }
}
