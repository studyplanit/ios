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
    private let noPlanLabel = UILabel()
    private let indicatorView = UIActivityIndicatorView()
    let userID = UserDefaults.standard.string(forKey: "id")
    var userPlans: [UserTotalPlan] = []
    var userDailyPlan: [UserTotalPlan] = []
    var planDates: [[String]] = []
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureCalendar()
        configureTableView()
        configureNoPlanLabel()
        print("유저아이디 : \(userID!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserPlan()
        setSelectDate()
        noPlanLabel.isHidden = true
        print("viewWillApear - 유저플랜 갯수 : \(userPlans.count)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

}

// MARK:- Configure UI
extension CalendarViewController {
    
    func configureNavigationBar() {
        navigationItem.title = "CALENDAR"
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
        calendar.appearance.todayColor = #colorLiteral(red: 0.337254902, green: 0.2235294118, blue: 0.6392156863, alpha: 1).withAlphaComponent(0.8)
        calendar.appearance.selectionColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3098039216, alpha: 1).withAlphaComponent(0.7)
//        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red // 일요일
//        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .red // 토요일
        calendar.select(Date())
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "CalendarTableViewCell", bundle: nil),
            forCellReuseIdentifier: "calendarTableViewCell")
    }
    
    func showIndicator() {
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicatorView.startAnimating()
    }
    
    func configureNoPlanLabel() {
        print("showNoPlanLabel() called")
        noPlanLabel.text = "이벤트 없음"
        noPlanLabel.textAlignment = .center
        noPlanLabel.font = UIFont(name: "KoPubDotumMedium", size: 17)
        noPlanLabel.textColor = .lightGray
        noPlanLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(noPlanLabel)
        noPlanLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        noPlanLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 30).isActive = true
        noPlanLabel.isHidden = true
    }
    
}

// MARK:- API
extension CalendarViewController {
    
    private func getUserPlan() {
        showIndicator()
        guard let userID = userID else { return }
        let headers: HTTPHeaders = [
            "memberId": String(userID),
        ]
        AF.request(CalendarAPIConstant.userTotalPlanURL, headers: headers).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode([UserTotalPlan].self, from: jsonData)
                    
                    self.userPlans = json
                    DispatchQueue.main.async {
                        self.setUserPlanDates(userPlans: self.userPlans)
                        self.calendar.reloadData()
                        self.setUserDailyPlan(date: Date())
                        self.tableView.reloadData()
                        self.indicatorView.stopAnimating()
                        print("유저플랜 갯수 : \(self.userPlans.count)")
                    }
                } catch(let err) {
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        self.indicatorView.stopAnimating()
                    }
                }
                // 실패
            case .failure(let err):
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                }
            }
        }
    }
    
    private func deleteUserPlan(planID: Int) {
        showIndicator()
        let headers: HTTPHeaders = [
            "plan_log_id": "\(planID)"
        ]
        AF.request(PlanAPIConstant.userPlanDeleteURL, method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                print("성공: \(res)")
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                }
                // 실패
            case .failure(let err):
                print("실패: \(err.localizedDescription)")
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                }
            }
        }
    }
    
}

// MARK:- Methods
extension CalendarViewController {
    
    func checkPlanColor(type: Int) -> UIColor {
        guard let blue = UIColor(named: "Color_1day"),
              let yellow = UIColor(named: "Color_7days"),
              let green = UIColor(named: "Color_15days"),
              let red = UIColor(named: "Color_30days") else { return UIColor() }
        
        switch type {
        case 1:
            return blue
        case 7:
            return yellow
        case 15:
            return green
        case 30:
            return red
        default:
            return blue
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
    
    // 플랜 날짜 리스트 만들기
    func setUserPlanDates(userPlans: [UserTotalPlan]) {
        planDates = [] // 꼭 플랜목록을 초기화해야지 새로운 데이터를 갱신해서 보여줄수 있다.
        let count = userPlans.count
        for i in 0 ..< count {
            planDates.append([])
            let startDateString = userPlans[i].startDate
            guard let startDate = dateFormatter.date(from: startDateString) else { return }
            var date = startDate
            for _ in 0..<userPlans[i].needAuthNum {
                planDates[i].append(dateFormatter.string(from: date))
                date = date + 86400
            }
        }
        print("setUserPlanDates() called - PlanDates: \(planDates)")
    }

    
    // 날짜 선택시 임시 유저플랜 array 세팅
    func setUserDailyPlan(date: Date) {
        // 날짜를 선택할때마다 메서드가 재호출 되는데 재호출시 유저의 데일리 플랜을 초기화해야한다.
        userDailyPlan = []
        let date = dateFormatter.string(from: date)
        for i in 0 ..< userPlans.count {
            if planDates[i].contains(date) {
                userDailyPlan.append(userPlans[i])
            }
        }
        print(planDates)
    }
    
    // 화면 나갔다오거나 삭제 이후에 선택된 날짜 표시 해제하고 오늘날짜로 선택하기
    func setSelectDate() {
        calendar.select(Date())
    }
    
}

// MARK:- Alert
extension CalendarViewController {
    
    // 플랜 삭제
    func deletePlanAlert(planID: Int) {
        let alert = UIAlertController(
            title: "",
            message: "정말로 플랜신청 내역을 삭제하시겠습니까?",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default) { (action : UIAlertAction) in
            self.deleteUserPlan(planID: planID)
            self.completeAlert()
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 플랜 삭제 완료
    func completeAlert() {
        let alert = UIAlertController(
            title: "",
            message: "플랜이 삭제되었습니다.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default){ (action : UIAlertAction) in
            self.getUserPlan()
            self.tableView.reloadData()
            self.calendar.reloadData()
            self.setSelectDate()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK:- FS Calendar DataSource
extension CalendarViewController: FSCalendarDataSource {
    
    // 특정 날짜 점 표시
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let strDate = dateFormatter.string(from:date)
        var dotCount = 0
        for i in 0 ..< planDates.count {
            if planDates[i].contains(strDate) {
                dotCount += 1
            }
        }
        return dotCount
    }
    
}

// MARK:- FS Calendar Delegate
extension CalendarViewController: FSCalendarDelegate {
    
    // 날짜 선택
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("날짜 선택")
        print(dateFormatter.string(from: date))
        setUserDailyPlan(date: date)
        tableView.reloadData()
        if userDailyPlan.count == 0 {
            noPlanLabel.isHidden = false
        } else {
            noPlanLabel.isHidden = true
        }
//        selectDate = date
    }
    
}

// MARK:- FS Calendar Delegate Appearance
extension CalendarViewController: FSCalendarDelegateAppearance {
    
    // 점 기본 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        var colors: [UIColor] = []
        let strDate = dateFormatter.string(from: date)
        for i in 0 ..< planDates.count {
            if planDates[i].contains(strDate) {
                colors.append(checkPlanColor(type: planDates[i].count))
            }
        }
        return colors
    }
    
    // 점 선택 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        
        var colors: [UIColor] = []
        let strDate = dateFormatter.string(from: date)
        for i in 0 ..< planDates.count {
            if planDates[i].contains(strDate) {
                colors.append(checkPlanColor(type: planDates[i].count))
            }
        }
        return colors
    }
    
}

// MARK:- Table View DataSource
extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDailyPlan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "calendarTableViewCell", for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        // 플랜이름
        cell.planTitleLabel.text = userDailyPlan[indexPath.row].planName
        // 플랜시간
        let timeString = userDailyPlan[indexPath.row].setTime
        let endIdx: String.Index = timeString.index(timeString.startIndex, offsetBy: 4)
        cell.timeLabel.text = String(timeString[...endIdx])
        // 플랜 인증 횟수
        cell.dayLabel.text = "\(userDailyPlan[indexPath.row].nowAuthNum) 일째"
        // 플랜 성공 여부
        let status = checkPlanProgress(status: userDailyPlan[indexPath.row].planProgress)
        cell.successLabel.text = status
        // 플랜 성공 여부 뷰 색상
        let statusColor = checkSuccessColor(status: userDailyPlan[indexPath.row].planProgress)
        cell.successLabelView.backgroundColor = statusColor
        // 플랜 뷰 색상
        cell.planColorBarView.backgroundColor = checkPlanColor(type: userDailyPlan[indexPath.row].needAuthNum)
        cell.dayLabelView.backgroundColor = checkPlanColor(type: userDailyPlan[indexPath.row].needAuthNum)
        // 셀 태그에 플랜로그아이디 삽입
        cell.tag = userDailyPlan[indexPath.row].planLogID
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let planLogID = tableView.cellForRow(at: indexPath)?.tag else { return }
            print("셀 삭제 플랜로그아이디 : \(planLogID)")
            deletePlanAlert(planID: planLogID)
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
