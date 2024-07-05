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
        dateFormat.locale = Locale(identifier:"ko_KR")
        dateFormat.dateFormat = "yyyy.MM.dd(E)"
        return dateFormat
    }()
}
