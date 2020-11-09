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
    
    let userID = UserDefaults.standard.string(forKey: "id")
    var userTodayPlans: [UserTodayPlan] = []
    var userPlan: UserTodayPlan?
    var userPlanID = 0
    var authURL = ""
    
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "KoPubDotumBold", size: 20)!]
    }
    
    func configureUI() {
        for i in 0 ... 2 {
            planViews[i].layer.cornerRadius = 10
            planViews[i].layer.masksToBounds = false
            planViews[i].layer.shadowColor = UIColor.black.cgColor
            planViews[i].layer.shadowOffset = CGSize(width: 0, height: 10)
            planViews[i].layer.shadowRadius = 10
            planViews[i].layer.shadowOpacity = 0.5
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
            configureTapGesture(index: i)
        }
    }
    
    func resetPlanView() {
        for i in 0...2 {
            planViews[i].backgroundColor = .lightGray
            planNameLabels[i].text = ""
            planTimeLabels[i].text = ""
            planViews[i].isUserInteractionEnabled = false
        }
    }
    
    func configureTapGesture(index: Int) {
        let gesture = MyTapGesture(target: self, action: #selector(showScanner))
        gesture.planIndex = index
        planViews[index].addGestureRecognizer(gesture)
        planViews[index].isUserInteractionEnabled = true
    }
    
}

// MARK:- API
extension AttendanceViewController {
    
    // 유저별 오늘 플랜 불러오기
    private func getUserTodayPlan() {
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
    
    private func postQRAuth() {
        
        let splitZoneID = getSplitZoneID(url: authURL)
        let planID = userPlanID
        
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
