//
//  TabBarController.swift
//  Split
//
//  Created by najin on 2020/11/11.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.items?[2].title = "스케줄"
    }
}
