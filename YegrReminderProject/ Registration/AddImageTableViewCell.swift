//
//  AddImageTableViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/5/24.
//

import UIKit
import SnapKit

class AddImageTableViewCell: BaseTableViewCell {
    let titleLabel = UILabel()
    let selectedImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectedImageView)
    }
    
    override func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(20)
            $0.centerY.equalTo(safeArea.snp.centerY)
        }
        
        selectedImageView.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).offset(-20)
            $0.verticalEdges.equalTo(safeArea).inset(10)
            $0.width.equalTo(selectedImageView.snp.height)
        }
    }
    
    override func configureUI() {
        titleLabel.text = "이미지 추가"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        selectedImageView.backgroundColor = .white
    }
}
