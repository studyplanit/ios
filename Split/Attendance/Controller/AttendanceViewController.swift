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
    var userPlans: [UserPlan] = []
    
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapBar()
        configureUI()
        getUserPlan()
    }
    
}

// MARK:- Configure
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
    
    func configureTapGesture(number: Int) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showScanner))
        planViews[number].addGestureRecognizer(gesture)
        planViews[number].isUserInteractionEnabled = true
    }
    
}

// MARK:- Methods
extension AttendanceViewController {
    
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
                        self.setPlanView()
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
    
    func setPlanView() {
        // 서버측에서 유저 보유플랜이 3개 이상인경우에 3으로 리턴하여 연산
        let count = userPlans.count <= 3 ? userPlans.count : 3
        for i in 0 ..< count {
            planViews[i].backgroundColor = UIColor(named: checkPlanColor(type: userPlans[i].needAuthNum))
            planNameLabels[i].text = userPlans[i].planName
            let timeString = userPlans[i].setTime
            let endIdx: String.Index = timeString.index(timeString.startIndex, offsetBy: 4)
            planTimeLabels[i].text = String(timeString[...endIdx])
            configureTapGesture(number: i)
        }
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
    
    @objc func showScanner() {
        print("MainViewController - showScanner() called ")
        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print("QRCodeScanner succeded in closure")
            guard let result = result else { return }
            print(result)
            let scannedUrlString = result.value
            print("scannedUrlString : \(scannedUrlString)")
//            guard let scannedUrl = URL(string: scannedUrlString) else { return }
//            self.webView.load(URLRequest(url: scannedUrl))
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
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceCompletionViewController = storyboard.instantiateViewController(withIdentifier: "attendanceCompletionViewController") as? AttendanceCompletionViewController else { return }
        attendanceCompletionViewController.url = result.value
        navigationController?.pushViewController(attendanceCompletionViewController, animated: true)
    }
    
    // QR코드 리더가 취소 됬을때 정의
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("QRCodeScanner stoped")
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}
