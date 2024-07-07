//
//  ListViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ListViewController: BaseViewController {
    private let currentTitleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let listTableView = UITableView()
    
    private let realm = try! Realm()
    
    weak var delegate: UpdateListCountDelegate?
    var listFilterType: MainViewController.ListFilterType?
    var detailFilterType: DetailFilterType?
    var filterList: [TodoTable] = []
    var detailFilterList: [TodoTable] = []
    var searchedList: [TodoTable] = []
    
    enum Priority: Int {
        case high = 0
        case normal
        case low
        
        var color: UIColor {
            switch self {
            case .high:
                    .systemRed
            case .normal:
                    .systemYellow
            case .low:
                    .systemGreen
            }
        }
    }
    
    enum DetailFilterType {
        case closeToDeadline
        case ascendingTitle
        case lowToHighPriority
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        filterData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updateListCount()
    }
    
    func filterData() {
        guard let listFilterType = listFilterType else { return }
        
        let objects = Array(realm.objects(TodoTable.self))
        let todayText = DateFormatter.onlyDateFormatter.string(from: Date())
        
        switch listFilterType {
        case .today:
            filterList = objects.filter {
                if let deadline = $0.deadline {
                    let deadlineText = DateFormatter.onlyDateFormatter.string(from: deadline)
                    return deadlineText == todayText
                } else {
                    return false
                }
            }
        case .scheduled:
            filterList = objects.filter {
                if let deadline = $0.deadline {
                    let deadlineText = DateFormatter.onlyDateFormatter.string(from: deadline)
                    return deadlineText > todayText
                } else {
                    return false
                }
            }
        case .entire:
            filterList = objects
        case .flag:
            filterList = objects.filter { $0.flag }
        case .complete:
            filterList = objects.filter { $0.isDone }
        }
    }
    
    func detailFilterData(filterType: DetailFilterType) {
        detailFilterType = filterType
        
        switch filterType {
        case .closeToDeadline:
            detailFilterList = filterList.sorted(by: { lhs, rhs in
                let lhsDeadline = lhs.deadline ?? .distantFuture
                let rhsDeadline = rhs.deadline ?? .distantFuture
                return lhsDeadline < rhsDeadline
            })
        case .ascendingTitle:
            detailFilterList = filterList.sorted(by: { lhs, rhs in
                lhs.memoTitle < rhs.memoTitle
            })
        case .lowToHighPriority:
            detailFilterList = filterList.sorted(by: { lhs, rhs in
                let lhsPriority = lhs.priority ?? Priority.low.rawValue
                let rhsPriority = rhs.priority ?? Priority.low.rawValue
                return lhsPriority < rhsPriority
            })
        }
        
        listTableView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(currentTitleLabel)
        view.addSubview(searchBar)
        view.addSubview(listTableView)
    }
    
    override func configureLayout() {
        currentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(40)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(currentTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        view.backgroundColor = .systemBackground
        
        let right = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(filterButtonClicked))
        navigationItem.rightBarButtonItem = right
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        currentTitleLabel.text = listFilterType?.rawValue
        currentTitleLabel.textColor = .label
        currentTitleLabel.font = .systemFont(ofSize: 35, weight: .bold)
        
        searchBar.placeholder = "제목이나 내용을 입력해주세요"
        searchBar.delegate = self
    }
    
    private func configureTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
    }
    
    @objc func filterButtonClicked() {
        let alert = UIAlertController(title: "정렬 & 핉터", message: nil, preferredStyle: .actionSheet)
        let deadline = UIAlertAction(title: "마감일 순으로 보기", style: .default) { _ in
            self.detailFilterData(filterType: .closeToDeadline)
        }
        
        let title = UIAlertAction(title: "제목 순으로 보기", style: .default) { _ in
            self.detailFilterData(filterType: .ascendingTitle)
        }
        
        let priority = UIAlertAction(title: "우선순위 낮은 순으로 보기", style: .default) { _ in
            self.detailFilterData(filterType: .lowToHighPriority)
        }
        
        let orginally = UIAlertAction(title: "기본", style: .default) { _ in
            self.detailFilterType = nil
            self.listTableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(deadline)
        alert.addAction(title)
        alert.addAction(priority)
        alert.addAction(orginally)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    @objc func completeButtonClicked(_ sender: UIButton) {
        let datas: [TodoTable] = detailFilterType == nil ? filterList : detailFilterList
        let result = datas[sender.tag]
        
        do {
            switch result.isDone {
            case true:
                try realm.write {
                    result.setValue(false, forKey: "isDone")
                }
            case false:
                try realm.write {
                    result.setValue(true, forKey: "isDone")
                }
            }
        } catch {
            print(error)
        }
        
        listTableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedList.isEmpty {
            return filterList.count
        } else {
            return searchedList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        let data: TodoTable =
        if !searchedList.isEmpty {
            searchedList[indexPath.row]
        } else if detailFilterType == nil {
            filterList[indexPath.row]
        } else {
            detailFilterList[indexPath.row]
        }

        cell.selectionStyle = .none
        cell.checkButton.tag = indexPath.row
        cell.titleLabel.text = data.memoTitle
        cell.memoLabel.text = data.content
        
        cell.flagImageView.image = UIImage(systemName: "flag.fill")
        cell.flagImageView.isHidden = !data.flag
        
        if let deadline = data.deadline {
            cell.deadlineLabel.text = DateFormatter.deadlineDateFormatter.string(from: deadline)
        } else {
            cell.deadlineLabel.text = ""
        }
        
        if let tag = data.tag {
            cell.tagLabel.text = "# \(tag)"
        } else {
            cell.tagLabel.text = ""
        }
        
        if let priority = data.priority {
            cell.priorityView.backgroundColor = Priority(rawValue: priority)?.color
        } else {
            cell.priorityView.backgroundColor = .clear
        }
        
        if data.isDone {
            cell.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            cell.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        
        cell.checkButton.addTarget(self, action: #selector(completeButtonClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if searchedList.isEmpty {
            vc.todo = filterList[indexPath.row]
        } else {
            vc.todo = searchedList[indexPath.row]
        }
        
        vc.delegate = self
        present(vc,animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            try! self.realm.write {
                if self.searchedList.isEmpty {
                    let data = self.searchedList[indexPath.row]
                    self.removeImageFromDocument(filename: "\(data.id)")
                    self.realm.delete(self.searchedList[indexPath.row])
                    self.listTableView.reloadData()
                } else {
                    let data = self.filterList[indexPath.row]
                    self.removeImageFromDocument(filename: "\(data.id)")
                    self.realm.delete(self.filterList[indexPath.row])
                    self.listTableView.reloadData()
                }
            }
            
            success(true)
        }
    
        let edit = UIContextualAction(style: .normal, title: "편집") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("편집 클릭 됨")
            success(true)
        }
        
        delete.backgroundColor = .systemPink
        edit.backgroundColor = .systemYellow
        
        return UISwipeActionsConfiguration(actions:[delete, edit])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let flag = UIContextualAction(style: .normal, title: "") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let result = self.filterList[indexPath.row]
            
            do {
                switch result.flag {
                case true:
                    try self.realm.write {
                        result.setValue(false, forKey: "flag")
                    }
                case false:
                    try self.realm.write {
                        result.setValue(true, forKey: "flag")
                    }
                }
            } catch {
                print(error)
            }
            
            self.listTableView.reloadData()
            success(true)
        }
        
        flag.image = UIImage(systemName: "flag.fill")
        flag.backgroundColor = .systemCyan
        return UISwipeActionsConfiguration(actions:[flag])
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchedList = []
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            let data: [TodoTable] =
            if detailFilterType == nil {
                filterList
            } else {
                detailFilterList
            }
            
            searchedList = data.filter {
                let titleContains = $0.memoTitle.contains(searchText)
                
                if let content = $0.content {
                    let contentContains = content.contains(searchText)
                    return titleContains || contentContains
                } else {
                    return titleContains
                }
            }
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        listTableView.reloadData()
    }
}

extension ListViewController: UpdateListDelegate {
    func updateList() {
        filterData()
        if let detailFilterType = detailFilterType {
            detailFilterData(filterType: detailFilterType)
        }
        listTableView.reloadData()
    }
}

protocol UpdateListCountDelegate: AnyObject {
    func updateListCount()
}
