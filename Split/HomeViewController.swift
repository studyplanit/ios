//
//  HomeViewController.swift
//  Split
//
//  Created by najin on 2020/10/16.
//

import UIKit

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImageView(image: UIImage(named: "nav_split"))
        image.contentMode = UIView.ContentMode.scaleAspectFit
        navigationItem.titleView = image
        
//        let rightNavigationButtonImage = UIImage(named: "nav_map.png")
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightNavigationButtonImage, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        
    }

}
