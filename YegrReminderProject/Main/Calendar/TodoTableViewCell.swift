//
//  TodoTableViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/7/24.
//

import UIKit
import SnapKit

class TodoTableViewCell: BaseTableViewCell {
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let lineView = UIView()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(lineView)
    }
    
    override func configureUI() {
        let safeArea = contentView.safeAreaLayoutGuide
        lineView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeArea).inset(5)
            $0.leading.equalTo(safeArea).offset(2)
            $0.width.equalTo(2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.equalTo(lineView.snp.trailing).offset(10)
            $0.trailing.equalTo(safeArea).offset(-10)
            $0.height.equalTo(20)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(lineView.snp.trailing).offset(10)
            $0.trailing.equalTo(safeArea).offset(-10)
            $0.bottom.greaterThanOrEqualTo(safeArea)
        }
    }
    
    override func configureLayout() {
        titleLabel.text = "제목제목"
        memoLabel.text = "메모다냐오옹메모다냐오옹메모다냐오옹메모다냐오옹메모다냐오옹메모다냐오옹"
        
        lineView.backgroundColor = .lightGray
        titleLabel.setUI(txtColor: .label, fontStyle: .systemFont(ofSize: 17, weight: .semibold), txtAlignment: .left)
        memoLabel.setUI(txtColor: .lightGray, fontStyle: .systemFont(ofSize: 15, weight: .regular), txtAlignment: .left)
        memoLabel.numberOfLines = 2
    }
}
