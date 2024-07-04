//
//  DeadlineViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

final class DeadlineViewController: UIViewController {
    private let deadlineDatePicker = UIDatePicker()
    
    var selectedDate: Date?
    weak var delegate: UpdateDeadlineDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        getSelectedDate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updateDeadlineAfterDismiss(date: deadlineDatePicker.date)
    }
    
    private func configureHierarchy() {
        view.addSubview(deadlineDatePicker)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        deadlineDatePicker.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.centerX.equalTo(safeArea.snp.centerX)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "마감일 설정"
        
        deadlineDatePicker.preferredDatePickerStyle = .inline
        deadlineDatePicker.datePickerMode = .date
        deadlineDatePicker.locale = Locale(identifier: "ko_KR")
        deadlineDatePicker.backgroundColor = UIColor(named: "PickerViewColor")
        deadlineDatePicker.layer.cornerRadius = 10
        deadlineDatePicker.clipsToBounds = true
    }
    
    private func getSelectedDate() {
        if let selectedDate = selectedDate {
            deadlineDatePicker.date = selectedDate
        }
    }
}

protocol UpdateDeadlineDelegate: AnyObject {
    func updateDeadlineAfterDismiss(date: Date)
}

