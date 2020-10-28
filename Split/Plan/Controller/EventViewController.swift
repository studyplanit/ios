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

    }
    
}

// MARK:- Configure
extension EventViewController {
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

// MARK:- Methods
extension EventViewController {
    
}

// MARK:- Table View DataSource
extension EventViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

// MARK:- Table View Delegate
extension EventViewController: UITableViewDelegate {
    
}

