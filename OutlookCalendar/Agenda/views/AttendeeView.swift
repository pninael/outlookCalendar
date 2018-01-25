//
//  AttendeeView.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/25/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

class AttendeeView: UIView {
    
    var imageView : UIImageView! {
        return UIImageView()
    }
    
    init(image:UIImage) {
        super.init(frame:.zero)
        imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = frame
        layer.cornerRadius = frame.size.width/2
    }
}
