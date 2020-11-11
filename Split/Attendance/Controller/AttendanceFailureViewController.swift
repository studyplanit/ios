//
//  AttendanceFailureViewController.swift
//  Split
//
//  Created by uno on 2020/11/09.
//

import UIKit

class AttendanceFailureViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var splitZoneNameLabel: UILabel!
    @IBOutlet weak var splitZoneCodeLabel: UILabel!
    @IBOutlet weak var planView: UIView!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    var splitZoneName = ""
    var splitZoneCode = ""
    var errorString = ""
    var userPlan: UserTodayPlan?
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        confgirueSplitZoneView()
        configurePlanView()
        configureErrorLabel()
        configureRetryButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 해당 페이지를 벗어나서 플랜을 삭제할 경우를 대비
        navigationController?.popToRootViewController(animated: true)
    }

}

//MARK:- Configure UI
extension AttendanceFailureViewController {
    
    // 네비게이션바
    func configureNavigationBar() {
        navigationItem.title = "QR"
        navigationItem.hidesBackButton = true
    }
    
    // 전체 UI
    func configureUI() {
        // 기본 UI
        guard let userPlan = userPlan else { return }
        planView.layer.cornerRadius = 10
        planView.backgroundColor = UIColor(named: checkPlanColor(type: userPlan.needAuthNum))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 3
        retryButton.layer.cornerRadius = 0.5 * retryButton.bounds.size.height
        // 그림자
        configureShadowUI(planView)
    }
    
    // 그림자 추가
    func configureShadowUI(_ view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
    }
    
    func confgirueSplitZoneView() {
        splitZoneNameLabel.text = splitZoneName
        splitZoneCodeLabel.text = splitZoneCode
    }
    
    func configurePlanView() {
        guard let plan = userPlan else { return }
        planNameLabel.text = plan.planName
        timeLabel.text = plan.setTime
    }
    
    func configureErrorLabel() {
        contentLabel.text = errorString
    }
    
    func configureRetryButton() {
        retryButton.addTarget(self, action: #selector(touchUpRetryButton), for: .touchUpInside)
    }

    
}

//MARK:- Methods
extension AttendanceFailureViewController {
    
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
    
    @objc func touchUpRetryButton() {
        navigationController?.popViewController(animated: true)
    }
    
}
