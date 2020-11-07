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
    
    var userPlan: UserPlan?
    let userID = UserDefaults.standard.string(forKey: "id")
    var authURL = ""
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        configureButton()
        print(authURL)
        print("스플릿존 ID : \(getSplitZoneID(url: authURL))")
        print("userPlan: \(userPlan!)")
    }

}

//MARK:- Configure
extension AttendanceCompletionViewController {
    
    func configureUI() {
        guard let userPlan = userPlan else { return }
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
        timeLabel.text = formatiTimeString(timeString: String(userPlan.setTime))
        dayLabel.text = "\(userPlan.nowAuthNum + 1)일째 인증되었습니다"
        
    }
    
    func formatiTimeString(timeString: String) -> String {
        let endIdx: String.Index = timeString.index(timeString.startIndex, offsetBy: 4)
        return String(timeString[...endIdx])
    }
    
    func configureShadowUI(_ view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
    }
    
    func configureNavigationBar() {
//        urlLabel.text = url
        navigationItem.title = "QR"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "KoPubDotumBold", size: 20)!]
    }
    
    func configureButton() {
        completionButton.addTarget(self, action: #selector(completeButton), for: .touchUpInside)
    }
    
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
    
    private func postQRAuth() {
        guard let userPlan = userPlan else { return }
        
        let splitZoneID = getSplitZoneID(url: authURL)
        let planID = userPlan.planLogID
        
        let headers: HTTPHeaders = [
            "plan_log_id": "\(planID)",
            "planet_id": "\(splitZoneID)"
        ]
        let parameters = ["planet_id" : Int(splitZoneID)]
        AF.request(PlanAPIConstant.qrAuthURL, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                print("성공: \(res)")
                // 실패
            case .failure(let err):
                print("실패: \(err.localizedDescription)")
            }
        }
    }
    
    func getSplitZoneID(url: String) -> String {
        let endIndex = url.index(url.endIndex, offsetBy: -1)
        return String(url[endIndex...])
    }
    
}

//MARK:- Methods
extension AttendanceCompletionViewController {
    
    @objc func completeButton() {
        postQRAuth()
        let alert = UIAlertController(
            title: "",
            message: "인증이 완료되었습니다.",
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
