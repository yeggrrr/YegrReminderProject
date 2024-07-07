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
    private let todotableView = UITableView()
    private let realm = try! Realm()
    
    var targetDateList: [TodoTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCalendar()
        configureTableView()
    }
    
    func configureCalendar() {
        view.backgroundColor = .clear
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.todoCalendar = calendar
        
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = .lightGray
        calendar.layer.cornerRadius = 10
        calendar.layer.borderWidth = 3
        calendar.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(calendar)
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(350)
        }
        
        todoCalendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        todoCalendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        todoCalendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        todoCalendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        todoCalendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        todoCalendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        todoCalendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        todoCalendar.scrollEnabled = true
        todoCalendar.scrollDirection = .horizontal
        
        todoCalendar.appearance.headerDateFormat = "YYYY년 MM월"
        todoCalendar.appearance.headerTitleAlignment = .center
        
        todoCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        todoCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        todoCalendar.appearance.weekdayTextColor = UIColor.darkGray
        todoCalendar.appearance.todayColor = UIColor.darkGray
    }
    
    func configureTableView() {
        todotableView.delegate = self
        todotableView.dataSource = self
        todotableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.id)
        
        view.addSubview(todotableView)
        todotableView.snp.makeConstraints {
            $0.top.equalTo(todoCalendar.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(todoCalendar.snp.horizontalEdges)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        todotableView.backgroundColor = .systemBackground
    }
    
    func fetchTargetDateList(date: Date) {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        df.locale = Locale(identifier: "ko_KR")
        
        let targetDateText = df.string(from: date)
        let objects = Array(realm.objects(TodoTable.self))
        targetDateList = objects.filter { todoTable in
            if let deadline = todoTable.deadline {
                let deadlineText = df.string(from: deadline)
                return deadlineText == targetDateText
            }
            
            return false
        }
        
        todotableView.reloadData()
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
        return UIColor.systemPink
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
