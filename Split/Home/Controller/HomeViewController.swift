//
//  HomeViewController.swift
//  Split
//
//  Created by najin on 2020/10/16.
//

import UIKit
import AVFoundation
import QRCodeReader
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var todaySplitLabel: UILabel!
    
    var allUsersToday = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //타이틀 이미지넣기
        let image = UIImageView(image: UIImage(named: "nav_split"))
        image.contentMode = UIView.ContentMode.scaleAspectFit
        navigationItem.titleView = image
        
        //오늘 다녀간 회원 반응형 텍스트
        todaySplitLabel.font = Common().GmarketSansMedium22
        
        // main image tap gesture
        let imageViewTapGestureRecognizer = UITapGestureRecognizer()
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(imageViewTapGestureRecognizer)
        imageViewTapGestureRecognizer.addTarget(self, action: #selector(tapImageView))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let URL = Common().baseURL+"/home/today/get.home"
        let alamo = AF.request(URL, method: .get).validate(statusCode: 200..<300)
        struct Home: Decodable {
            var allUsersToday: Int
            var allUsersAtMoment: Int
            var authUsersAtMoment: Int
        }
        
        alamo.responseDecodable(of: Home.self) { (response) in
            guard let home = response.value else { return }
            self.allUsersToday = home.allUsersToday
        }
        if allUsersToday == 0 {
            todaySplitLabel.text = "0명일때 멘트?!!"
        } else {
            todaySplitLabel.text = "오늘도 \(allUsersToday)명이\n함께 공부하고있어요"
        }
    }
    
    // main image tap gesture
    @objc func tapImageView() {
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceViewController = storyboard.instantiateViewController(withIdentifier: "attendanceView") as? AttendanceViewController else { return }
        navigationController?.pushViewController(attendanceViewController, animated: true)
    }
    
}

