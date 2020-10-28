//
//  ChallengeViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
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
    
}

extension ChallengeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
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
                    for: indexPath) as? ChallengeContentTableViewCell else { return UITableViewCell() }
            switch indexPath.row {
            case 0:
                cell.planTitleLabel.text = "출석 챌린지 플랜 1일"
                return cell
            case 1:
                cell.planTitleLabel.text = "출석 챌린지 플랜 7일"
                return cell
            case 2:
                cell.planTitleLabel.text = "출석 챌린지 플랜 15일"
                return cell
            case 3:
                cell.planTitleLabel.text = "출석 챌린지 플랜 30일"
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
}

extension ChallengeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        switch indexPath.section {
        case 0:
            return screenWidth * 1/2
        case 1:
            return 100
        default:
            return UITableView.automaticDimension
        }
    }
    
}
