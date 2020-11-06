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
    var plans: [PlanList] = []
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        getPlanList()
    }
    
}

// MARK:- Configure
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
    
    func setMedalImage(type: Int) -> String {
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

// MARK:- Methods
extension ChallengeViewController {
    
    private func getPlanList() {
        AF.request(PlanAPIConstant.planListURL).responseJSON { (response) in
            switch response.result {
                // 성공
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode([PlanList].self, from: jsonData)
                    // dataSource에 변환한 값을 대입
                    self.plans = json
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
            cell.planTitleLabel.text = plans[indexPath.row].name
            let medalName = setMedalImage(type: plans[indexPath.row].need)
            cell.medalImageView.image = UIImage(named: medalName)
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
            return screenWidth * 1/4
        case 1:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let subscriptionViewController = storyboard?.instantiateViewController(withIdentifier: "subscriptionViewController") as? SubscriptionViewController else {
            return
        }
        subscriptionViewController.plan = plans[indexPath.row]
        navigationController?.pushViewController(subscriptionViewController, animated: true)
    }
    
}
