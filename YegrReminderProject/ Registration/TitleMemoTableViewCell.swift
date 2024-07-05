//
//  TitleMemoTableViewCell.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import UIKit
import SnapKit

final class TitleMemoTableViewCell: BaseTableViewCell {
    let titleTextField = UITextField()
    private let dividerView = UIView()
    let memoTextView = UITextView()
    let memoLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(titleTextField)
        contentView.addSubview(dividerView)
        contentView.addSubview(memoTextView)
        contentView.addSubview(memoLabel)
    }
    
    override func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(50)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea).inset(10)
            $0.height.equalTo(1)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea).inset(15)
            $0.bottom.equalTo(safeArea).offset(-5)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.top).offset(10)
            $0.leading.equalTo(memoTextView.snp.leading)
            $0.height.equalTo(17)
        }
    }
    
    override func configureUI() {
        titleTextField.placeholder = "제목"
        dividerView.backgroundColor = .darkGray
        memoTextView.backgroundColor = .clear
        memoTextView.font = .systemFont(ofSize: 16, weight: .regular)
        memoTextView.textColor = .lightGray
        memoTextView.delegate = self
        
        memoLabel.text = "메모"
        memoLabel.setUI(txtColor: .systemGray2, fontStyle: .systemFont(ofSize: 17, weight: .regular), txtAlignment: .left)
    }
}

extension TitleMemoTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        memoLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(#function)
        if textView.text.isEmpty {
            memoLabel.isHidden = false
        } else {
            memoLabel.isHidden = true
        }
    }
}
