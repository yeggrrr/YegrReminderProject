//
//  TagViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

final class TagViewController: BaseViewController {
    private let tagViewModel = TagViewModel()
    
    private let tagTextField = UITextField()
    private let tagLabel = UILabel()
    
    var inputTag: String?
    weak var delegate: UpdateTagDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInputTag()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tagText = tagTextField.text else { return }
        delegate?.updateTagAfterDismiss(tag: tagText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let currentTag = inputTag else { return }
        tagLabel.text = "# \(currentTag)"
    }
    
    override func configureHierarchy() {
        view.addSubview(tagTextField)
        view.addSubview(tagLabel)
    }
    
    override func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(44)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom).offset(20)
            $0.centerX.equalTo(tagTextField.snp.centerX)
        }
    }
    
    override func configureUI() {
        view.backgroundColor = .systemBackground
        tagTextField.setCustomUI("태그 항목을 입력해주세요", keyboardStyle: .default)
        tagTextField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        
        tagLabel.setUI(txtColor: .systemCyan, fontStyle: .systemFont(ofSize: 15, weight: .semibold), txtAlignment: .center)
    }
    
    func bindData() {
        tagViewModel.outputTagText.bind { value in
            self.tagLabel.text = value
        }
    }
    
    private func getInputTag() {
        if let inputTag = inputTag {
            tagTextField.text = inputTag
        }
    }
    
    @objc func textFieldValueChanged() {
        tagViewModel.inputTagText.value = tagTextField.text
        bindData()
    }
}

protocol UpdateTagDelegate: AnyObject {
    func updateTagAfterDismiss(tag: String)
}
