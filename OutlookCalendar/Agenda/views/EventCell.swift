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
    
    private static let margin : CGFloat = 8.0
    private static let spacing : CGFloat = 3.0
    
    private static let timeLabelWidth : CGFloat = 60.0
    private static let categoryViewWidth : CGFloat = 4.0
    private static let categoryViewTopMargin : CGFloat = 2.0
    private static let attendeeViewSize : CGFloat = 45.0
    
    private static let primaryFont = UIFont.systemFont(ofSize: 16.0)
    private static let secondaryFont = UIFont.systemFont(ofSize: 14.0)

    var categoryView = UIView()
    var attendeesView = UIView()
    
    lazy var subjectLabel: UILabel! = {
        let label = UILabel()
        label.font = EventCell.primaryFont
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        return label
    }()
    
    lazy var locationLabel: UILabel! = {
        let label = UILabel()
        label.font = EventCell.secondaryFont
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        
        return label
    }()
    
    lazy var timeLabel: UILabel! = {
        let label = UILabel()
        label.font = EventCell.secondaryFont
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        return label
    }()
    
    lazy var durationLabel: UILabel! = {
        let label = UILabel()
        label.font = EventCell.secondaryFont
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(categoryView)
        contentView.addSubview(subjectLabel)
        contentView.addSubview(attendeesView)
        contentView.addSubview(locationLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let timeLabelHeight = timeLabel.text?.size(withAttributes: [NSAttributedStringKey.font: EventCell.secondaryFont]).height ?? 0
        timeLabel.frame = CGRect(x: EventCell.categoryViewWidth + EventCell.margin, y: EventCell.margin, width: EventCell.timeLabelWidth, height: timeLabelHeight)
        
        var durationFrame = timeLabel.frame
        durationFrame.origin.y = timeLabel.frame.maxY + EventCell.spacing
        durationLabel.frame = durationFrame
        
        let subjectLabelX = timeLabel.frame.maxX + EventCell.spacing
        let subjectLabelHeight = subjectLabel.text?.size(withAttributes: [NSAttributedStringKey.font: EventCell.primaryFont]).height ?? 0
        let subjectLabelWidth = contentView.frame.size.width - subjectLabelX - EventCell.margin
        subjectLabel.frame = CGRect(x: subjectLabelX, y: EventCell.margin, width: subjectLabelWidth, height: subjectLabelHeight)
        
        var maxY = subjectLabel.frame.maxY

        if attendeesView.subviews.count > 0 {
            attendeesView.frame = CGRect(x: subjectLabelX, y: subjectLabel.frame.maxY + EventCell.spacing, width: EventCell.attendeeViewSize * CGFloat(attendeesView.subviews.count) + EventCell.spacing * CGFloat(attendeesView.subviews.count - 1 ) , height: EventCell.attendeeViewSize)
            
            var maxX : CGFloat = 0.0
            for view in attendeesView.subviews {
                view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
                view.frame = CGRect(x: maxX, y: 0.0, width: EventCell.attendeeViewSize, height: EventCell.attendeeViewSize)
                maxX += EventCell.attendeeViewSize + EventCell.spacing
            }

            maxY = attendeesView.frame.maxY
        }
        
        if let locationText = locationLabel.text,
            !locationText.isEmpty {
            let locationLabelHeight = locationLabel.text?.size(withAttributes: [NSAttributedStringKey.font: EventCell.secondaryFont]).height ?? 0
            locationLabel.frame = CGRect(x: subjectLabelX, y: maxY + EventCell.spacing, width: subjectLabelWidth, height: locationLabelHeight)
            maxY = locationLabel.frame.maxY
        }
        categoryView.frame = CGRect(x: 0.0, y: EventCell.categoryViewTopMargin, width: EventCell.categoryViewWidth, height: max(maxY, durationLabel.frame.maxY) + EventCell.margin - EventCell.categoryViewTopMargin)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timeLabel.text = nil
        durationLabel.text = nil
        subjectLabel.text = nil
        locationLabel.text = nil
        
        for view in attendeesView.subviews {
            view.removeFromSuperview()
        }
    }
    
    static func height(for event:Event) -> CGFloat {
        
        var rightSizeHeight = event.timeDescription.size(withAttributes: [NSAttributedStringKey.font: secondaryFont]).height + 2 * margin
        rightSizeHeight += event.durationDescription.size(withAttributes: [NSAttributedStringKey.font: secondaryFont]).height + spacing
        
        var leftSizeHeight = event.subject.size(withAttributes: [NSAttributedStringKey.font: primaryFont]).height + 2 * margin
        
        if event.attendees.count > 0 {
            leftSizeHeight += attendeeViewSize + spacing
        }
        
        if !event.location.isEmpty {
            leftSizeHeight += event.location.size(withAttributes: [NSAttributedStringKey.font: secondaryFont]).height + spacing
        }
        
        return max(rightSizeHeight, leftSizeHeight)
    }
}
