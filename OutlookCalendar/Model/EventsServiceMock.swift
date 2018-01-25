//
//  Events.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/17/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation
import UIKit

class EventsServiceMock {
    
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
    
    func image(for attendee:Attendee) -> UIImage {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.layer.cornerRadius = 25
        view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
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
