//
//  Events.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/17/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import Foundation
import UIKit

// A mock for returning calendar events
class EventsServiceMock {
    
    // Load events from the "events.json" file
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
    
    // Returns an image placeholder for an attendee
    // TODO: set a color for each attendee, add a label with his name's acronyms
    func image(for attendee:Attendee) -> UIImage {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.layer.cornerRadius = 25
        view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        
        // turn the view into an image
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
}
