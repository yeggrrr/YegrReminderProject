//
//  DeadlineViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

class DeadlineViewController: UIViewController {
    let deadlineDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy() {
        view.addSubview(deadlineDatePicker)
    }
    
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        deadlineDatePicker.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.centerX.equalTo(safeArea.snp.centerX)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        deadlineDatePicker.preferredDatePickerStyle = .inline
        deadlineDatePicker.datePickerMode = .date
        deadlineDatePicker.locale = Locale(identifier: "ko_KR")
        deadlineDatePicker.addTarget(self, action: #selector(datePickerClicked), for: .valueChanged)
    }
    
    @objc func datePickerClicked(_ sender: UIDatePicker) {
        let datePicker = sender
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd"
        print(dateFormat.string(from: sender.date))
    }
}

