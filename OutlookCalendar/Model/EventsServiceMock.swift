//
//  Events.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/17/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation

class EventsServiceMock {
    
    let rangedCalendar = RangedCalendar.shared
    
    var calendarEventsMap = [Int:[Event]]()
    
    func fetchEvents() -> [Int:[Event]]? {
        
        guard let events = loadEventsFromJson() else { return nil }
        
        events.forEach { event in
            if let startDayNumberInRangedCalendar = rangedCalendar.dayNumberInRange(forDate: event.startTime),
                let endDayNumberInRangedCalendar = rangedCalendar.dayNumberInRange(forDate: event.endTime){
                for day in startDayNumberInRangedCalendar...endDayNumberInRangedCalendar {
                    if calendarEventsMap[day] != nil {
                        calendarEventsMap[day]?.append(event)
                    }
                    else {
                        calendarEventsMap[day] = [event]
                    }
                }
            }
        }
        return calendarEventsMap
    }
    
    func loadEventsFromJson() -> [Event]? {
        guard let path = Bundle.main.path(forResource: "events", ofType: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let jsonDictionary =  json as? [String : Any],
                let eventsArr = jsonDictionary["events"] as? [[String : Any]] else {
                    return nil
            }
            return try eventsArr.map{ item in
                return try Event(json: item)
            }
        }
        catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension Collection {
    func toDictionary<K, V>(transform:(_ element: Iterator.Element) -> [K : V]) -> [K : V] {
        var dictionary = [K : V]()
        self.forEach { element in
            for (key, value) in transform(element) {
                dictionary[key] = value
            }
        }
        return dictionary
    }
}
