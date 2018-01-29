//
//  NoEventsCell.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/24/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

// A cell to display when there are no events to show
class NoEventsCell: UITableViewCell {

    static var reuseIdentifier = "noEventCell"

    private static let margin : CGFloat = 8.0
    private static let text = "No events"
    private static let font = UIFont.systemFont(ofSize: 14.0)
    
    private var noEventsLabel: UILabel! = {
        let label = UILabel()
        label.font = font
        label.text = text
        label.textAlignment = .left
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(noEventsLabel)
    }
    
    override func layoutSubviews() {
        
        noEventsLabel.frame = CGRect(x: NoEventsCell.margin, y: NoEventsCell.margin, width: contentView.frame.size.width - 2 * NoEventsCell.margin, height: noEventsLabel.heightForText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Returns the calculated height of the cell
    static func height() -> CGFloat {
        let textHeight = text.size(withAttributes: [NSAttributedStringKey.font: font]).height
        return textHeight + 2 * margin
    }
}
