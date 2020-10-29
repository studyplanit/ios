//
//  SubscriptionViewController.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import UIKit

class SubscriptionViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }

}

// MARK:- Configure
extension SubscriptionViewController {
    
    func configureNavigationBar() {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(touchUpCompleteButton))
        navigationItem.rightBarButtonItem = button
        navigationItem.title = "플랜"
    }
    
}

// MARK:- Methods
extension SubscriptionViewController {
    
    @objc func touchUpCompleteButton() {
        let alert = UIAlertController(
            title: "",
            message: "플랜 신청이 완료되었습니다.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default){ (action : UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
