//
//  MainViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    let currentTitleLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollecionViewLayout())
    let newTodoButton = UIButton()
    let addListButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
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
    
    private static func CollecionViewLayout() -> UICollectionViewLayout {
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
    
    @objc func newTodoButtonClicked() {
        print(#function)
        
         let registrationVC = RegistrationViewController()
        // registrationVC.delegate = self
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
        cell.backgroundColor = .darkGray
        cell.layer.cornerRadius = 10
        return cell
    }
}
