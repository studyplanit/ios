//
//  PlanViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit

class PlanViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var chellengeButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
// MARk:- Configure UI
extension PlanViewController {
    
}

// MARk:- Methods
extension PlanViewController {
    
    @objc func touchUpChallengeButton() {
        print("challenge button clicked")
    }
    
    @objc func touchUpEventButton() {
        print("event button clicked")
    }
}
