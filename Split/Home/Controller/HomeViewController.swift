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
    @IBOutlet weak var todaySplitLabel: UILabel!
    let phoneWidth = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(phoneWidth)
        
        //타이틀 이미지넣기
        let image = UIImageView(image: UIImage(named: "nav_split"))
        image.contentMode = UIView.ContentMode.scaleAspectFit
        navigationItem.titleView = image
        
        //오늘 다녀간 회원 반응형 텍스트
        todaySplitLabel.font = UIFont(name: "GmarketSansMedium", size: phoneWidth * 0.07)
        
        // main image tap gesture
        let imageViewTapGestureRecognizer = UITapGestureRecognizer()
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(imageViewTapGestureRecognizer)
        imageViewTapGestureRecognizer.addTarget(self, action: #selector(tapImageView))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        todaySplitLabel.text = "오늘도 100명이\n함께 공부하고있어요"
    }
    
    // main image tap gesture
    @objc func tapImageView() {
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceViewController = storyboard.instantiateViewController(withIdentifier: "attendanceView") as? AttendanceViewController else { return }
        navigationController?.pushViewController(attendanceViewController, animated: true)
    }
    
}

