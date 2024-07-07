//
//  ListTableViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit

final class ListTableViewCell: BaseTableViewCell {
    let lineView = UIView()
    let priorityView = UIView()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let deadlineLabel = UILabel()
    let tagLabel = UILabel()
    
    var checkButton = UIButton()
    var flagImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        contentView.addSubview(checkButton)
        contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(flagImageView)
        contentView.addSubview(priorityView)
        contentView.addSubview(memoLabel)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(tagLabel)
    }
    
    override func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        checkButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeArea)
            $0.leading.equalTo(safeArea).offset(10)
            $0.width.equalTo(40)
        }
        
        lineView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeArea).inset(5)
            $0.leading.equalTo(checkButton.snp.trailing).offset(3)
            $0.width.equalTo(2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.equalTo(lineView.snp.trailing).offset(10)
            $0.height.equalTo(30)
        }
        
        flagImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.width.height.equalTo(15)
        }
        
        priorityView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.trailing.equalTo(safeArea).offset(-10)
            $0.width.height.equalTo(10)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(lineView.snp.trailing).offset(10)
            $0.trailing.equalTo(priorityView.snp.leading).offset(-10)
            $0.bottom.equalTo(deadlineLabel.snp.top)
        }
        
        deadlineLabel.snp.makeConstraints {
            $0.top.equalTo(memoLabel.snp.bottom)
            $0.bottom.equalTo(safeArea).offset(-10)
            $0.leading.equalTo(lineView.snp.trailing).offset(10)
            $0.height.equalTo(20)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineLabel.snp.top)
            $0.bottom.equalTo(deadlineLabel.snp.bottom)
            $0.leading.equalTo(deadlineLabel.snp.trailing).offset(16)
        }
    }
    
    override func configureUI() {
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkButton.tintColor = .darkGray
        
        lineView.backgroundColor = .systemCyan
        
        titleLabel.setUI(txtColor: .label, fontStyle: .systemFont(ofSize: 17, weight: .black), txtAlignment: .left)
        memoLabel.setUI(txtColor: .lightGray, fontStyle: .systemFont(ofSize: 16, weight: .regular), txtAlignment: .left)
        deadlineLabel.setUI(txtColor: .lightGray, fontStyle: .systemFont(ofSize: 14, weight: .regular), txtAlignment: .right)
        tagLabel.setUI(txtColor: .systemTeal, fontStyle: .systemFont(ofSize: 15, weight: .semibold), txtAlignment: .left)
        
        flagImageView.tintColor = .systemCyan
        priorityView.layer.cornerRadius = 5
        
        memoLabel.numberOfLines = 0
    }
}
