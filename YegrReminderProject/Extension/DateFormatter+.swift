//
//  DateFormatter+.swift
//  YegrReminderProject
//
//  Created by YJ on 7/4/24.
//

import UIKit

extension DateFormatter {
    static let deadlineDateFormatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd"
        return dateFormat
    }()
}
