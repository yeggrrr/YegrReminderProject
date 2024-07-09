//
//  DeadlineViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

final class DeadlineViewController:  BaseViewController {
    let deadlinViewModel = DeadlineViewModel()
    
    private let deadlineDatePicker = UIDatePicker()
    private let dateLabel = UILabel()
    
    var selectedDate: Date?
    weak var delegate: UpdateDeadlineDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSelectedDate()
        bindData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updateDeadlineAfterDismiss(date: deadlineDatePicker.date)
    }
    
    func bindData() {
        deadlinViewModel.outputDateText.bind { date in
            self.dateLabel.text = date
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(deadlineDatePicker)
        view.addSubview(dateLabel)
    }
    
    override func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        deadlineDatePicker.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.centerX.equalTo(safeArea.snp.centerX)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineDatePicker.snp.bottom).offset(20)
            $0.centerX.equalTo(safeArea.snp.centerX)
        }
    }
    
    override func configureUI() {
        view.backgroundColor = .systemBackground
        title = "마감일 설정"
        
        deadlineDatePicker.preferredDatePickerStyle = .inline
        deadlineDatePicker.datePickerMode = .date
        deadlineDatePicker.locale = Locale(identifier: "ko_KR")
        deadlineDatePicker.backgroundColor = .systemGray5
        deadlineDatePicker.layer.cornerRadius = 10
        deadlineDatePicker.clipsToBounds = true
        deadlineDatePicker.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
        
        dateLabel.setUI(txtColor: .label, fontStyle: .systemFont(ofSize: 15, weight: .regular), txtAlignment: .center)
    }
    
    private func getSelectedDate() {
        if let selectedDate = selectedDate {
            deadlineDatePicker.date = selectedDate
        }
    }
    
    @objc func dateSelected(_ sender: UIDatePicker) {
        let selectedDate = DateFormatter.koreanDateFormatter.string(from: sender.date)
        deadlinViewModel.inputDateText.value = selectedDate
    }
}

protocol UpdateDeadlineDelegate: AnyObject {
    func updateDeadlineAfterDismiss(date: Date)
}

