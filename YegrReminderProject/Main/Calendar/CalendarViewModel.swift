//
//  CalendarViewModel.swift
//  YegrReminderProject
//
//  Created by YJ on 7/10/24.
//

import Foundation

class CalendarViewModel {
    var inputSelectedDate: Observable<Date?> = Observable(Date())
    var targetDateList: Observable<[TodoTable]> = Observable([])
    
    init() {
        inputSelectedDate.bind { date in
            guard let date = date else { return }
            self.fetchTargetDateList(date: date)
        }
    }
    
    func fetchTargetDateList(date: Date) {
        let targetDateText = DateFormatter.onlyDateFormatter.string(from: date)
        let objects = TodoRepository.shared.fetch()
        targetDateList.value = objects.filter { todoTable in
            if let deadline = todoTable.deadline {
                let deadlineText = DateFormatter.onlyDateFormatter.string(from: deadline)
                return deadlineText == targetDateText
            }
            
            return false
        }
    }
}
