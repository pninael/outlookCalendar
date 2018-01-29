//
//  UILabel.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/28/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

extension UILabel {
    
    // Returns the label height for its current text and font
    var heightForText : CGFloat {
        return self.text?.size(withAttributes: [NSAttributedStringKey.font: self.font]).height ?? 0
    }
}
