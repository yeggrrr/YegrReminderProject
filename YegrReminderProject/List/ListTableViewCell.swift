//
//  ListTableViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit

final class ListTableViewCell: UITableViewCell {
    let checkButton = UIButton()
    let contentsStackView = UIStackView()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let deadlineLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(checkButton)
        contentView.addSubview(contentsStackView)
        contentsStackView.addArrangedSubview(titleLabel)
        contentsStackView.addArrangedSubview(memoLabel)
        contentsStackView.addArrangedSubview(deadlineLabel)
    }
    
    private func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalTo(safeArea.snp.centerY)
            $0.leading.equalTo(safeArea).offset(10)
            $0.width.height.equalTo(30)
        }
        
        contentsStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeArea).inset(5)
            $0.leading.equalTo(checkButton.snp.trailing).offset(10)
            $0.trailing.equalTo(safeArea).offset(-10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        
        memoLabel.snp.makeConstraints {
            $0.height.equalTo(35)
        }
    }
    
    private func configureUI() {
        titleLabel.text = "제목"
        memoLabel.text = "메모"
        deadlineLabel.text = "마감일"
        
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkButton.tintColor = .label
        
        titleLabel.setUI(txtColor: .label, fontStyle: .systemFont(ofSize: 17, weight: .semibold), txtAlignment: .left)
        memoLabel.setUI(txtColor: .lightGray, fontStyle: .systemFont(ofSize: 16, weight: .regular), txtAlignment: .left)
        deadlineLabel.setUI(txtColor: .lightGray, fontStyle: .systemFont(ofSize: 14, weight: .regular), txtAlignment: .right)
        
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 1
        contentsStackView.alignment = .fill
        contentsStackView.distribution = .fillProportionally
    }
}
