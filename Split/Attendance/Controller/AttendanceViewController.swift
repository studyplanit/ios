//
//  AttendanceViewController.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import UIKit

class AttendanceViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    
    var url = ""
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

}

//MARK:- Configure
extension AttendanceViewController {
    
    func configureUI() {
        urlLabel.text = url
        navigationItem.hidesBackButton = true
        navigationItem.title = "출석"
        completionButton.addTarget(self, action: #selector(completeButton), for: .touchUpInside)
    }
    
}

//MARK:- Configure
extension AttendanceViewController {
    
    @objc func completeButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

