//
//  AttendanceViewController.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import UIKit

class AttendanceCompletionViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var planView: UIView!
    @IBOutlet weak var sayingLabelView: UIView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    
    var url = ""
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        configureButton()
        print(url)
    }

}

//MARK:- Configure
extension AttendanceCompletionViewController {
    
    func configureUI() {
        planView.layer.cornerRadius = 10
        sayingLabelView.layer.cornerRadius = 10
        sayingLabelView.layer.borderWidth = 3
        completionButton.layer.cornerRadius = 0.5 * completionButton.bounds.size.height

    }
    
    func configureNavigationBar() {
//        urlLabel.text = url
        navigationItem.title = "QR"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "KoPubDotumBold", size: 20)!]
    }
    
    func configureButton() {
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
