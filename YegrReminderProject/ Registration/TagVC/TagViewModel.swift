//
//  TagViewModel.swift
//  YegrReminderProject
//
//  Created by YJ on 7/10/24.
//

import Foundation

class TagViewModel {
    var inputTagText: Observable<String?> = Observable("")
    var outputTagText = Observable("")
    
    init() {
        inputTagText.bind { _ in
            self.changeValueTextField()
        }
    }
    
    func changeValueTextField() {
        guard let text = inputTagText.value else { return }
        outputTagText.value = "# \(text)"
    }
}
