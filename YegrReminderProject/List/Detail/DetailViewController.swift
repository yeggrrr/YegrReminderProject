//
//  DetailViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit
import RealmSwift

final class DetailViewController: BaseViewController {
    private let detailView = DetailView()
    private let xButton = UIButton()
    private let buttonStackView = UIStackView()
    private let updateButton = UIButton()
    private let deleteButton = UIButton()
    
    let realm = try! Realm()
    var todo: TodoTable?
    weak var delegate: UpdateListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updateList()
    }
    
    override func configureHierarchy() {
        view.addSubview(xButton)
        view.addSubview(detailView)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(updateButton)
        buttonStackView.addArrangedSubview(deleteButton)
    }
    
    override func configureLayout() {
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
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(detailView.snp.horizontalEdges)
            $0.height.equalTo(45)
        }
    }
    
    override func configureUI() {
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = .label
        xButton.addTarget(self, action: #selector(xButtonClicked), for: .touchUpInside)
        
        detailView.backgroundColor = .lightGray
        detailView.layer.cornerRadius = 10
        detailView.layer.borderWidth = 3
        detailView.layer.borderColor = UIColor.white.cgColor
        
        guard let todo = todo else { return }
        detailView.titleLabel.text = todo.memoTitle
        
        if let memo = todo.content {
            detailView.memoLabel.text = memo
        } else {
            detailView.memoLabel.text = ""
        }
        
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
        
        detailView.selectedImage.image = loadImageToDocument(filename: "\(todo.id)")
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        
        updateButton.setTitle("수정하기", for: .normal)
        updateButton.tintColor = .label
        updateButton.backgroundColor = .lightGray
        updateButton.layer.cornerRadius = 10
        updateButton.layer.borderWidth = 3
        updateButton.layer.borderColor = UIColor.white.cgColor
        updateButton.addTarget(self, action: #selector(updateButtonClicked), for: .touchUpInside)
        
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.tintColor = .label
        deleteButton.backgroundColor = .lightGray
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.borderWidth = 3
        deleteButton.layer.borderColor = UIColor.white.cgColor
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    @objc func xButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func updateButtonClicked() {
        print(#function)
    }
    
    @objc func deleteButtonClicked() {
        guard let todo = todo else { return }
        try! realm.write {
            realm.delete(todo)
        }
        
        dismiss(animated: true)
        
    }
}

protocol UpdateListDelegate: AnyObject {
    func updateList()
}
