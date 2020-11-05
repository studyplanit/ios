//
//  SettingViewController.swift
//  Split
//
//  Created by najin on 2020/10/21.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutButtonClick(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "id")
        print("logout")
        //로그인 페이지로 이동
    }
}
