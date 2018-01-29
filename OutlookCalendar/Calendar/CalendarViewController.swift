//
//  CalendarViewController.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/5/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

// A view controller for displaying the calendar collection view
class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var observer : CalendarObserver?
    
    private let rangedCalendar = RangedCalendar.shared
    private let numberOfDaysInWeek = 7
    
    private let weekDaysHeaderHeight : CGFloat = 30.0
    
    private lazy var daysCollectionView: UICollectionView! = {
        
        // We use the ContinuousSectionsLayout so sections dont break into new lines
        let layout = ContinuousSectionsGridLayout()
        layout.numberOfColumns = numberOfDaysInWeek
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseIdentifier)
        
        return collectionView
    }()

    // This view is displayed as the calendar header, and shows the week days titles
    private lazy var weekDaysStackView : UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        let dateFormatter = DateFormatter()
        for weekDay in 0..<numberOfDaysInWeek {
            let view = WeekDayView()
            view.title.text = dateFormatter.shortWeekdaySymbols[weekDay]
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(weekDaysStackView)
        view.addSubview(daysCollectionView)
    }

    // Scroll to the given date
    func chooseDate(date:Date, animated: Bool) {
        let day = rangedCalendar.calendar.component(.day, from: date)
        if let month = rangedCalendar.monthNumberInRange(forDate: date) {
            let indexPath = IndexPath(item: day-1, section: month)
            daysCollectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .top)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rangedCalendar.numberOfDaysInMonth(forMonthNumberInRange: section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rangedCalendar.numberOfMonthsInRange
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.reuseIdentifier, for: indexPath)
        
        if let dayCell = cell as? DayCell {
            // get the date to display for the indexPath
            if let date = rangedCalendar.dateFromStartDateByAddingMonths(months: indexPath.section, andDays: indexPath.row) {
                dayCell.title.text = String(Calendar.current.component(.day, from: date))
                dayCell.backgroundColor = indexPath.section % 2 == 0 ?  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9701757813, green: 0.9701757813, blue: 0.9701757813, alpha: 1) 
            }
        }
        
        cell.selectedBackgroundView = {
            let backgroundView = UIView(frame: CGRect(origin: .zero, size: cell.frame.size))
            backgroundView.backgroundColor = cell.backgroundColor
            
            let selectedCircleSize = backgroundView.frame.size.width * 0.8
            let selectedCircleView = UIView(frame: CGRect(x: (cell.frame.size.width - selectedCircleSize) / 2,
                                                          y: (cell.frame.size.height - selectedCircleSize) / 2,
                                                          width: selectedCircleSize,
                                                          height: selectedCircleSize))
            selectedCircleView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            selectedCircleView.layer.cornerRadius = selectedCircleSize/2
            
            backgroundView.addSubview(selectedCircleView)
            return backgroundView
        }()
        
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var top = UIApplication.shared.statusBarFrame.size.height
        if let navigationBar = navigationController?.navigationBar {
            top += navigationBar.frame.size.height
        }
        
        weekDaysStackView.frame = CGRect(x: 0,
                                         y: top,
                                         width: view.frame.width,
                                         height: weekDaysHeaderHeight)
        
        daysCollectionView.frame = CGRect(x: 0,
                                          y: weekDaysStackView.frame.maxY,
                                          width: view.frame.width,
                                          height: view.frame.height - weekDaysHeaderHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let date = rangedCalendar.dateFromStartDateByAddingMonths(months: indexPath.section, andDays: indexPath.row) {
            observer?.dateWasChosen(sender: self, date: date)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        observer?.calendarWillStartScrolling(sender: self)
    }
}

extension CalendarViewController : ContinuousSectionsGridLayoutDelegte {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
