//
//  CalendarViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCalendar()
    }

}

// MARK:- Configure
extension CalendarViewController {
    
    func configureCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        
        // 여러날짜를 동시에 선택할 수 있도록
//        calendar.allowsMultipleSelection = true
        
        // 스와이프
        calendar.swipeToChooseGesture.isEnabled = true
        
        // 달력 구분 선 제거
        calendar.clipsToBounds = true
        
        // 헤더 포맷 커스터마이징
        calendar.appearance.headerDateFormat = "yyyy.MM"
        
        // 한글
        calendar.locale = Locale(identifier: "ko")
        
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.selectionColor = .lightGray
    }
    
}

// MARK:- Methods
extension CalendarViewController {
    
}

// MARK:- FS Calendar DataSource
extension CalendarViewController: FSCalendarDataSource {
    
    // 특정 날짜 점 표시
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let eventDate = dateFormatter.date(from: "2020-10-29") else { return 0 }
        
        if date.compare(eventDate) == .orderedSame {
            return 2
        }
        
        return 0
    }
    
}

// MARK:- FS Calendar Delegate
extension CalendarViewController: FSCalendarDelegate {
    
    // 날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("날짜 선택")
        print(dateFormatter.string(from: date))
    }
    
    // 날짜 선택 해제
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("날짜 선택 해제")
        print(dateFormatter.string(from: date))
    }
    
    // 스와이프
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("페이지 넘김")
    }
    
    // 특정 날짜를 선택되지 않게 하기
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard let excludeDate = dateFormatter.date(from: "2020-11-25") else { return true }
        
        if date.compare(excludeDate) == .orderedSame {
            return false
        } else {
            return true
        }
    }
    
}

// MARK:- FS Calendar Delegate Appearance
extension CalendarViewController: FSCalendarDelegateAppearance {
    
    // 특정 날짜 색 바꾸기
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        guard let eventDate = dateFormatter.date(from: "2020-11-25") else { return nil }
        
        if date.compare(eventDate) == .orderedSame {
            return .red
        } else {
            return nil
        }
    }
    
}
