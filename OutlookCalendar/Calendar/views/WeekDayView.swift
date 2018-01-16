//
//  WeekDayCollectionViewCell.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/15/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

class WeekDayView: UIView {
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        title.font = UIFont.systemFont(ofSize: 15.0)
        
        title.textAlignment = .center
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
