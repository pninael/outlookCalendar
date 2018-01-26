//
//  CalendarDayCollectionViewCell.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/5/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    static var reuseIdentifier = "dayCell"
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        title.font = UIFont.systemFont(ofSize: 18.0)

        title.textAlignment = .center
        contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
