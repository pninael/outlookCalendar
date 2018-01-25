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
    
    private static let timeLabelWidth : CGFloat = 50.0
    private static let categoryViewWidth : CGFloat = 4.0
    private static let categoryViewTopMargin : CGFloat = 2.0
    private static let attendeeViewSize : CGFloat = 50.0
    
    private static let primaryFont = UIFont.systemFont(ofSize: 14.0)
    private static let secondaryFont = UIFont.systemFont(ofSize: 12.0)

    lazy var subjectLabel: UILabel! = {
        let label = UILabel()
        label.font = EventCell.primaryFont
        label.textAlignment = .left
        label.numberOfLines = 2
        
        //label.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)

        return label
    }()
    
    lazy var locationLabel: UILabel! = {
        let label = UILabel()
        label.font = EventCell.secondaryFont
        label.textAlignment = .left
        
        //label.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)

        return label
    }()
    
    lazy var timeLabel: UILabel! = {
        let label = UILabel()
        label.font = EventCell.secondaryFont
        label.textAlignment = .left
        
        //label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return label
    }()
    
    lazy var durationLabel: UILabel! = {
        let label = UILabel()
        label.font = EventCell.secondaryFont
        label.textAlignment = .left
        
        //label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)

        return label
    }()
    
    lazy var attendeesView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        //stackView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        return stackView
    }()
    
    lazy var categoryView: UIView! = {
        let view = UIView()
        return view
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
        timeLabel.frame = CGRect(x: EventCell.categoryViewWidth + EventCell.spacing, y: EventCell.margin, width: EventCell.timeLabelWidth, height: timeLabelHeight)
        
        var durationFrame = timeLabel.frame
        durationFrame.origin.y = timeLabel.frame.maxY + EventCell.spacing
        durationLabel.frame = durationFrame
        
        let subjectLabelX = timeLabel.frame.maxX + EventCell.spacing
        let subjectLabelHeight = subjectLabel.text?.size(withAttributes: [NSAttributedStringKey.font: EventCell.primaryFont]).height ?? 0
        let subjectLabelWidth = contentView.frame.size.width - subjectLabelX - EventCell.margin
        subjectLabel.frame = CGRect(x: subjectLabelX, y: EventCell.margin, width: subjectLabelWidth, height: subjectLabelHeight)
        
        var lastFrameY = subjectLabel.frame.maxY

        if attendeesView.subviews.count > 0 {
            attendeesView.frame = CGRect(x: subjectLabelX, y: subjectLabel.frame.maxY + EventCell.spacing, width: subjectLabelWidth, height: EventCell.attendeeViewSize)
            lastFrameY = attendeesView.frame.maxY
        }
        
        let locationLabelHeight = locationLabel.text?.size(withAttributes: [NSAttributedStringKey.font: EventCell.secondaryFont]).height ?? 0
        locationLabel.frame = CGRect(x: subjectLabelX, y: lastFrameY + EventCell.spacing, width: subjectLabelWidth, height: locationLabelHeight)
        
        categoryView.frame = CGRect(x: 0.0, y: EventCell.categoryViewTopMargin, width: EventCell.categoryViewWidth, height: max(durationLabel.frame.maxY, locationLabel.frame.maxY) + EventCell.margin - EventCell.categoryViewTopMargin)
    }
    
    override func prepareForReuse() {
        timeLabel.text = nil
        durationLabel.text = nil
        subjectLabel.text = nil
        locationLabel.text = nil
        for view in attendeesView.subviews {
            attendeesView.removeArrangedSubview(view)
        }
    }
    
    static func height(for event:Event) -> CGFloat {
        let subjectHeight = event.subject.size(withAttributes: [NSAttributedStringKey.font: primaryFont]).height
        let attendeesViewHeight = event.attendees.count > 0 ? attendeeViewSize : 0
        let locationHeight = event.location.size(withAttributes: [NSAttributedStringKey.font: secondaryFont]).height
        
        return subjectHeight + attendeesViewHeight + locationHeight + 2 * margin
    }
}
