//
//  EventViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit

class EventViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
}

// MARK:- Configure
extension EventViewController {
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "EventBannerTableViewCell", bundle: nil),
            forCellReuseIdentifier: "eventBannerTableViewCell")
        tableView.register(
            UINib(nibName: "EventContentTableViewCell", bundle: nil),
            forCellReuseIdentifier: "eventContentTableViewCell")
    }
    
}

// MARK:- Methods
extension EventViewController {
    
}

// MARK:- Table View DataSource
extension EventViewController: UITableViewDataSource {
    
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
                    withIdentifier: "eventBannerTableViewCell",
                    for: indexPath) as? EventBannerTableViewCell else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "eventContentTableViewCell",
                    for: indexPath) as? EventContentTableViewCell else { return UITableViewCell() }
            switch indexPath.row {
            case 0:
                cell.planTitleLabel.text = "중간고사 출석 플랜"
                return cell
            case 1:
                cell.planTitleLabel.text = "기말고사 출석 플랜"
                return cell
            case 2:
                cell.planTitleLabel.text = "여름방학 출석 플랜"
                return cell
            case 3:
                cell.planTitleLabel.text = "겨울방학 출석 플랜"
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}

// MARK:- Table View Delegate
extension EventViewController: UITableViewDelegate {
    
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

