//
//  AgendaViewController.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/14/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

class AgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, calendarObserver {

    let rangedCalendar = RangedCalendar(yearsBack: 8, yearsAhead: 2)
    var observer : calendarObserver?
    var topVisibleCellIndexPath : IndexPath?
    
    private lazy var tableView: UITableView! = {
        let tableView = UITableView(frame: view.frame)
        tableView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Date()
        chooseDate(date:today, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rangedCalendar.numberOfDaysInRange
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let date = rangedCalendar.dateFromStartDateByAddingDays(days: section) else { return "" }
        return "\(rangedCalendar.calendar.component(.day, from: date))/\(rangedCalendar.calendar.component(.month, from: date))/\(rangedCalendar.calendar.component(.year, from: date) - 2000)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier, for: indexPath)
        
        if let eventCell = cell as? EventCell {
            if let date = rangedCalendar.dateFromStartDateByAddingDays(days: indexPath.section) {
                eventCell.title.text = "\(rangedCalendar.calendar.component(.day, from: date))/\(rangedCalendar.calendar.component(.month, from: date))/\(rangedCalendar.calendar.component(.year, from: date) - 2000)"
            }
        }
        
        return cell
    }
    
    func chooseDate(date:Date, animated: Bool) {
        if let day = rangedCalendar.dayNumberInRange(forDate: date) {
            tableView.scrollToSection(section: day, animated: animated)
            topVisibleCellIndexPath = tableView.indexPathsForVisibleRows?[0]
        }
    }
    
    func dateWasChosen(date: Date) {
        chooseDate(date: date, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if topVisibleCellIndexPath != tableView.indexPathsForVisibleRows?[0] {
            if let topVisibleCellIndexPath = tableView.indexPathsForVisibleRows?[0],
            let date = rangedCalendar.dateFromStartDateByAddingDays(days: topVisibleCellIndexPath.section) {
                observer?.dateWasChosen(date: date)
            }
        }
    }
}

extension UITableView {
    func scrollToSection(section: Int, animated: Bool) {
        let indexPath = IndexPath(row: NSNotFound, section: section)
        scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}
