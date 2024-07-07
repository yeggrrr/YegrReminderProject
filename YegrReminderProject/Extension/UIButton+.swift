//
//  UIButton+.swift
//  YegrReminderProject
//
//  Created by YJ on 7/7/24.
//

import UIKit

extension UIButton {
    func setUI(title: String) {
        setTitle(title, for: .normal)
        tintColor = .label
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
    }
}
