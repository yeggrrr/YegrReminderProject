//
//  DetailView.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

final class DetailView: UIView {
    private let todoLabel = UILabel()
    
    private let titleView = UIView()
    let titleLabel = UILabel()
    
    private let memoView = UIView()
    private let memoNameLabel = UILabel()
    let memoLabel = UILabel()
    
    private let deadlineNameLabel = UILabel()
    let deadlineLabel = UILabel()
    
    private let tagNameLabel = UILabel()
    let tagLabel = UILabel()
    
    private let priorityNameLabel = UILabel()
    let priorityLabel = UILabel()
    
    let selectedImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(todoLabel)
        
        addSubview(titleView)
        titleView.addSubview(titleLabel)
        
        addSubview(memoNameLabel)
        addSubview(memoView)
        memoView.addSubview(memoLabel)
        
        addSubview(deadlineNameLabel)
        addSubview(deadlineLabel)
        
        addSubview(tagNameLabel)
        addSubview(tagLabel)
        
        addSubview(priorityNameLabel)
        addSubview(priorityLabel)
        
        addSubview(selectedImage)
    }
    
    private func configureLayout() {
        let safeArea = safeAreaLayoutGuide
        todoLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(30)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(todoLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(10)
            $0.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(titleView.snp.edges).inset(5)
        }
        
        memoNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea).offset(15)
            $0.height.equalTo(20)
        }
        
        memoView.snp.makeConstraints {
            $0.top.equalTo(memoNameLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea).inset(10)
            $0.height.equalTo(120)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(memoView.snp.top).offset(10)
            $0.horizontalEdges.equalTo(memoView.snp.horizontalEdges).inset(10)
            $0.bottom.lessThanOrEqualTo(memoView.snp.bottom).offset(-10)
        }
        
        deadlineNameLabel.snp.makeConstraints {
            $0.top.equalTo(memoView.snp.bottom).offset(10)
            $0.leading.equalTo(safeArea).offset(20)
            $0.height.equalTo(20)
            $0.width.equalTo(50)
        }
        
        deadlineLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineNameLabel.snp.top)
            $0.leading.equalTo(deadlineNameLabel.snp.trailing).offset(5)
            $0.trailing.lessThanOrEqualTo(memoLabel.snp.trailing)
            $0.height.equalTo(20)
        }
        
        tagNameLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineNameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(safeArea).offset(20)
            $0.height.equalTo(20)
            $0.width.equalTo(35)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(tagNameLabel.snp.top)
            $0.leading.equalTo(tagNameLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(safeArea).offset(-10)
            $0.height.equalTo(20)
        }
        
        priorityNameLabel.snp.makeConstraints {
            $0.top.equalTo(tagNameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(safeArea).offset(20)
            $0.height.equalTo(20)
            $0.width.equalTo(65)
        }
        
        priorityLabel.snp.makeConstraints {
            $0.top.equalTo(priorityNameLabel.snp.top)
            $0.leading.equalTo(priorityNameLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(safeArea).offset(-10)
            $0.height.equalTo(20)
        }
        
        selectedImage.snp.makeConstraints {
            $0.top.equalTo(priorityNameLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(safeArea)
            $0.bottom.equalTo(safeArea).offset(-30)
            $0.width.equalTo(selectedImage.snp.height)
        }
    }
    
    private func configureUI() {
        todoLabel.detailUI(txt: "TODO", txtColor: .white, txtAlignment: .center, fontStyle: .systemFont(ofSize: 25, weight: .black))
        
        titleView.layer.cornerRadius = 10
        titleView.layer.borderWidth = 3
        titleView.layer.borderColor = UIColor.white.cgColor
        
        titleLabel.setUI(txtColor: .darkGray, fontStyle: .systemFont(ofSize: 17, weight: .semibold), txtAlignment: .center)
        
        memoNameLabel.detailUI(txt: "메모", txtColor: .black, txtAlignment: .left, fontStyle: .systemFont(ofSize: 17, weight: .heavy))
        memoView.layer.cornerRadius = 10
        memoView.layer.borderWidth = 3
        memoView.layer.borderColor = UIColor.white.cgColor
        
        memoLabel.numberOfLines = 0
        memoLabel.setUI(txtColor: .darkGray, fontStyle: .systemFont(ofSize: 17, weight: .regular), txtAlignment: .left)
        
        deadlineNameLabel.detailUI(txt: "마감일:", txtColor: .black, txtAlignment: .left, fontStyle: .systemFont(ofSize: 17, weight: .semibold))
        deadlineLabel.setUI(txtColor: .darkGray, fontStyle: .systemFont(ofSize: 17, weight: .regular), txtAlignment: .left)
        
        tagNameLabel.detailUI(txt: "태그:", txtColor: .black, txtAlignment: .left, fontStyle: .systemFont(ofSize: 17, weight: .semibold))
        tagLabel.setUI(txtColor: .darkGray, fontStyle: .systemFont(ofSize: 17, weight: .regular), txtAlignment: .left)
        
        priorityNameLabel.detailUI(txt: "우선순위:", txtColor: .black, txtAlignment: .left, fontStyle: .systemFont(ofSize: 17, weight: .semibold))
        priorityLabel.setUI(txtColor: .darkGray, fontStyle: .systemFont(ofSize: 17, weight: .regular), txtAlignment: .left)
        
        selectedImage.backgroundColor = .white
    }
}
