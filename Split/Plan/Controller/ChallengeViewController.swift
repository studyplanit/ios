//
//  ChallengeViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit
import Alamofire

class ChallengeViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    private let indicatorView = UIActivityIndicatorView()
    var plans: [PlanList] = []
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getPlanList()
    }
    
}

// MARK:- Configure UI
extension ChallengeViewController {
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "ChallengeBannerTableViewCell", bundle: nil),
            forCellReuseIdentifier: "challengeBannerTableViewCell")
        tableView.register(
            UINib(nibName: "ChallengeContentTableViewCell", bundle: nil),
            forCellReuseIdentifier: "challengeContentTableViewCell")
    }
    
    func configureMedalImage(type: Int) -> String {
        switch type {
        case 1:
            return "noneMedal"
        case 7:
            return "icon_medalBronze"
        case 15:
            return "icon_medalSilver"
        case 30:
            return "icon_medalGold"
        default:
            return "noneMedal"
        }
    }
    
    
}

// MARK:- API
extension ChallengeViewController {
    
    private func getPlanList() {
        showIndicator()
        AF.request(PlanAPIConstant.planListURL).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode([PlanList].self, from: jsonData)
                    self.plans = json
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        print("getPlanList()called - plans: \(self.plans)")
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
    
}

// MARK:- Methods
extension ChallengeViewController {
    
    func showIndicator() {
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicatorView.startAnimating()
    }
    
}

// MARK:- Alert
extension ChallengeViewController {
    
    // 테스트 기간용 알림
    func prohibitAlert() {
        let alert = UIAlertController(
            title: "",
            message: "테스트 기간에는 이용할 수 없는 플랜입니다.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK:- Table View DataSource
extension ChallengeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return plans.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIndex = indexPath.section
        
        switch sectionIndex {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "challengeBannerTableViewCell",
                    for: indexPath) as? ChallengeBannerTableViewCell else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "challengeContentTableViewCell",
                    for: indexPath) as? ChallengeContentTableViewCell else {
                return UITableViewCell()
            }
//            cell.planTitleLabel.text = plans[indexPath.row].name
            cell.planDateLabel.text = "\(plans[indexPath.row].need)일"
            let medalName = configureMedalImage(type: plans[indexPath.row].need)
            cell.medalImageView.image = UIImage(named: medalName)
            cell.userNumberLabel.text = numberFormatter.string(from: NSNumber(value: plans[indexPath.row].accNumber))! + " 명"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

// MARK:- Table View Delegate
extension ChallengeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        switch indexPath.section {
        case 0:
            return screenWidth * 165/750
        case 1:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            switch indexPath.row {
            case 0, 1, 2, 3:
                guard let subscriptionViewController = storyboard?.instantiateViewController(withIdentifier: "subscriptionViewController") as? SubscriptionViewController else {
                    return
                }
                subscriptionViewController.plan = plans[indexPath.row]
                navigationController?.pushViewController(subscriptionViewController, animated: true)
//            case 2, 3:
//                return prohibitAlert()
            default:
                return
            }
        default:
            return
        }
        
    }
    
}
