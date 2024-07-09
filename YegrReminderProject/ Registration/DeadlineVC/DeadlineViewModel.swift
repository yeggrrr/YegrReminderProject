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
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        inputDateText.bind { _ in
            self.selectedDate()
        }
        
        inputViewDidLoadTrigger.bind { date in
            let todayDate = DateFormatter.koreanDateFormatter.string(from: Date())
            self.outputDateText.value = todayDate
        }
    }
    
    func selectedDate() {
        guard let date = inputDateText.value else { return }
        outputDateText.value = date
    }
}
