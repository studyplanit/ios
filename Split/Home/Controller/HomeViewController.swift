//
//  HomeViewController.swift
//  Split
//
//  Created by najin on 2020/10/16.
//

import UIKit
import AVFoundation
import QRCodeReader

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImageView(image: UIImage(named: "nav_split"))
        image.contentMode = UIView.ContentMode.scaleAspectFit
        navigationItem.titleView = image
        
        // main image tap gesture
        let imageViewTapGestureRecognizer = UITapGestureRecognizer()
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(imageViewTapGestureRecognizer)
        imageViewTapGestureRecognizer.addTarget(self, action: #selector(tapImageView))
        
    }
    
    // main image tap gesture
    @objc func tapImageView() {
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceViewController = storyboard.instantiateViewController(withIdentifier: "attendanceView") as? AttendanceViewController else { return }
        navigationController?.pushViewController(attendanceViewController, animated: true)
    }
    
}

