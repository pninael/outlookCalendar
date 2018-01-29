//
//  CalendarDayCollectionViewCell.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/5/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

// Cell for displaying a day in the calendar
class DayCell: UICollectionViewCell {
    
    static var reuseIdentifier = "dayCell"
    
    var title: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = contentView.frame
    }
}
