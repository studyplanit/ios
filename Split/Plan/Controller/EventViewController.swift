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
    
    var eventPlans: [PlanModel.Plan] = PlanModel.eventPlans
    
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
            return eventPlans.count
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
            cell.planTitleLabel.text = eventPlans[indexPath.row].plnaTitle
            return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let subscriptionViewController = storyboard?.instantiateViewController(withIdentifier: "subscriptionViewController") as? SubscriptionViewController else {
            return
        }
        subscriptionViewController.plan = eventPlans[indexPath.row]
        navigationController?.pushViewController(subscriptionViewController, animated: true)
    }
    
}

