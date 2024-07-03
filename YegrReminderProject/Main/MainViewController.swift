//
//  MainViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit
import RealmSwift

class MainViewController: UIViewController {
    let currentTitleLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collecionViewLayout())
    let newTodoButton = UIButton()
    let addListButton = UIButton()
    
    let realm = try! Realm()
    
    var totalCount: Int = 0
    
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
                    .systemYellow
            case .complete:
                    .systemCyan
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        updateTotalCount()
    }
    
    private func configureHierarchy() {
        view.addSubview(currentTitleLabel)
        view.addSubview(collectionView)
        view.addSubview(newTodoButton)
        view.addSubview(addListButton)
    }
    
    private func configureLayout() {
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
    
    private func configureUI() {
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
    
    func configureCollectionView() {
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
    
    func updateTotalCount() {
        totalCount = realm.objects(TodoTable.self).count
        collectionView.reloadData()
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
        cell.titleCountLabel.text = "\(totalCount)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listVC = ListViewController()
        navigationController?.pushViewController(listVC, animated: true)
        
    }
}

extension MainViewController: AddNewTodoDelegate {
    func updateTodoCounts() {
        updateTotalCount()
    }
}
