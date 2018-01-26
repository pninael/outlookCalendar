//
//  AgendaViewController.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/14/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

class AgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let rangedCalendar = RangedCalendar.shared
    var observer : CalendarObserver?
    private var topVisibleCellIndexPath : IndexPath?
    private var eventsMap = [Int:[Event]]()
    private let eventsService = EventsServiceMock()
    
    private lazy var tableView: UITableView! = {
        let tableView = UITableView(frame: view.frame)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        tableView.register(NoEventsCell.self, forCellReuseIdentifier: NoEventsCell.reuseIdentifier)

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEvents()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rangedCalendar.numberOfDaysInRange
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsMap[section]?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let event = event(for: indexPath) {
            return EventCell.height(for: event)
        }
        else {
            return NoEventsCell.height()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let date = rangedCalendar.dateFromStartDateByAddingDays(days: section) else { return "" }
        let day = Calendar.current.component(.day, from: date)
        let year = Calendar.current.component(.year, from: date)
        return "\(date.daySymbol), \(day) \(date.monthSymbol) \(year)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView  = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.950710454, green: 0.950710454, blue: 0.950710454, alpha: 1)
        
        let headerLabel = UILabel(frame: CGRect(x: 8, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font =  UIFont.systemFont(ofSize: 14.0)
        headerLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        
        guard let date = rangedCalendar.dateFromStartDateByAddingDays(days: section) else {
            return view
        }
        let day = Calendar.current.component(.day, from: date)
        let year = Calendar.current.component(.year, from: date)
        headerLabel.text = "\(date.daySymbol), \(day) \(date.monthSymbol) \(year)"
        
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell
        
        if eventsMap[indexPath.section] != nil {
            cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier, for: indexPath)
            if let eventCell = cell as? EventCell {
                if let event = event(for: indexPath) {
                    eventCell.subjectLabel.text = event.subject
                    eventCell.timeLabel.text = event.timeDescription
                    eventCell.durationLabel.text = event.durationDescription
                    eventCell.locationLabel.text = event.location
                    eventCell.categoryView.backgroundColor = event.category?.color
                    
                    for attendee in event.attendees {
                        let attendeeImage = eventsService.image(for: attendee)
                        eventCell.attendeesView.addSubview(AttendeeView(image: attendeeImage))
                    }
                }
            }
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: NoEventsCell.reuseIdentifier, for: indexPath)
        }
        return cell
    }
    
    func chooseDate(date:Date, animated: Bool) {
        if let day = rangedCalendar.dayNumberInRange(forDate: date) {
            tableView.scrollToSection(section: day, animated: animated)
            topVisibleCellIndexPath = tableView.indexPathsForVisibleRows?[0]
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if topVisibleCellIndexPath != tableView.indexPathsForVisibleRows?[0] {
            if let topVisibleCellIndexPath = tableView.indexPathsForVisibleRows?[0],
            let date = rangedCalendar.dateFromStartDateByAddingDays(days: topVisibleCellIndexPath.section) {
                observer?.dateWasChosen(sender: self, date: date)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        observer?.calendarWillStartScrolling(sender: self)
    }
    
    private func fetchEvents() {
        
        guard let events = eventsService.loadEventsFromJson() else { return }
        
        events.forEach { event in
            if let startDayNumberInRangedCalendar = rangedCalendar.dayNumberInRange(forDate: event.startTime),
                let endDayNumberInRangedCalendar = rangedCalendar.dayNumberInRange(forDate: event.endTime){
                for day in startDayNumberInRangedCalendar...endDayNumberInRangedCalendar {
                    if eventsMap[day] != nil {
                        eventsMap[day]?.append(event)
                    }
                    else {
                        eventsMap[day] = [event]
                    }
                }
            }
        }
    }
    
    private func event(for indexPath: IndexPath) -> Event? {
        guard let eventsForDate = eventsMap[indexPath.section] else {
            return nil
        }
        return eventsForDate[indexPath.row]
    }
}

extension UITableView {
    func scrollToSection(section: Int, animated: Bool) {
        let indexPath = IndexPath(row: NSNotFound, section: section)
        scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}
