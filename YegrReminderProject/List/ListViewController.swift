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
    private let listTableView = UITableView()

    var list: Results<TodoTable>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTableView.reloadData()
    }
    
    private func configureHierarchy() {
        view.addSubview(listTableView)
    }
    
    private func configureLayout() {
        listTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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
        
        // tableView
        list = realm.objects(TodoTable.self)
        print(realm.configuration.fileURL)
    }
    
    private func configureTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
    }
    
    @objc func plusButtonClicked() {
        let registrationVC = RegistrationViewController()
        let registrationNav = UINavigationController(rootViewController: registrationVC)
        registrationNav.modalPresentationStyle = .fullScreen
        present(registrationNav, animated: true)
    }
    
    @objc func filterButtonClicked() {
        print(#function)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "전체"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .systemBackground
        
        let data = list[indexPath.row]
        
        cell.titleLabel.text = data.memoTitle
        cell.memoLabel.text = data.Content
        cell.deadlineLabel.text = data.deadline
        
        return cell
    }
}

