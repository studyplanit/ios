//
//  AttendanceViewController.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import UIKit

class AttendanceCompletionViewController: UIViewController {
    
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
extension AttendanceCompletionViewController {
    
    func configureUI() {
        urlLabel.text = url
        navigationItem.hidesBackButton = true
        navigationItem.title = "출석"
        completionButton.addTarget(self, action: #selector(completeButton), for: .touchUpInside)
    }
    
}

//MARK:- Configure
extension AttendanceCompletionViewController {
    
}

//MARK:- Methods
extension AttendanceCompletionViewController {
    
    @objc func completeButton() {
        let alert = UIAlertController(
            title: "",
            message: "Complete Attendance",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default){ (action : UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}
