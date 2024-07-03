//
//  DetailViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    private let detailView = DetailView()
    private let xButton = UIButton()
    
    var todo: TodoTable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    private func configureHierarchy() {
        view.addSubview(xButton)
        view.addSubview(detailView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        xButton.snp.makeConstraints {
            $0.trailing.equalTo(detailView)
            $0.bottom.equalTo(detailView.snp.top).offset(-10)
            $0.height.width.equalTo(30)
        }
        
        detailView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea).inset(50)
            $0.verticalEdges.equalTo(safeArea).inset(100)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = .label
        xButton.addTarget(self, action: #selector(xButtonClicked), for: .touchUpInside)
        
        detailView.backgroundColor = .lightGray
        detailView.layer.cornerRadius = 10
        detailView.layer.borderWidth = 3
        detailView.layer.borderColor = UIColor.white.cgColor
        
        guard let todo = todo else { return }
        detailView.titleLabel.text = todo.memoTitle
        detailView.memoLabel.text = todo.content
        
        if let deadline = todo.deadline {
            detailView.deadlineLabel.text = DateFormatter.deadlineDateFormatter.string(from: deadline)
        } else {
            detailView.deadlineLabel.text = "-"
        }
        
        if let tag = todo.tag {
            detailView.tagLabel.text = "#\(tag)"
        } else {
            detailView.tagLabel.text = "-"
        }
        
        if let rawValue = todo.priority,
           let priority = RegistrationViewController.Priority(rawValue: rawValue) {
            detailView.priorityLabel.text = priority.meaning
        } else {
            detailView.priorityLabel.text = "-"
        }
    }
    
    @objc func xButtonClicked() {
        dismiss(animated: true)
    }
}
