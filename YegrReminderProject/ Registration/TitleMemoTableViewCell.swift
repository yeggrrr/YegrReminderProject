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
    
    private let placeholder = "메모"
    
    
    override func configureHierarchy() {
        contentView.addSubview(titleTextField)
        contentView.addSubview(dividerView)
        contentView.addSubview(memoTextView)
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
    }
    
    override func configureUI() {
        titleTextField.placeholder = "제목"
        dividerView.backgroundColor = .darkGray
        memoTextView.backgroundColor = .clear
        memoTextView.text = placeholder
        memoTextView.font = .systemFont(ofSize: 16, weight: .regular)
        memoTextView.textColor = .lightGray
        memoTextView.delegate = self
    }
}

extension TitleMemoTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == memoTextView {
            guard let text = textView.text else { return }
            if text == placeholder {
                textView.text = nil
                textView.textColor = .label
                textView.font = .systemFont(ofSize: 16, weight: .regular)
            }
        }
    }
}
