//
//  SubscriptionViewController.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import UIKit
import FSCalendar
import Alamofire

class SubscriptionViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var planTitleView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var userPlans: [UserTotalPlan] = []
    var planDates: [[String]] = []
    var plan: PlanList?
    var responsePlanRegistration: ResponsePlanRegistration?
    let userID = UserDefaults.standard.string(forKey: "id")
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    let timeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    var startDate = ""
    var endDate = ""
    var planTime = "00:00"

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        configureCalendar()
        configureTimePicker()
        print("유저아이디 : \(userID!)")
        print("선택한 플랜: \(plan!)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUserPlan()
    }

}

// MARK:- Configure
extension SubscriptionViewController {
    
    func configureUI() {
        planTitleLabel.text = plan?.name
        planTitleLabel.textColor = .white
        planTitleView.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.6431372549, blue: 0.1647058824, alpha: 1)
        planTitleView.layer.cornerRadius = 0.5 * planTitleView.bounds.size.height
    }
    
    func configureCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.locale = Locale(identifier: "ko")
        calendar.appearance.headerDateFormat = "yyyy.MM"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.calendarHeaderView.backgroundColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3098039216, alpha: 1)
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleFont = UIFont(name: "KoPubDotumBold", size: 20)
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.todayColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3098039216, alpha: 1).withAlphaComponent(0.7)
        calendar.appearance.selectionColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red // 일요일
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .red // 토요일
        
    }
    
    func configureNavigationBar() {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(checkDateFormAndShowAlert))
        navigationItem.rightBarButtonItem = button
        navigationItem.title = "플랜"
    }
    
    func configureTimePicker() {
        timePicker.addTarget(self, action: #selector(setPlanTime(_:)), for: .valueChanged)
    }
    
}

// MARK:- API
extension SubscriptionViewController {
    
    private func getUserPlan() {
        let headers: HTTPHeaders = [
            "memberId": "2",
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
//                        self.tableView.reloadData()
                        self.planDates = [[],[],[]]
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
    
    private func postPlan(planID: String,
                          startDate: String,
                          endDate: String,
                          setTime: String) {

        let headers: HTTPHeaders = [
            "member_id": "2",
            "plan_id": planID,
            "startDate": startDate,
            "endDate": endDate,
            "setTime": setTime
        ]
        
        AF.request(PlanAPIConstant.planInsertURL, method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                print(res)
                do {
                    // 반환값을 Data 타입으로 변환
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    
                    let json = try JSONDecoder().decode(ResponsePlanRegistration.self, from: jsonData)
                    // dataSource에 변환한 값을 대입
                    self.responsePlanRegistration = json
                    // 메인 큐를 이용하여 tableView 리로딩
                    guard let response = self.responsePlanRegistration?.planLogID else { return }
                    print("postPlan - \(response)")
                    switch response {
                    case 1:
                        print("postPlan - 1")
                        DispatchQueue.main.async {
                            self.showSuccessAPIAlert()
                        }
                    case -1:
                        print("postPlan - -1")
                        DispatchQueue.main.async {
                            self.showAPIFailureAlert(data: json)
                        }
                    case -2:
                        print("postPlan - -2")
                        DispatchQueue.main.async {
                            self.showAPIFailureAlert(data: json)
                        }
                    case -100:
                        print("postPlan - -100")
                        DispatchQueue.main.async {
                            self.showAPIFailureAlert(data: json)
                        }
                    case -500:
                        print("postPlan -500")
                        DispatchQueue.main.async {
                            self.showAPIFailureAlert(data: json)
                        }
                    default:
                        return
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
    
}

// MARK:- Methods
extension SubscriptionViewController {
    
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
    
    // 플랜 날짜 리스트 만들기
    func setUserPlanDates(userPlans: [UserTotalPlan]) {
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
    
    // 타임피커 값변경시 플랜시간 변수 설정
    @objc func setPlanTime (_ sender: UIDatePicker) {
        planTime = timeFormatter.string(from: sender.date)
        print("설정한 시간 : \(planTime)")
    }
    
}

// MARK:- Alert
extension SubscriptionViewController {
    
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
    
    // 날짜를 올바르게 선택하고 확인버튼 클릭시 alert
    func ShowCorrectAlert() {
        let alert = UIAlertController(
            title: "꼼꼼히 확인해주세요!",
            message: "선택하신 시간과 날짜로 플랜을 신청하시겠습니까?",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default){ (action : UIAlertAction) in
            guard let planID = self.plan?.id else { return }
            self.postPlan(planID: String(planID), startDate: self.startDate, endDate: self.endDate, setTime: self.planTime)
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 날짜를 올바르게 선택하지않고 확인버튼 클릭시 alert
    func ShowIncorrectAlert() {
        let alert = UIAlertController(
            title: "",
            message: "날짜와 시간을 선택해주세요.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 날짜를 선택했는지 확인후 Alert
    @objc func checkDateFormAndShowAlert() {
        if startDate != "" && endDate != "" {
            ShowCorrectAlert()
        } else {
            ShowIncorrectAlert()
        }
    }
    
    // 등록 성공시 알림
    func showSuccessAPIAlert() {
        let alert = UIAlertController(
            title: "",
            message: "등록 성공",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default){ (action : UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 등록 실패시 알림
    func showAPIFailureAlert(data: ResponsePlanRegistration) {
        let alert = UIAlertController(
            title: "등록실패",
            message: data.message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK:- FSCalendar DataSource
extension SubscriptionViewController: FSCalendarDataSource {
    
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

// MARK:- FSCalendar Delegate
extension SubscriptionViewController: FSCalendarDelegate {
    
    // 특정 날짜 선택시 이벤트
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count > 1 {
            for _ in 0 ..< calendar.selectedDates.count - 1 {
                calendar.deselect(calendar.selectedDates[0])
            }
        }
        guard let plan = plan else { return }
        let planDay: Double = Double(plan.need)
        var startTemp: Date!
        startTemp = calendar.selectedDates[0]
        let endTemp = startTemp + ((planDay-1) * 86400)
        while startTemp < endTemp {
            startTemp += 86400
            calendar.select(startTemp)
        }
        startDate = dateFormatter.string(from: calendar.selectedDates[0])
        endDate = dateFormatter.string(from: endTemp)
        print("날짜 선택 - 선택한 날짜 : \(dateFormatter.string(from: date))")
        print("날짜 선택 - 시작날짜: \(startDate), 끝날짜: \(endDate)")
    }
    
    // 특정 날짜 선택 해제시 이벤트
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("날짜 선택 해제 \(dateFormatter.string(from: date))")
        for _ in 0 ..< calendar.selectedDates.count {
            calendar.deselect(calendar.selectedDates[0])
        }
        startDate = ""
        endDate = ""
        print("날짜 선택 해제 - 시작날짜: \(startDate), 끝날짜: \(endDate)")
    }
    
    // 오늘 포함 이전 날짜 선택 불가
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        
//        let today = Date()
//
//        if date < today {
//            return false
//        } else {
//            return true
//        }
//    }
    
}

// MARK:- FSCalendar Delegate Appearance
extension SubscriptionViewController: FSCalendarDelegateAppearance {
    
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
