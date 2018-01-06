//
//  CalendarDayCollectionViewCell.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/5/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        title.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        title.textAlignment = .center
        contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
