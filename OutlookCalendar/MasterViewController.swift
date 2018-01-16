//
//  MasterViewController.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/14/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

protocol calendarObserver {
    func dateWasChosen(date:Date)
}

class MasterViewController: UIViewController {

    private lazy var calendarViewController : CalendarViewController = {
        let calendarVC = CalendarViewController()
        calendarVC.view.frame = CGRect(x: 0,
                                       y: 0,
                                       width: view.bounds.size.width,
                                       height: view.bounds.size.height * 0.5)
        return calendarVC
    }();
    
    private lazy var agendaViewController : AgendaViewController = {
        let agendaVC = AgendaViewController()
        agendaVC.view.frame = CGRect(x: 0,
                                     y: calendarViewController.view.frame.maxY,
                                     width: view.bounds.size.width,
                                     height: view.bounds.size.height * 0.5)
        return agendaVC
    }();
        
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Calendar"
        
        addContentController(calendarViewController)
        addContentController(agendaViewController)
        
        agendaViewController.observer = calendarViewController
        calendarViewController.observer = agendaViewController
    }

    private func addContentController(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
}
