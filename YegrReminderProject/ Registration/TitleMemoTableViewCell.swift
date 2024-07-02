//
//  TitleMemoTableViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit

class TitleMemoTableViewCell: UITableViewCell {
    let titleTextField = UITextField()
    let dividerView = UIView()
    let memoTextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(titleTextField)
        contentView.addSubview(dividerView)
        contentView.addSubview(memoTextView)
    }
    
    func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalTo(safeArea).inset(10)
            $0.height.equalTo(50)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(1)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea).inset(10)
            $0.bottom.equalTo(safeArea).offset(-5)
            
        }
    }
    
    func configureUI() {
        titleTextField.placeholder = "제목"
        dividerView.backgroundColor = .darkGray

    }
}
