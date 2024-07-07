//
//  CalendarViewController.swift
//  YegrReminderProject
//
//  Created by YJ on 7/7/24.
//

import UIKit
import FSCalendar
import SnapKit
import RealmSwift

class CalendarViewController: UIViewController {
    fileprivate weak var todoCalendar: FSCalendar!
    private let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
    private let dropDownButton = UIButton()
    private let todotableView = UITableView()
    private let realm = try! Realm()
    
    private var targetDateList: [TodoTable] = []
    private var events: [String] = []
    private var eventsDate: [Date] = []
    
    private var dropDownState = false
    
    enum DropDownState {
        case up
        case down
        
        var buttonImage: String {
            switch self {
            case .up:
                "chevron.down"
            case .down:
                "chevron.up"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObjects()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureObjects() {
        calendar.dataSource = self
        calendar.delegate = self
        
        todotableView.delegate = self
        todotableView.dataSource = self
        todotableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.id)
    }
    
    func configureHierarchy() {
        view.addSubview(calendar)
        view.addSubview(dropDownButton)
        view.addSubview(todotableView)
    }
    
    
    func configureLayout() {
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(350)
        }
        
        dropDownButton.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom)
            $0.centerX.equalTo(calendar.snp.centerX)
            $0.height.equalTo(30)
        }
        
        todotableView.snp.makeConstraints {
            $0.top.equalTo(dropDownButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(calendar.snp.horizontalEdges)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        // view
        view.backgroundColor = .systemBackground
        title = "마감일 일정 조회"
        // calendar
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = .lightGray
        calendar.layer.cornerRadius = 10
        calendar.layer.borderWidth = 3
        calendar.layer.borderColor = UIColor.white.cgColor
        
        self.todoCalendar = calendar
        todoCalendar.scrollDirection = .horizontal
        todoCalendar.scrollEnabled = true
        
        todoCalendar.headerHeight = 60
        todoCalendar.appearance.headerDateFormat = "YYYY년 MM월"
        todoCalendar.appearance.headerTitleAlignment = .center
        todoCalendar.appearance.headerTitleColor = .black
        todoCalendar.appearance.headerMinimumDissolvedAlpha = 0
        
        todoCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        todoCalendar.appearance.weekdayTextColor = UIColor.darkText
        todoCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        todoCalendar.appearance.titleWeekendColor = .systemRed
        todoCalendar.appearance.titleTodayColor = .black
        todoCalendar.appearance.todayColor = UIColor.white
        todoCalendar.scope = .week
        // dropDownButton
        dropDownButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        dropDownButton.tintColor = .label
        dropDownButton.addTarget(self, action: #selector(underDropButtonClicked), for: .touchUpInside)
        // tableView
        todotableView.backgroundColor = .systemBackground
    }
    
    func fetchTargetDateList(date: Date) {
        let targetDateText = DateFormatter.onlyDateFormatter.string(from: date)
        let objects = Array(realm.objects(TodoTable.self))
        targetDateList = objects.filter { todoTable in
            if let deadline = todoTable.deadline {
                let deadlineText = DateFormatter.onlyDateFormatter.string(from: deadline)
                return deadlineText == targetDateText
            }
            
            return false
        }
        
        todotableView.reloadData()
    }
    
    @objc func underDropButtonClicked() {
        dropDownState.toggle()
        
        if dropDownState {
            dropDownButton.setImage(UIImage(systemName: DropDownState.down.buttonImage), for: .normal)
            todoCalendar.scope = .month
        } else {
            dropDownButton.setImage(UIImage(systemName: DropDownState.up.buttonImage), for: .normal)
            todoCalendar.scope = .week
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.systemCyan
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return UIColor.white.withAlphaComponent(1.0)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        fetchTargetDateList(date: date)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetDateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.id, for: indexPath) as? TodoTableViewCell else { return UITableViewCell() }
        let item = targetDateList[indexPath.row]
        cell.titleLabel.text = item.memoTitle
        cell.memoLabel.text = item.content
        cell.selectionStyle = .none
        return cell
    }
}
