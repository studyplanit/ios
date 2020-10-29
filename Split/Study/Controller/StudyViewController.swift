//
//  StudyViewController.swift
//  Split
//
//  Created by uno on 2020/10/28.
//

import UIKit

class StudyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapBar()
    }

}
// MARK:- Configure
extension StudyViewController {
    
    func configureTapBar() {
        navigationItem.title = "스터디"
    }
    
}
