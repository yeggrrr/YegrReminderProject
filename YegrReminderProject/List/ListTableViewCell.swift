//
//  ListTableViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit

final class ListTableViewCell: BaseTableViewCell {
    private let contentsStackView = UIStackView()
    private let topStackView = UIStackView()
    let priorityView = UIView()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let deadlineLabel = UILabel()
    let tagLabel = UILabel()
    
    var checkButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        contentView.addSubview(priorityView)
        contentView.addSubview(checkButton)
        contentView.addSubview(contentsStackView)
        contentsStackView.addArrangedSubview(topStackView)
        contentsStackView.addArrangedSubview(memoLabel)
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(priorityView)
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
        
        contentsStackView.snp.makeConstraints {
            $0.top.equalTo(safeArea).inset(5)
            $0.leading.equalTo(checkButton.snp.trailing).offset(10)
            $0.trailing.equalTo(safeArea).offset(-10)
            $0.bottom.equalTo(deadlineLabel.snp.top)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(35)
        }
        
        priorityView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        
        deadlineLabel.snp.makeConstraints {
            $0.top.equalTo(contentsStackView.snp.bottom)
            $0.bottom.equalTo(safeArea)
            $0.leading.equalTo(checkButton.snp.trailing).offset(10)
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
        checkButton.tintColor = .label
        
        titleLabel.setUI(txtColor: .label, fontStyle: .systemFont(ofSize: 17, weight: .semibold), txtAlignment: .left)
        memoLabel.setUI(txtColor: .lightGray, fontStyle: .systemFont(ofSize: 16, weight: .regular), txtAlignment: .left)
        deadlineLabel.setUI(txtColor: .lightGray, fontStyle: .systemFont(ofSize: 14, weight: .regular), txtAlignment: .right)
        
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 1
        contentsStackView.alignment = .fill
        contentsStackView.distribution = .fillProportionally
        
        topStackView.axis = .horizontal
        topStackView.spacing = 16
        
        priorityView.layer.cornerRadius = 10
        
        memoLabel.numberOfLines = 0
    }
}
