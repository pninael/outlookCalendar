//
//  MasterViewController.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/14/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

protocol CalendarObserver {
    func dateWasChosen(sender: UIViewController, date:Date)
    func calendarWillStartScrolling(sender: UIViewController)
}

class MasterViewController: UIViewController {

    private let calendarExpandedPropotion : CGFloat = 0.5
    private let calendarCollapsedPropotion : CGFloat = 0.3
    
    private var calendarViewController = CalendarViewController()
    private var agendaViewController = AgendaViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContentController(calendarViewController)
        addContentController(agendaViewController)
        setCalendarProportion(proportion: calendarCollapsedPropotion, animated: false)
        
        agendaViewController.observer = self
        calendarViewController.observer = self
    }

    private func addContentController(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    private func setCalendarProportion(proportion: CGFloat, animated: Bool) {
        let layoutViews : () -> Void = {
            self.calendarViewController.view.frame = CGRect(x: 0,
                                                       y: 0,
                                                       width: self.view.bounds.size.width,
                                                       height: self.view.bounds.size.height * proportion)
            
            self.agendaViewController.view.frame = CGRect(x: 0,
                                                     y: self.calendarViewController.view.frame.maxY,
                                                     width: self.view.bounds.size.width,
                                                     height: self.view.bounds.size.height * (1 - proportion))
        }
        
        if animated {
            UIView.animate(withDuration: 0.1, animations: layoutViews)
        }
        else {
            layoutViews()
        }
    }

    private func expandCalendar(animated: Bool) {
        setCalendarProportion(proportion: calendarExpandedPropotion, animated: animated)
    }
    
    private func collapseCalendar(animated: Bool) {
        setCalendarProportion(proportion: calendarCollapsedPropotion, animated: animated)
    }
}

extension MasterViewController : CalendarObserver {
    
    func dateWasChosen(sender: UIViewController, date: Date) {
        
        if sender == calendarViewController {
            agendaViewController.chooseDate(date: date, animated: true)
        }
        else if sender == agendaViewController {
            calendarViewController.chooseDate(date: date, animated: true)
        }
    }
    
    func calendarWillStartScrolling(sender: UIViewController) {
        
        if sender == calendarViewController {
            expandCalendar(animated: true)
        }
        else if sender == agendaViewController {
            collapseCalendar(animated: true)
        }
    }
}
