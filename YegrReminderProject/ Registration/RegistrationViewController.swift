//
//  RegistrationViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {
    let tableview = UITableView(frame: .zero, style: .insetGrouped)
    
    enum AddOption: Int, CaseIterable {
        case deadline
        case tag
        case priority
        case addImage
        
        var option: String {
            switch self {
            case .deadline:
                "마감일"
            case .tag:
                "태그"
            case .priority:
                "우선 순위"
            case .addImage:
                "이미지 추가"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
    }
    
    func configureHierarchy() {
        view.addSubview(tableview)
    }
    
    func configureLayout() {
        tableview.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "새로운 할 일"
        let left = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.leftBarButtonItem = left
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
        
        let right = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem = right
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
    }
    
    func configureTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(TitleMemoTableViewCell.self, forCellReuseIdentifier: TitleMemoTableViewCell.id)
    }
    
    @objc func cancelButtonClicked() {
        print(#function)
    }
    
    @objc func addButtonClicked() {
        print(#function)
    }
}

extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddOption.allCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleMemoTableViewCell.id, for: indexPath) as? TitleMemoTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = AddOption.allCases[indexPath.section - 1].option
            cell.textLabel?.textColor = .label
            return cell
        }
    }
}
