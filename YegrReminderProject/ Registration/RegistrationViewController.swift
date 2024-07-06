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
    
    private var deadline: Date?
    private var inputTag: String?
    private var selectPriority: Int?
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
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        guard let cell = tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? TitleMemoTableViewCell else { return }
        guard let titleText = cell.titleTextField.text else { return }
        guard let contentText = cell.memoTextView.text else { return }
        
        if !titleText.isEmpty {
            let data = TodoTable(
                memoTitle: titleText,
                Content: contentText,
                deadline: deadline,
                tag: inputTag,
                priority: selectPriority,
                image: nil,
                isDone: false,
                flag: false
            )
            
            if let image = selectedImage {
                saveImageToDocument(image: image, filename: "\(data.id)")
            }
            
            try! realm.write {
                realm.add(data)
            }
            
            dismiss(animated: true)
        }
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
            vc.selectedDate = deadline
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = TagViewController()
            vc.delegate = self
            vc.inputTag = inputTag
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = PriorityViewController()
            vc.delegate = self
            vc.selectedPriority = selectPriority
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
        deadline = date
        
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
        inputTag = tag
        
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
        selectPriority = priority
        
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
