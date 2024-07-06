//
//  RegistrationViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift
import PhotosUI

final class RegistrationViewController: BaseViewController {
    private let tableview = UITableView(frame: .zero, style: .insetGrouped)
    
    private let realm = try! Realm()
    weak var delegate: UpdateListCountDelegate?
    
    private var selectedImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    private var sectionData: [(addOption: AddOption, selectedData: String)] = [
        (.title, ""), (.deadline, ""), (.tag, ""), (.priority, ""), (.addImage, "")
    ]
    
    var viewType: ViewType = .add
    var selectedTodo: TodoTable?
    
    enum AddOption: Int, CaseIterable {
        case title
        case deadline
        case tag
        case priority
        case addImage
        
        var option: String {
            switch self {
            case .title: ""
            case .deadline: "마감일"
            case .tag: "태그"
            case .priority: "우선 순위"
            case .addImage: "이미지 추가"
            }
        }
    }
    
    enum Priority: Int {
        case high = 0
        case normal
        case low
        
        var meaning: String {
            switch self {
            case .high: "높음"
            case .normal: "보통"
            case .low: "낮음"
            }
        }
    }
    
    enum ViewType {
        case add
        case update
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        configureTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updateListCount()
    }
    
    override func configureHierarchy() {
        view.addSubview(tableview)
    }
    
    override func configureLayout() {
        tableview.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        view.backgroundColor = .systemBackground
        
        let navigationTitle = viewType == .add ? "새로운 할 일" : "수정하기"
        navigationItem.title = navigationTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .systemBlue
        
        let left = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.leftBarButtonItem = left
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
        
        let rightBarButtonTitle = viewType == .add ? "추가" : "수정"
        let right = UIBarButtonItem(title: rightBarButtonTitle, style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem = right
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configureTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(TitleMemoTableViewCell.self, forCellReuseIdentifier: TitleMemoTableViewCell.id)
        tableview.register(AddImageTableViewCell.self, forCellReuseIdentifier: AddImageTableViewCell.id)
    }
    
    private func initializeData() {
        switch viewType {
        case .add:
            selectedTodo = TodoTable(memoTitle: "")
        case .update:
            var deadlineText = ""
            if let deadline = selectedTodo?.deadline {
                deadlineText = DateFormatter.deadlineDateFormatter.string(from: deadline)
            }
            
            let tagText = selectedTodo?.tag ?? ""
            var priorityText = ""
            if let priority = selectedTodo?.priority {
                if let value = Priority(rawValue: priority) {
                    priorityText = value.meaning
                }
            }
            
            sectionData = [
                (.title, ""), (.deadline, deadlineText), (.tag, tagText), (.priority, priorityText), (.addImage, "")
            ]
        }
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        guard let cell = tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? TitleMemoTableViewCell else { return }
        guard let titleText = cell.titleTextField.text, !titleText.isEmpty else { return }
        guard let contentText = cell.memoTextView.text else { return }
        
        switch viewType {
        case .add:
            let newTodo = TodoTable(
                memoTitle: titleText,
                content: contentText,
                deadline: selectedTodo?.deadline,
                tag: selectedTodo?.tag,
                priority: selectedTodo?.priority)
            
            if let image = selectedImage {
                saveImageToDocument(image: image, filename: "\(newTodo.id)")
            }
            
            try! realm.write {
                realm.add(newTodo)
            }
            
        case .update:
            try! realm.write {
                selectedTodo?.memoTitle = titleText
                selectedTodo?.content = contentText
            }
            
            if let selectedTodo = selectedTodo {
                if let image = selectedImage {
                    saveImageToDocument(image: image, filename: "\(selectedTodo.id)")
                }
                
                try! realm.write {
                    realm.add(selectedTodo)
                }
            }
        }
        
        dismiss(animated: true)
    }
    
    @objc func validateTitle(_ textField: UITextField) {
        guard let text = textField.text else { return }
        navigationItem.rightBarButtonItem?.isEnabled = !text.isEmpty
    }
}

extension RegistrationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleMemoTableViewCell.id, for: indexPath) as? TitleMemoTableViewCell else { return UITableViewCell() }
            if viewType == .update {
                cell.titleTextField.text = selectedTodo?.memoTitle
                cell.memoTextView.text = selectedTodo?.content
            }
            cell.titleTextField.addTarget(self, action: #selector(validateTitle(_:)), for: .editingChanged)
            return cell
        } else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddImageTableViewCell.id, for: indexPath) as? AddImageTableViewCell else { return UITableViewCell() }
            cell.accessoryType = .disclosureIndicator
            cell.selectedImageView.image = selectedImage
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = .label
            cell.textLabel?.text = sectionData[indexPath.section].addOption.option
            cell.detailTextLabel?.text = sectionData[indexPath.section].selectedData
            
            if indexPath.row == 3 {
                cell.imageView?.image = UIImage(systemName: "star")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let vc = DeadlineViewController()
            vc.delegate = self
            vc.selectedDate = selectedTodo?.deadline
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = TagViewController()
            vc.delegate = self
            vc.inputTag = selectedTodo?.tag
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = PriorityViewController()
            vc.delegate = self
            vc.selectedPriority = selectedTodo?.priority
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let configuration = PHPickerConfiguration()
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            navigationController?.pushViewController(picker, animated: true)
        default:
            break
        }
    }
}

extension RegistrationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension RegistrationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                self.selectedImage = image as? UIImage
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension RegistrationViewController: UpdateDeadlineDelegate {
    func updateDeadlineAfterDismiss(date: Date) {
        try! realm.write {
            selectedTodo?.deadline = date
        }
        
        var index = 0
        for i in 0..<sectionData.count {
            let item = sectionData[i]
            if item.addOption == .deadline {
                index = i
                break
            }
        }
        
        sectionData[index].selectedData = DateFormatter.deadlineDateFormatter.string(from: date)
        tableview.reloadData()
    }
}

extension RegistrationViewController: UpdateTagDelegate {
    func updateTagAfterDismiss(tag: String) {
        guard !tag.isEmpty else { return }
        try! realm.write {
            selectedTodo?.tag = tag
        }
        
        var index = 0
        for i in 0..<sectionData.count {
            let item = sectionData[i]
            if item.addOption == .tag {
                index = i
                break
            }
        }
        
        sectionData[index].selectedData = tag
        tableview.reloadData()
    }
}

extension RegistrationViewController: UpdatePriorityDelegate {
    func updatePriorityAfterDismiss(priority: Int) {
        try! realm.write {
            selectedTodo?.priority = priority
        }
        
        var index = 0
        for i in 0..<sectionData.count {
            let item = sectionData[i]
            if item.addOption == .priority {
                index = i
                break
            }
        }
        
        if let value = Priority(rawValue: priority) {
            sectionData[index].selectedData = value.meaning
            tableview.reloadData()
        }
    }
}
