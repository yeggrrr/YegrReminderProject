//
//  TagViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

class TagViewController: UIViewController {
    let tagTextField = UITextField()
    
    var inputTag: String?
    weak var delegate: UpdateTagDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        getInputTag()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tagText = tagTextField.text else { return }
        delegate?.updateTagAfterDismiss(tag: tagText)
    }
    
    func configureHierarchy() {
        view.addSubview(tagTextField)
    }
    
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(44)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        tagTextField.setCustomUI("태그 항목을 입력해주세요", keyboardStyle: .default)
    }
    
    func getInputTag() {
        if let inputTag = inputTag {
            tagTextField.text = inputTag
        }
    }
}

protocol UpdateTagDelegate: AnyObject {
    func updateTagAfterDismiss(tag: String)
}
