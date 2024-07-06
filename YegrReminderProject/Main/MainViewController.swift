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
    
    private let realm = try! Realm()
    private var list: Results<TodoTable>!
    
    private var totalCount: Int = 0
    
    var todayList: [TodoTable] = []
    var scheduleList: [TodoTable] = []
    var totalList: [TodoTable] = []
    var flagList: [TodoTable] = []
    var completeList: [TodoTable] = []
    
    enum ButtonType: String, CaseIterable {
        case today = "오늘"
        case scheduled = "예정"
        case entire = "전체"
        case flag = "깃발 표시"
        case complete = "완료됨"
        
        var image: String {
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
        updateTotalCount()
        // print(realm.configuration.fileURL)
        updateCount()
        print(">>> todayList.count \(todayList.count)")
        print(">>> scheduleList.count \(scheduleList.count)")
        print(">>> totalList.count \(totalList.count)")
        print(">>> flagList.count \(flagList.count)")
        print(">>> completeList.count \(completeList.count)")
        
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
        
        let right = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(filterButtonClicked))
        navigationItem.rightBarButtonItem = right
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        currentTitleLabel.text = "전체"
        currentTitleLabel.textColor = .darkGray
        currentTitleLabel.font = .systemFont(ofSize: 35, weight: .bold)
        
        var config = UIButton.Configuration.plain()
        config.title = "새로운 할 일"
        config.image = UIImage(systemName: "plus.circle.fill")
        config.imagePadding = 10
        newTodoButton.configuration = config
        newTodoButton.addTarget(self, action: #selector(newTodoButtonClicked), for: .touchUpInside)
        
        addListButton.setTitle("목록 추가", for: .normal)
        addListButton.setTitleColor(UIColor.systemBlue, for: .normal)
        addListButton.setTitleColor(UIColor.darkGray, for: .highlighted)
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
    
    private func updateTotalCount() {
        totalCount = realm.objects(TodoTable.self).count
        collectionView.reloadData()
    }
    
    func updateCount() {
        let array = Array(self.realm.objects(TodoTable.self))
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
        
        totalList = Array(self.realm.objects(TodoTable.self))
        
        flagList = array.filter {
            $0.flag == true
        }
        
        completeList = array.filter {
            $0.isDone == true
        }
    }
    
    @objc func newTodoButtonClicked() {
        let registrationVC = RegistrationViewController()
        registrationVC.delegate = self
        let registrationNav = UINavigationController(rootViewController: registrationVC)
        present(registrationNav, animated: true)
    }
    
    @objc func addListButtonClicked() {
        print(#function)
    }
    
    
    @objc func filterButtonClicked() {
        print(#function)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.buttonImageView.image = UIImage(systemName: ButtonType.allCases[indexPath.row].image)
        cell.buttonImageView.tintColor = ButtonType.allCases[indexPath.row].color
        cell.buttonTitleLabel.text = ButtonType.allCases[indexPath.row].rawValue
        
        switch indexPath.row {
        case 0:
            cell.titleCountLabel.text = "\(todayList.count)"
        case 1:
            cell.titleCountLabel.text = "\(scheduleList.count)"
        case 2:
            cell.titleCountLabel.text = "\(totalList.count)"
        case 3:
            cell.titleCountLabel.text = "\(flagList.count)"
        case 4:
            cell.titleCountLabel.text = "\(completeList.count)"
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listVC = ListViewController()
        
        switch indexPath.row {
        case 0:
            listVC.filterList = todayList
        case 1:
            listVC.filterList = scheduleList
        case 2:
            listVC.filterList = totalList
        case 3:
            listVC.filterList = flagList
        case 4:
            listVC.filterList = completeList
        default:
            break
        }
        
        navigationController?.pushViewController(listVC, animated: true)
       
    }
}

extension MainViewController: AddNewTodoDelegate {
    func updateTodoCounts() {
        updateTotalCount()
    }
}
