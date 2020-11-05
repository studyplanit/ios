//
//  CalendarViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit
import FSCalendar
import Alamofire

class CalendarViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgoroundView: UIView!
    var userPlans: [UserPlan] = []
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
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
        
        configureTapBar()
        configureCalendar()
        configureTableView()
        getUserPlan()
//        configureBackgoroundView()
    }

}

// MARK:- Configure
extension CalendarViewController {
    
//    func configureBackgoroundView() {
//
//        backgroundView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(backgroundView)
//        backgroundView.leadingAnchor.constraint(
//            equalTo: view.leadingAnchor,
//            constant: 0).isActive = true
//        backgroundView.trailingAnchor.constraint(
//            equalTo: view.trailingAnchor,
//            constant: 0).isActive = true
//        backgroundView.heightAnchor.constraint(equalTo: calendar.heightAnchor, multiplier: 0.2).isActive = true
//
//    }
    
    func configureTapBar() {
        navigationItem.title = "캘린더"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "KoPubDotumBold", size: 20)!]
    }
    
    func configureCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.clipsToBounds = true
        calendar.appearance.headerDateFormat = "yyyy.MM"
        calendar.locale = Locale(identifier: "ko")
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.calendarHeaderView.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3098039216, alpha: 1)
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleFont = UIFont(name: "KoPubDotumBold", size: 20)
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.selectionColor = .lightGray
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "CalendarTableViewCell", bundle: nil),
            forCellReuseIdentifier: "calendarTableViewCell")
    }
    
}

// MARK:- Methods
extension CalendarViewController {
    
    private func getUserPlan() {
        let headers: HTTPHeaders = [
            "memberId": "1",
        ]
        // HTTP Request
        AF.request(CalendarAPIConstant.userPlanURL, headers: headers).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                do {
                    // 반환값을 Data 타입으로 변환
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    // Data를 [Contact] 타입으로 디코딩
                    let json = try JSONDecoder().decode([UserPlan].self, from: jsonData)
                    // dataSource에 변환한 값을 대입
                    self.userPlans = json
                    // 메인 큐를 이용하여 tableView 리로딩
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch(let err) {
                    print(err.localizedDescription)
                }
                // 실패
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func checkPlanProgress(status: String) -> String {
        switch status {
        case "SUCCESS":
            return "성공"
        case "FAIL":
            return "실패"
        case "ONGOING":
            return "진행"
        default:
            return "진행"
        }
    }
    
    func deletePlan() {
        let alert = UIAlertController(
            title: "",
            message: "플랜을 삭제하시겠습니까?",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default) { (action : UIAlertAction) in
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
            message: "플랜이 삭제되었습니다.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK:- FS Calendar DataSource
extension CalendarViewController: FSCalendarDataSource {
    
    /// 특정 날짜 점 표시
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

// MARK:- FS Calendar Delegate
extension CalendarViewController: FSCalendarDelegate {
    
    // 날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("날짜 선택")
        print(dateFormatter.string(from: date))
        SelectedDate.shared.date = dateFormatter.string(from: date)
        tableView.reloadData()
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

// MARK:- Table View DataSource
extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "calendarTableViewCell", for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        cell.planTitleLabel.text = userPlans[indexPath.row].planName
        cell.timeLabel.text = userPlans[indexPath.row].setTime
        cell.dayLabel.text = "\(userPlans[indexPath.row].nowAuthNum) 일째"
        let status = checkPlanProgress(status: userPlans[indexPath.row].planProgress)
        cell.successLabel.text = status
        return cell
    }
    
    // 편집모드로 들어가 테이블뷰 행을 삭제 가능하도록 하는 메서드
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // 테이블뷰가 편집모드일때 동작을 정의하는 메서드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("셀 삭제")
            deletePlan()
        }
    }
    
}

// MARK:- Table View Delegate
extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
}
