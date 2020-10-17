//
//  JoinViewController.swift
//  Split
//
//  Created by najin on 2020/10/14.
//

import UIKit

class JoinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "smsAuthViewController")
        self.dismiss(animated: false, completion: nil)
    }
    

}
