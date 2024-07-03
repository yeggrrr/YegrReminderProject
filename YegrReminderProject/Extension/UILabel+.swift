//
//  UILabel+.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit

extension UILabel {
    func setUI(txtColor: UIColor, fontStyle: UIFont, txtAlignment: NSTextAlignment) {
        textColor = txtColor
        font = fontStyle
        textAlignment = txtAlignment
    }
    
    func detailUI(txt: String, txtColor: UIColor, txtAlignment: NSTextAlignment, fontStyle: UIFont) {
        text = txt
        textColor = txtColor
        textAlignment = txtAlignment
        font = fontStyle
    }
}
