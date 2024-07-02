//
//  ListViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit

final class ListViewController: UIViewController {
    private let listTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
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
        view.backgroundColor = .white
        
        let left = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        navigationItem.leftBarButtonItem = left
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        let right = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(filterButtonClicked))
        navigationItem.rightBarButtonItem = right
        navigationItem.rightBarButtonItem?.tintColor = .black
        
    }
    
    private func configureTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
    }
    
    @objc func plusButtonClicked() {
        print(#function)
        let registrationVC = RegistrationViewController()
        present(registrationVC, animated: true)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        return cell
    }
}

