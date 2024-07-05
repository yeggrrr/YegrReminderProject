//
//  MainCollectionViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

final class MainCollectionViewCell: BaseCollectionViewCell {
    let buttonImageView = UIImageView()
    let buttonTitleLabel = UILabel()
    let titleCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        contentView.addSubview(buttonImageView)
        contentView.addSubview(buttonTitleLabel)
        contentView.addSubview(titleCountLabel)
    }
    
    override func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        buttonImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(5)
            $0.leading.equalTo(safeArea).offset(5)
            $0.height.width.equalTo(50)
        }
        
        buttonTitleLabel.snp.makeConstraints {
            $0.top.equalTo(buttonImageView.snp.bottom).offset(3)
            $0.leading.equalTo(safeArea).offset(10)
            $0.bottom.equalTo(safeArea).offset(-5)
        }
        
        titleCountLabel.snp.makeConstraints {
            $0.top.trailing.equalTo(safeArea).inset(5)
            $0.height.width.equalTo(50)
        }
    }
    
    override func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(named: "CellColor")
        
        buttonImageView.backgroundColor = .white
        buttonImageView.layer.cornerRadius = 25
        
        buttonTitleLabel.textColor = .lightGray
        buttonTitleLabel.textAlignment = .left
        buttonTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        titleCountLabel.text = "0"
        titleCountLabel.textColor = .white
        titleCountLabel.textAlignment = .center
        titleCountLabel.font = .systemFont(ofSize: 35, weight: .bold)
    }
}
