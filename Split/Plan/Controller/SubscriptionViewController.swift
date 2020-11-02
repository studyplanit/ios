//
//  SubscriptionViewController.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import UIKit
import FSCalendar

class SubscriptionViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var planTitleView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    var plan: PlanModel.Plan?
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var arrayOfEvent1 : [String] = [
        "2020-11-14",
        "2020-11-15",
        "2020-11-16",
        "2020-11-17",
        "2020-11-18",
        "2020-11-19",
        "2020-11-20"
    ]
    var arrayOfEvent2 : [String] = ["2020-11-14", "2020-11-16", "2020-11-17"]

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        configureCalendar()
    }

}

// MARK:- Configure
extension SubscriptionViewController {
    
    func configureUI() {
        planTitleLabel.text = plan?.plnaTitle
        planTitleLabel.textColor = .white
        planTitleView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.6431372549, blue: 0.1647058824, alpha: 1)
        planTitleView.layer.cornerRadius = 25
    }
    
    func configureCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.appearance.headerDateFormat = "yyyy.MM"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.locale = Locale(identifier: "ko")
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.todayColor = .lightGray
        calendar.appearance.selectionColor = #colorLiteral(red: 0.8666666667, green: 0.6431372549, blue: 0.1647058824, alpha: 1)
        
    }
    
    func configureNavigationBar() {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(touchUpCompleteButton))
        navigationItem.rightBarButtonItem = button
        navigationItem.title = "플랜"
    }
    
}

// MARK:- Methods
extension SubscriptionViewController {
    
    @objc func touchUpCompleteButton() {
        let alert = UIAlertController(
            title: "",
            message: "해당 시간과 날짜로 플랜을 신청하시겠습니까?",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default){ (action : UIAlertAction) in
            self.completeAlert()
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func completeAlert() {
        let alert = UIAlertController(
            title: "",
            message: "플랜 신청이 완료되었습니다.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default){ (action : UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK:- FSCalendar DataSource
extension SubscriptionViewController: FSCalendarDataSource {
    
    // 특정 날짜 점 표시
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        guard let eventDate = dateFormatter.date(from: "2020-10-29") else { return 0 }
        let strDate = dateFormatter.string(from:date)
        if arrayOfEvent1.contains(strDate) && arrayOfEvent2.contains(strDate) {
             return 2
        } else if arrayOfEvent1.contains(strDate) {
             return 1
        } else if arrayOfEvent2.contains(strDate) {
             return 1
         }
        return 0
    }
    
}

// MARK:- FSCalendar Delegate
extension SubscriptionViewController: FSCalendarDelegate {
    
    // 특정 날짜 선택시 이벤트
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count > 1 {
            for _ in 0 ..< calendar.selectedDates.count - 1 {
                calendar.deselect(calendar.selectedDates[0])
            }
        }
        var startTemp: Date!
        startTemp = calendar.selectedDates[0]
        let endTemp = startTemp + (((plan?.planPeriod)!-1) * 86400)
        while startTemp < endTemp {
            startTemp += 86400
            calendar.select(startTemp)
        }
        print("날짜 선택 \(dateFormatter.string(from: date))")
    }
    
    // 특정 날짜 선택 해제시 이벤트
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("날짜 선택 해제 \(dateFormatter.string(from: date))")
        for _ in 0 ..< calendar.selectedDates.count {
            calendar.deselect(calendar.selectedDates[0])
        }
    }
    
}

// MARK:- FSCalendar Delegate Appearance
extension SubscriptionViewController: FSCalendarDelegateAppearance {
    
    // 특정 날짜 색 바꾸기
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        guard let eventDate = dateFormatter.date(from: "2020-10-29") else { return nil }
        
        if date.compare(eventDate) == .orderedSame {
            return .red
        } else {
            return nil
        }
    }
    
    // 점 기본 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        let strDate = dateFormatter.string(from: date)

        if arrayOfEvent1.contains(strDate) && arrayOfEvent2.contains(strDate) {
            return [UIColor.red ,UIColor.blue]
        } else if arrayOfEvent1.contains(strDate) {
            return [UIColor.red]
        } else if arrayOfEvent2.contains(strDate) {
            return [UIColor.blue]
        }
        return [UIColor.clear]
    }
    
    // 점 선택 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let strDate = dateFormatter.string(from: date)

        if arrayOfEvent1.contains(strDate) && arrayOfEvent2.contains(strDate) {
            return [UIColor.red ,UIColor.blue]
        } else if arrayOfEvent1.contains(strDate) {
            return [UIColor.red]
        } else if arrayOfEvent2.contains(strDate) {
            return [UIColor.blue]
        }
        return [UIColor.clear]
    }
    
}
