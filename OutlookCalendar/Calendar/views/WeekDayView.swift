//
//  WeekDayCollectionViewCell.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/15/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

// View for displaying a weekDay in the calendar header
class WeekDayView: UIView {
    
    var title: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(origin: .zero, size: frame.size)
    }
}
