//
//  PriorityViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/3/24.
//

import UIKit
import SnapKit

class PriorityViewController: UIViewController {
    let prioritysegmentedControl: UISegmentedControl = {
      let control = UISegmentedControl(items: ["높음", "보통", "낮음"])
      return control
    }()
    
    var selectedPriority: Int?
    weak var delegate: UpdatePriorityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        getSelectedPriority()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updatePriorityAfterDismiss(priority: prioritysegmentedControl.selectedSegmentIndex)
    }
    
    func configureHierarchy() {
        view.addSubview(prioritysegmentedControl)
    }
    
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        prioritysegmentedControl.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "우선순위 설정"
    }
    
    func getSelectedPriority() {
        if let selectedPriority = selectedPriority {
            prioritysegmentedControl.selectedSegmentIndex = selectedPriority
        }
    }
}

protocol UpdatePriorityDelegate: AnyObject {
    func updatePriorityAfterDismiss(priority: Int)
}
