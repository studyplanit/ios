//
//  AttendanceViewController.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import UIKit
import Alamofire

class AttendanceCompletionViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var planView: UIView!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var sayingLabelView: UIView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var splitZoneNameLabel: UILabel!
    @IBOutlet weak var splitZoneCodeLabel: UILabel!
    
    var splitZoneName = ""
    var splitZoneCode = ""
    var userTodayPlan: UserTodayPlan?
    let userID = UserDefaults.standard.string(forKey: "id")
    var authURL = ""
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        configureButton()
        print(authURL)
        print("userPlan: \(userTodayPlan!)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureSplitZoneInfoView()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 해당 페이지를 벗어나서 플랜을 삭제할 경우를 대비
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK:- Configure UI
extension AttendanceCompletionViewController {
    
    // 전체 UI
    func configureUI() {
        guard let userPlan = userTodayPlan else { return }
        // 기본 UI
        planView.layer.cornerRadius = 10
        planView.backgroundColor = UIColor(named: checkPlanColor(type: userPlan.needAuthNum))
        sayingLabelView.layer.cornerRadius = 10
        sayingLabelView.layer.borderWidth = 3
        completionButton.layer.cornerRadius = 0.5 * completionButton.bounds.size.height
        // 그림자
        configureShadowUI(planView)
        configureShadowUI(sayingLabelView)
        configureShadowUI(completionButton)
        // 인증한 플랜 컨텐츠
        planNameLabel.text = userPlan.planName
        timeLabel.text = userPlan.setTime
        dayLabel.text = "\(userPlan.nowAuthNum + 1)일째 인증되었습니다"
        
    }
    
//    // 시, 분 만 표시하기
//    func formatiTimeString(timeString: String) -> String {
//        let endIdx: String.Index = timeString.index(timeString.startIndex, offsetBy: 4)
//        return String(timeString[...endIdx])
//    }
    
    // 그림자 추가
    func configureShadowUI(_ view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
    }
    
    // 네비게이션바
    func configureNavigationBar() {
//        urlLabel.text = url
        navigationItem.title = "QR"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "KoPubDotumBold", size: 20)!]
        navigationItem.hidesBackButton = true
    }
    
    // 버튼
    func configureButton() {
        completionButton.addTarget(self, action: #selector(touchUpCompletionButton), for: .touchUpInside)
    }
    
    // 스플릿존 이름, 뷰
    func configureSplitZoneInfoView() {
        print("configureSplitZoneInfoView() called - splitZoneName:\(splitZoneName), splitZoneCode:\(splitZoneCode)")
        splitZoneNameLabel.text = splitZoneName
        splitZoneCodeLabel.text = splitZoneCode
    }
    
}

//MARK:- API
extension AttendanceCompletionViewController {
    
}

//MARK:- Methods
extension AttendanceCompletionViewController {
    
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
    
    @objc func touchUpCompletionButton() {
//        postQRAuth()
        let alert = UIAlertController(
            title: "",
            message: "인증이 완료되었습니다.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default){ (action : UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    
//    func completeAlert() {
//
//    }
    
}
