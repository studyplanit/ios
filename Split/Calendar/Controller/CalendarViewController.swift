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
    
    let userID = UserDefaults.standard.string(forKey: "id")
    var userPlans: [UserPlan] = []
    var PlanDates: [[String]] = [[],[],[]]
    let aDay = 86400
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
//        configureBackgoroundView()
        print("유저아이디 : \(userID!)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUserPlan()
    }

}

// MARK:- Configure
extension CalendarViewController {
    
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
        calendar.appearance.todayColor = .lightGray
        calendar.appearance.selectionColor = #colorLiteral(red: 0.8666666667, green: 0.6431372549, blue: 0.1647058824, alpha: 1)
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
            "memberId": "2",
        ]
        AF.request(CalendarAPIConstant.userPlanURL, headers: headers).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode([UserPlan].self, from: jsonData)
                    
                    self.userPlans = json
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.setUserPlanDates(userPlans: self.userPlans)
                        self.calendar.reloadData()
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
    
    func checkPlanColor(type: Int) -> String {
        switch type {
        case 1:
            return "Color_1day"
        case 7:
            return "Color_7days"
        case 15:
            return "Color_15days"
        case 30:
            return "Color_30days"
        default:
            return "Color_1days"
        }
    }
    
    func checkSuccessColor(status: String) -> UIColor {
        switch status {
        case "ONGOING":
            return UIColor.lightGray
        case "SUCCESS":
            return UIColor.systemBlue
        case "FAIL":
            return UIColor.red
        default:
            return UIColor.lightGray
        }
    }
    
    // 플랜 날짜 리스트 만들기
    func setUserPlanDates(userPlans: [UserPlan]) {
        print("setUserPlanDates() called")
//        guard let userPlans = userPlans else { return }
        for i in 0 ..< userPlans.count {
            let startDateString = userPlans[i].startDate
            guard let startDate = dateFormatter.date(from: startDateString) else { return }
            var date = startDate
            for _ in 0..<userPlans[i].needAuthNum {
                PlanDates[i].append(dateFormatter.string(from: date))
                date = date + 86400
            }
        }
//        print("PlanDates: \(PlanDates)")
    }
    
}

// MARK:- FS Calendar DataSource
extension CalendarViewController: FSCalendarDataSource {
    
    /// 특정 날짜 점 표시
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        guard let eventDate = dateFormatter.date(from: "2020-10-29") else { return 0 }
        let strDate = dateFormatter.string(from:date)
        let dates1 = PlanDates[0]
        let dates2 = PlanDates[1]
        let dates3 = PlanDates[2]
        
        if dates1.contains(strDate) && dates2.contains(strDate) && dates3.contains(strDate) {
            return 3
        } else if dates1.contains(strDate) && dates2.contains(strDate)  {
            return 2
        } else if dates2.contains(strDate) && dates3.contains(strDate) {
            return 2
        } else if dates1.contains(strDate) && dates3.contains(strDate) {
            return 2
        } else if dates1.contains(strDate) {
            return 1
        } else if dates2.contains(strDate) {
            return 1
        } else if dates3.contains(strDate) {
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
        let dates1 = PlanDates[0]
        let dates2 = PlanDates[1]
        let dates3 = PlanDates[2]
        
        if dates1.contains(strDate) && dates2.contains(strDate) && dates3.contains(strDate) {
            return [UIColor.red ,UIColor.blue, UIColor.green]
        } else if dates1.contains(strDate) && dates2.contains(strDate)  {
            return [UIColor.red ,UIColor.blue]
        } else if dates2.contains(strDate) && dates3.contains(strDate) {
            return [UIColor.red ,UIColor.blue]
        } else if dates1.contains(strDate) && dates3.contains(strDate) {
            return [UIColor.red ,UIColor.blue]
        } else if dates1.contains(strDate) {
            return [UIColor.blue]
        } else if dates2.contains(strDate) {
            return [UIColor.blue]
        } else if dates3.contains(strDate) {
            return [UIColor.blue]
        }
        return [UIColor.clear]
    }
    
    // 점 선택 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let strDate = dateFormatter.string(from: date)
        let dates1 = PlanDates[0]
        let dates2 = PlanDates[1]
        let dates3 = PlanDates[2]

        if dates1.contains(strDate) && dates2.contains(strDate) && dates3.contains(strDate) {
            return [UIColor.red ,UIColor.blue, UIColor.green]
        } else if dates1.contains(strDate) && dates2.contains(strDate)  {
            return [UIColor.red ,UIColor.blue]
        } else if dates2.contains(strDate) && dates3.contains(strDate) {
            return [UIColor.red ,UIColor.blue]
        } else if dates1.contains(strDate) && dates3.contains(strDate) {
            return [UIColor.red ,UIColor.blue]
        } else if dates1.contains(strDate) {
            return [UIColor.blue]
        } else if dates2.contains(strDate) {
            return [UIColor.blue]
        } else if dates3.contains(strDate) {
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
        // 플랜이름
        cell.planTitleLabel.text = userPlans[indexPath.row].planName
        // 플랜시간
        let timeString = userPlans[indexPath.row].setTime
        let endIdx: String.Index = timeString.index(timeString.startIndex, offsetBy: 4)
        cell.timeLabel.text = String(timeString[...endIdx])
        // 플랜 인증 횟수
        cell.dayLabel.text = "\(userPlans[indexPath.row].nowAuthNum) 일째"
        // 플랜 성공 여부
        let status = checkPlanProgress(status: userPlans[indexPath.row].planProgress)
        cell.successLabel.text = status
        // 플랜 성공 여부 뷰 색상
        let statusColor = checkSuccessColor(status: userPlans[indexPath.row].planProgress)
        cell.successLabelView.backgroundColor = statusColor
        // 플랜 뷰 색상
        let planColor = checkPlanColor(type: userPlans[indexPath.row].needAuthNum)
        cell.planColorBarView.backgroundColor = UIColor(named: planColor)
        cell.dayLabelView.backgroundColor = UIColor(named: planColor)
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
