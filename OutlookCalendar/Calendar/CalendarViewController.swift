//
//  CalendarViewController.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/5/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, calendarObserver {
    
    var observer : calendarObserver?

    let numberOfDaysInWeek = 7
    
    let rangedCalendar = RangedCalendar.shared
    
    private lazy var daysCollectionView: UICollectionView! = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseIdentifier)
        
        return collectionView
    }()

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = Date()
        chooseDate(date:today, animated: false)
    }

    func chooseDate(date:Date, animated: Bool) {
        let day = rangedCalendar.calendar.component(.day, from: date)
        if let month = rangedCalendar.monthNumberInRange(forDate: date) {
            let indexPath = IndexPath(item: day-1, section: month)
            daysCollectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .top)
        }
    }
    
    ///MARK - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rangedCalendar.numberOfDaysInMonth(monthNumberInRange: section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rangedCalendar.numberOfMonthsInRange
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.reuseIdentifier, for: indexPath)
        
        if let dayCell = cell as? DayCell {
            if let date = rangedCalendar.dateFromStartDateByAddingMonths(months: indexPath.section, andDays: indexPath.row) {
                dayCell.title.text = "\(rangedCalendar.calendar.component(.day, from: date))/\(rangedCalendar.calendar.component(.month, from: date))/\(rangedCalendar.calendar.component(.year, from: date) - 2000)"
            }
        }
        
        cell.selectedBackgroundView = {
            let backgroundView = UIView(frame: CGRect(origin: .zero, size: cell.frame.size))
            backgroundView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            backgroundView.layer.cornerRadius = backgroundView.frame.size.width/2
            return backgroundView
        }()
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
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
                                         height: 50)
        
        daysCollectionView.frame = CGRect(x: 0,
                                          y: weekDaysStackView.frame.maxY,
                                          width: view.frame.width,
                                          height: view.frame.height - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let date = rangedCalendar.dateFromStartDateByAddingMonths(months: indexPath.section, andDays: indexPath.row) {
            observer?.dateWasChosen(date: date)
        }
    }
    
    func dateWasChosen(date: Date) {
        chooseDate(date: date, animated: true)
    }
}
