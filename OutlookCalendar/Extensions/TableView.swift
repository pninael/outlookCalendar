//
//  TableView.swift
//  OutlookCalendar
//
//  Created by Pnina Eliyahu on 1/28/18.
//  Copyright © 2018 Pnina Eliyahu. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToSection(section: Int, animated: Bool) {
        let indexPath = IndexPath(row: NSNotFound, section: section)
        scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}
