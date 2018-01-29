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
    private static let categoryViewSize : CGFloat = 10.0
    private static let attendeeViewSize : CGFloat = 45.0
    private static let subjectLabelOffset : CGFloat = 15.0
    
    private static let primaryFont = UIFont.systemFont(ofSize: 16.0)
    private static let secondaryFont = UIFont.systemFont(ofSize: 12.0, weight: .light)

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
        
        // Time label
        timeLabel.frame = CGRect(x: EventCell.margin,
                                 y: EventCell.margin,
                                 width: EventCell.timeLabelWidth,
                                 height: timeLabel.heightForText)
        
        // Duration label
        // durationLabel has the same frame properties like timeLabel, except for the y position
        var durationFrame = timeLabel.frame
        durationFrame.origin.y = timeLabel.frame.maxY + EventCell.spacing
        durationLabel.frame = durationFrame
        
        
        // Ctegory view
        categoryView.frame = CGRect(x: timeLabel.frame.maxX,
                                    y: EventCell.margin,
                                    width: EventCell.categoryViewSize,
                                    height: EventCell.categoryViewSize)
        categoryView.layer.cornerRadius = EventCell.categoryViewSize / 2
        categoryView.center.y = timeLabel.center.y
        
        // Subject label
        let subjectLabelX = categoryView.frame.maxX + EventCell.subjectLabelOffset
        let subjectLabelWidth = contentView.frame.size.width - subjectLabelX - EventCell.margin
        subjectLabel.frame = CGRect(x: subjectLabelX,
                                    y: EventCell.margin,
                                    width: contentView.frame.size.width - subjectLabelX - EventCell.margin,
                                    height: subjectLabel.heightForText)
        subjectLabel.center.y = categoryView.center.y

        var maxY = subjectLabel.frame.maxY

        // Attendees view
        if attendeesView.subviews.count > 0 {
            let attendeesViewWidth = EventCell.attendeeViewSize * CGFloat(attendeesView.subviews.count) + EventCell.spacing * CGFloat(attendeesView.subviews.count - 1)
            attendeesView.frame = CGRect(x: subjectLabelX,
                                         y: subjectLabel.frame.maxY + EventCell.spacing,
                                         width: attendeesViewWidth ,
                                         height: EventCell.attendeeViewSize)
            
            var maxX : CGFloat = 0.0
            
            // Layout attendees views
            for view in attendeesView.subviews {
                view.frame = CGRect(x: maxX,
                                    y: 0,
                                    width: EventCell.attendeeViewSize,
                                    height: EventCell.attendeeViewSize)
                maxX += EventCell.attendeeViewSize + EventCell.spacing
                view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
            }
            maxY = attendeesView.frame.maxY
        }
        
        // Location label
        if let locationText = locationLabel.text, !locationText.isEmpty {
            locationLabel.frame = CGRect(x: subjectLabelX,
                                         y: maxY + EventCell.spacing,
                                         width: subjectLabelWidth,
                                         height: locationLabel.heightForText)
        }
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
    
    // Returns the calculated height of the cell
    static func height(for event:Event) -> CGFloat {
        
        // Size for the right side of the cell (time, duration)
        var rightSizeHeight = event.timeDescription.size(withAttributes: [NSAttributedStringKey.font: secondaryFont]).height + 2 * margin
        rightSizeHeight += event.durationDescription.size(withAttributes: [NSAttributedStringKey.font: secondaryFont]).height + spacing
        
        // Size for the left side of the cell (subject, attendees, location)
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
