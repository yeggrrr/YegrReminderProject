//
//  MainCollectionViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

class MainCollectionViewCell: UICollectionViewCell {
    let buttonImageView = UIImageView()
    let buttonTitleLabel = UILabel()
    let titleCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(buttonImageView)
        contentView.addSubview(buttonTitleLabel)
        contentView.addSubview(titleCountLabel)
    }
    
    func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        buttonImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(5)
            $0.leading.equalTo(safeArea).offset(5)
            $0.height.width.equalTo(50)
        }
        
        buttonTitleLabel.snp.makeConstraints {
            $0.top.equalTo(buttonImageView.snp.bottom)
            $0.leading.equalTo(safeArea).offset(5)
            $0.bottom.equalTo(safeArea).offset(-5)
        }
        
        titleCountLabel.snp.makeConstraints {
            $0.top.trailing.equalTo(safeArea).inset(5)
            $0.height.width.equalTo(50)
        }
        
    }
    
    func configureUI() {
        buttonImageView.backgroundColor = .systemGray5
        buttonImageView.image = UIImage(systemName: "calendar.circle.fill")
        
        buttonTitleLabel.text = "아아우우"
        buttonTitleLabel.textColor = .lightGray
        buttonTitleLabel.textAlignment = .left
        buttonTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        titleCountLabel.text = "0"
        titleCountLabel.textColor = .label
        titleCountLabel.textAlignment = .center
        titleCountLabel.font = .systemFont(ofSize: 35, weight: .bold)
    }
}
