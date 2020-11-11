//
//  AttendanceViewController.swift
//  Split
//
//  Created by uno on 2020/10/31.
//

import UIKit
import AVFoundation
import QRCodeReader
import Alamofire

class AttendanceViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet var planViews: [UIView]!
    @IBOutlet var planNameLabels: [UILabel]!
    @IBOutlet var planTimeLabels: [UILabel]!
    @IBOutlet var planPeriodLabels: [UILabel]!
    @IBOutlet var planAuthCountViews: [UIView]!
    @IBOutlet var planAuthCountLabel: [UILabel]!
    @IBOutlet var planNeedPercentLabel: [UILabel]!
    
    private let indicatorView = UIActivityIndicatorView()
    let userID = UserDefaults.standard.string(forKey: "id")
    var userTodayPlans: [UserTodayPlan] = []
    var userPlan: UserTodayPlan?
    var userPlanID = 0
    var authURL = ""
    let timeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "yy.MM.dd"
        return formatter
    }()
    
    // MARK:- Properties
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        return QRCodeReaderViewController(builder: builder)
    }()

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapBar()
        configureUI()
        resetPlanView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUserTodayPlan()
    }
    
}

// MARK:- Configure UI
extension AttendanceViewController {
    
    func configureTapBar() {
        navigationItem.title = "QR"
    }
    
    func configureUI() {
        for i in 0 ... 2 {
            planViews[i].layer.cornerRadius = 10
            planViews[i].layer.masksToBounds = false
            planViews[i].layer.shadowColor = UIColor.black.cgColor
            planViews[i].layer.shadowOffset = CGSize(width: 0, height: 10)
            planViews[i].layer.shadowRadius = 10
            planViews[i].layer.shadowOpacity = 0.5
            planAuthCountViews[i].layer.cornerRadius = 0.5 * planAuthCountViews[i].bounds.size.height
        }
    }
    
    func configurePlanView() {
        resetPlanView()
        // 서버측에서 유저 보유플랜이 3개 이상인경우에 3으로 리턴하여 연산
        let count = userTodayPlans.count <= 3 ? userTodayPlans.count : 3
        for i in 0 ..< count {
            planViews[i].backgroundColor = UIColor(named: checkPlanColor(type: userTodayPlans[i].needAuthNum))
            planNameLabels[i].text = userTodayPlans[i].planName
            planTimeLabels[i].text = userTodayPlans[i].setTime
            // 기간
            guard let startDate = dateFormatter.date(from: userTodayPlans[i].startDate) else { return }
            guard let endDate = dateFormatter.date(from: userTodayPlans[i].endDate) else { return }
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            planPeriodLabels[i].text = "\(startDateString) ~ \(endDateString)"
            // 인증횟수
            planAuthCountViews[i].isHidden = false
            let needAuthNumber = userTodayPlans[i].needAuthNum
            let nowAuthNumber = userTodayPlans[i].nowAuthNum
            let resultNumber = Double(nowAuthNumber) / Double(needAuthNumber) * 100
            planAuthCountLabel[i].text = "인증 \(userTodayPlans[i].nowAuthNum)회 (\(resultNumber)%)"
            // 퍼센트
            planNeedPercentLabel[i].text = checkPercent(need: userTodayPlans[i].needAuthNum)
            configureTapGesture(index: i)
//            checAndDisalbePlanView(index: i)
        }
    }
    
    func resetPlanView() {
        for i in 0...2 {
            planViews[i].backgroundColor = .lightGray
            planNameLabels[i].text = ""
            planTimeLabels[i].text = ""
            planViews[i].isUserInteractionEnabled = false
            planPeriodLabels[i].text = ""
            planAuthCountViews[i].isHidden = true
            planAuthCountLabel[i].text = ""
            planNeedPercentLabel[i].text = ""
        }
    }
    
    func configureTapGesture(index: Int) {
        let gesture = MyTapGesture(target: self, action: #selector(showScanner))
        gesture.planIndex = index
        planViews[index].addGestureRecognizer(gesture)
        planViews[index].isUserInteractionEnabled = true
    }
    
    func showIndicator() {
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicatorView.startAnimating()
    }
    
    // 시간차를 구해서 뷰 상태 활성화 결정해주기
//    func checAndDisalbePlanView(index: Int) {
//        let calendar = Calendar.current
//        let now = calendar.dateComponents([.year, .month, .day], from: Date())
//        guard let time = timeFormatter.date(from: userTodayPlans[index].setTime) else { return }
//        var date = calendar.dateComponents([.year, .month, .day], from: time)
//        date.year = now.year
//        date.month = now.month
//        date.day = now.day! + 1
//        let planDate = calendar.date(from: date)
//        print("checAndDisalbePlanView() called - 나우: \(now.hour)")
//        print("checAndDisalbePlanView() called - 데이트: \(date)")
//        print("checAndDisalbePlanView() called - 타임: \(time)")
//        print("checAndDisalbePlanView() called - 데이트: \(planDate)")
//        if time.timeIntervalSince(Date()) > 60 * 60 * 2 {
//            planViews[index].isUserInteractionEnabled = false
//            planViews[index].alpha = 0.2
//        }
//    }
    
}

// MARK:- API
extension AttendanceViewController {
    
    // 유저별 오늘 플랜 불러오기
    private func getUserTodayPlan() {
        showIndicator()
        let headers: HTTPHeaders = [
            "memberId": "2",
        ]
        AF.request(CalendarAPIConstant.userTodayPlanURL, headers: headers).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode([UserTodayPlan].self, from: jsonData)
                    self.userTodayPlans = json
                    DispatchQueue.main.async {
                        self.configurePlanView()
                        self.indicatorView.stopAnimating()
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
    
    private func postQRAuth() {
        let splitZoneID = getSplitZoneID(url: authURL)
        let planID = userPlanID
        print("postQRAuth() called - splitZoneID: \(splitZoneID)")
        print("postQRAuth() called - planID: \(planID)")
        
        let headers: HTTPHeaders = [
            "plan_log_id": "\(planID)",
            "planet_id": "\(splitZoneID)"
        ]
        AF.request(authURL, method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            
            // 요청 성공
            case .success(let res):
                print("성공: \(res)")
                do {
                    // 반환값을 Data 타입으로 변환
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(QRAuthResponse.self, from: jsonData)
                    
                    let reponse = json.authenticate
                    
                    switch reponse {
                    case 1:
                        print("인증성공 - 1")
                        DispatchQueue.main.async {
                            self.setCompletionView(data: json)
                        }
                    case -200:
                        print("인증실패 - -200")
                        DispatchQueue.main.async {
                            self.setFailureView(data: json)
                        }
                    case -300:
                        print("인증실패 - -300")
                        DispatchQueue.main.async {
                            self.setFailureView(data: json)
                        }
                    case -400:
                        print("인증실패 - -400")
                        DispatchQueue.main.async {
                            self.setFailureView(data: json)
                        }
                    case -500:
                        print("인증실패 - -500")
                        DispatchQueue.main.async {
                            self.setFailureView(data: json)
                        }
                    default:
                        return
                    }
                    
                } catch(let err) {
                    print("json에러: \(err.localizedDescription)")
                }
            // 요청 실패
            case .failure(let err):
                print("실패: \(err.localizedDescription)")
                DispatchQueue.main.async {
                    self.setAPIFailureView(error: err.localizedDescription)
                }
            }
        }
    }
    
}

// MARK:- Methods
extension AttendanceViewController {
    
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
    
    func getSplitZoneID(url: String) -> String {
        let endIndex = url.index(url.endIndex, offsetBy: -1)
        return String(url[endIndex...])
    }
    
    // QR 인증요청 성공시 AttendanceCompletionViewController 세팅
    func setCompletionView(data: QRAuthResponse) {
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceCompletionViewController = storyboard.instantiateViewController(withIdentifier: "attendanceCompletionViewController") as? AttendanceCompletionViewController else { return }
        
        attendanceCompletionViewController.splitZoneName = data.name
        attendanceCompletionViewController.splitZoneCode = data.code
        attendanceCompletionViewController.userPlan = userPlan
        self.navigationController?.pushViewController(attendanceCompletionViewController, animated: true)
    }
    
    // QR 인증요청 실패시 AttendanceFailureViewController 세팅
    func setFailureView(data: QRAuthResponse) {
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceFailureViewController = storyboard.instantiateViewController(withIdentifier: "attendanceFailureViewController") as? AttendanceFailureViewController else { return }
        
        print("setFailureView() called - splitZoneName: \(data)")
        attendanceFailureViewController.splitZoneName = data.name
        attendanceFailureViewController.splitZoneCode = data.code
        attendanceFailureViewController.userPlan = userPlan
        attendanceFailureViewController.errorString = data.message
        self.navigationController?.pushViewController(attendanceFailureViewController, animated: true)
    }
    
    // 요청 실패
    func setAPIFailureView(error: String) {
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceFailureViewController = storyboard.instantiateViewController(withIdentifier: "attendanceFailureViewController") as? AttendanceFailureViewController else { return }
        
        attendanceFailureViewController.errorString = error
        print("setAPIFailureView() called - ")
        self.navigationController?.pushViewController(attendanceFailureViewController, animated: true)
    }
    
    func checkPercent(need: Int) -> String {
        switch need {
        case 1:
            return "100%"
        case 7, 15, 30:
            return "70%"
        default:
            return ""
        }
    }

}

// MARK:- QR Scanner Methods
extension AttendanceViewController {
    
    @objc func showScanner(_ sender: MyTapGesture) {
        print("MainViewController - showScanner() called ")
        userPlan = userTodayPlans[sender.planIndex]
        userPlanID = userTodayPlans[sender.planIndex].planLogID
        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print("QRCodeScanner succeded in closure")
            guard let result = result else { return }
            print(result)
            let scannedUrlString = result.value
            print("scannedUrlString : \(scannedUrlString)")
        }
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
}

// MARK:- QR Code Reader View Controller Delegate
extension AttendanceViewController: QRCodeReaderViewControllerDelegate {
    
    // QR코드 리더가 성공했을 때 동작 정의
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("QRCodeScanner succeded in delegate")
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        
        authURL = result.value
        postQRAuth()
        print("큐알인증완료 - url : \(authURL)")
    }
    
    // QR코드 리더가 취소 됬을때 정의
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("QRCodeScanner stoped")
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}
