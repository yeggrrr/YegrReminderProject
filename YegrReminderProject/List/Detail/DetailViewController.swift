//
//  DetailViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    let detailView = DetailView()
    let xButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy() {
        view.addSubview(xButton)
        view.addSubview(detailView)
    }
    
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        xButton.snp.makeConstraints {
            $0.trailing.equalTo(detailView)
            $0.bottom.equalTo(detailView.snp.top).offset(-10)
            $0.height.width.equalTo(30)
        }
        
        detailView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea).inset(50)
            $0.verticalEdges.equalTo(safeArea).inset(100)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = .label
        xButton.addTarget(self, action: #selector(xButtonClicked), for: .touchUpInside)
        
        detailView.backgroundColor = .lightGray
        detailView.layer.cornerRadius = 10
        detailView.layer.borderWidth = 3
        detailView.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc func xButtonClicked() {
        dismiss(animated: true)
    }
}