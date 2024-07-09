//
//  DeadlineViewModel.swift
//  YegrReminderProject
//
//  Created by YJ on 7/9/24.
//

import Foundation

class DeadlineViewModel {
    var inputDateText: Observable<String?> = Observable("")
    var outputDateText = Observable("")
    
    init() {
        inputDateText.bind { _ in
            self.selectedDate()
        }
    }
    
    func selectedDate() {
        guard let date = inputDateText.value else { return }
        outputDateText.value = date
    }
}
