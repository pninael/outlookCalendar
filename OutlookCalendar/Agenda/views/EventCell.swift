//
//  EventCell.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/15/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    static var reuseIdentifier = "eventCell"
    var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        title.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        title.font = UIFont.systemFont(ofSize: 10.0)
        
        title.textAlignment = .center
        contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
