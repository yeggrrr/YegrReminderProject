//
//  MainViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit
import RealmSwift

final class MainViewController: BaseViewController {
    private let currentTitleLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collecionViewLayout())
    private let newTodoButton = UIButton()
    private let addListButton = UIButton()
    
    let todoList: [TodoTable] = []
    
    private var totalCount: Int = 0
    
    let buttonList: [ListFilterType] = [.today, .scheduled, .entire, .flag, .complete]
    var todayList: [TodoTable] = []
    var scheduleList: [TodoTable] = []
    var totalList: [TodoTable] = []
    var flagList: [TodoTable] = []
    var completeList: [TodoTable] = []
    
    enum ListFilterType: String, CaseIterable {
        case today = "오늘"
        case scheduled = "예정"
        case entire = "전체"
        case flag = "깃발 표시"
        case complete = "완료됨"
        
        var imageName: String {
            switch self {
            case .today:
                "doc.circle.fill"
            case .scheduled:
                "calendar.circle.fill"
            case .entire:
                "tray.circle.fill"
            case .flag:
                "flag.circle.fill"
            case .complete:
                "checkmark.circle.fill"
            }
        }
        
        var color: UIColor {
            switch self {
            case .today:
                    .systemBlue
            case .scheduled:
                    .systemRed
            case .entire:
                    .lightGray
            case .flag:
                    .systemCyan
            case .complete:
                    .systemIndigo
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        updateCount()
    }
    
    override func configureHierarchy() {
        view.addSubview(currentTitleLabel)
        view.addSubview(collectionView)
        view.addSubview(newTodoButton)
        view.addSubview(addListButton)
    }
    
    override func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        currentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(10)
            $0.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(currentTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(newTodoButton.snp.top).offset(-10)
        }
        
        newTodoButton.snp.makeConstraints {
            $0.leading.bottom.equalTo(safeArea).inset(10)
            $0.height.equalTo(20)
        }
        
        addListButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(safeArea).inset(10)
            $0.height.equalTo(20)
        }
    }
    
    override func configureUI() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.backButtonTitle = ""
        
        let left = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonClicked))
        navigationItem.leftBarButtonItem = left
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        let right = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(filterButtonClicked))
        navigationItem.rightBarButtonItem = right
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        currentTitleLabel.text = "전체"
        currentTitleLabel.textColor = .darkGray
        currentTitleLabel.font = .systemFont(ofSize: 35, weight: .bold)
        
        var config = UIButton.Configuration.plain()
        config.title = "새로운 할 일"
        config.image = UIImage(systemName: "plus.circle.fill")
        config.baseForegroundColor = .label
        config.imagePadding = 10
        newTodoButton.configuration = config
        newTodoButton.addTarget(self, action: #selector(newTodoButtonClicked), for: .touchUpInside)
        
        addListButton.setTitle("목록 추가", for: .normal)
        addListButton.setTitleColor(UIColor.label, for: .normal)
        addListButton.addTarget(self, action: #selector(addListButtonClicked), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.id)
    }
    
    private static func collecionViewLayout() -> UICollectionViewLayout {
        let layout  = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (sectionSpacing * 2) - (cellSpacing * 2) + 10
        layout.itemSize = CGSize(width: width / 2, height: width / 4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    func updateCount() {
        let array = TodoRepository.shared.fetch()
        let todayText = DateFormatter.onlyDateFormatter.string(from: Date())
        
        todayList = array.filter {
            if let deadline = $0.deadline {
                let deadlineText = DateFormatter.onlyDateFormatter.string(from: deadline)
                return deadlineText == todayText
            } else {
                return false
            }
        }
        
        scheduleList = array.filter {
            if let deadline = $0.deadline {
                let deadlineText = DateFormatter.onlyDateFormatter.string(from: deadline)
                return deadlineText > todayText
            } else {
                return false
            }
        }
        
        totalList = TodoRepository.shared.fetch()
        flagList = array.filter { $0.flag }
        completeList = array.filter { $0.isDone }
        
        collectionView.reloadData()
    }
    
    @objc func newTodoButtonClicked() {
        let registrationVC = RegistrationViewController()
        registrationVC.updateListCountDelegate = self
        let registrationNav = UINavigationController(rootViewController: registrationVC)
        present(registrationNav, animated: true)
    }
    
    @objc func addListButtonClicked() {
        print(#function)
    }
    
    
    @objc func filterButtonClicked() {
        print(#function)
    }
    
    @objc func calendarButtonClicked() {
        let vc = CalendarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.buttonImageView.image = UIImage(systemName: ListFilterType.allCases[indexPath.row].imageName)
        cell.buttonImageView.tintColor = ListFilterType.allCases[indexPath.row].color
        cell.buttonTitleLabel.text = ListFilterType.allCases[indexPath.row].rawValue
        
        cell.titleCountLabel.text = 
        switch buttonList[indexPath.item] {
        case .today:
            "\(todayList.count)"
        case .scheduled:
            "\(scheduleList.count)"
        case .entire:
            "\(totalList.count)"
        case .flag:
            "\(flagList.count)"
        case .complete:
            "\(completeList.count)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listVC = ListViewController()
        listVC.delegate = self
        let type = buttonList[indexPath.item]
        listVC.listFilterType = type
        
        navigationController?.pushViewController(listVC, animated: true)
    }
}

extension MainViewController: UpdateListCountDelegate {
    func updateListCount() {
        updateCount()
    }
}
