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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
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
        
        prioritysegmentedControl.addTarget(self, action: #selector(segmentValueSelected(_:)), for: .valueChanged)
        prioritysegmentedControl.selectedSegmentIndex = 1
    }
    
    @objc func segmentValueSelected(_ sender: UISegmentedControl) {
        print(#function, sender.selectedSegmentIndex)
    }
}
