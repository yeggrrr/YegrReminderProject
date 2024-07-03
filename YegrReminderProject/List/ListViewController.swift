//
//  ListViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ListViewController: UIViewController {
    let currentTitleLabel = UILabel()
    private let listTableView = UITableView()
    
    let realm = try! Realm()
    var list: Results<TodoTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
    }
    
    private func configureHierarchy() {
        view.addSubview(currentTitleLabel)
        view.addSubview(listTableView)
    }
    
    private func configureLayout() {
        currentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(40)
        }
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(currentTitleLabel.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let left = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        navigationItem.leftBarButtonItem = left
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        let right = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(filterButtonClicked))
        navigationItem.rightBarButtonItem = right
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        currentTitleLabel.text = "전체"
        currentTitleLabel.textColor = .systemBlue
        currentTitleLabel.font = .systemFont(ofSize: 35, weight: .bold)
        
        fetch()
    }
    
    private func fetch() {
        list = realm.objects(TodoTable.self)
    }
    
    private func configureTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
    }
    
    @objc func plusButtonClicked() {
        let registrationVC = RegistrationViewController()
        registrationVC.delegate = self
        let registrationNav = UINavigationController(rootViewController: registrationVC)
        present(registrationNav, animated: true)
    }
    
    @objc func filterButtonClicked() {
        print(#function)
        let alert = UIAlertController(title: "정렬 & 핉터", message: nil, preferredStyle: .actionSheet)
        let deadline = UIAlertAction(title: "마감일 순으로 보기", style: .default) { _ in
            self.list = self.realm.objects(TodoTable.self).sorted(byKeyPath: "deadline", ascending: true)
            self.listTableView.reloadData()
        }
        
        let title = UIAlertAction(title: "제목 순으로 보기", style: .default) { _ in
            self.list = self.realm.objects(TodoTable.self).sorted(byKeyPath: "memoTitle", ascending: true)
            self.listTableView.reloadData()
        }
        
        let priority = UIAlertAction(title: "우선순위 낮은 순으로 보기", style: .default) { _ in
            self.list = self.realm.objects(TodoTable.self).sorted(byKeyPath: "priority", ascending: true)
            self.listTableView.reloadData()
        }
        
        alert.addAction(deadline)
        alert.addAction(title)
        alert.addAction(priority)
        
        present(alert, animated: true)
        
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let data = list[indexPath.row]
        cell.titleLabel.text = data.memoTitle
        cell.memoLabel.text = data.Content
        cell.deadlineLabel.text = data.deadline
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            try! self.realm.write {
                self.realm.delete(self.list[indexPath.row])
                self.listTableView.reloadData()
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
}

extension ListViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ListViewController: DismissDelegate {
    func updateDataAfterDismiss() {
        listTableView.reloadData()
    }
}
