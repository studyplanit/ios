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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.string(forKey: "id") as Any)

        //타이틀 이미지넣기
        let image = UIImageView(image: UIImage(named: "nav_split"))
        image.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        navigationItem.titleView = image
        
        //오늘 다녀간 회원 반응형 텍스트
        todaySplitLabel.font = Common().fontStyle(name: "GmarketSansBold", size: 22)
        
        // main image tap gesture
        let imageViewTapGestureRecognizer = UITapGestureRecognizer()
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(imageViewTapGestureRecognizer)
        imageViewTapGestureRecognizer.addTarget(self, action: #selector(tapImageView))
    }
    
    //화면이 보여질때마다 오늘의 접속자 update
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
            if home.allUsersToday == 0 {
                self.todaySplitLabel.text = "오늘의 첫번째\n출첵커가 되어보세요"
            } else {
                self.todaySplitLabel.text = "오늘도 \(home.allUsersToday)명이\n함께 공부하고 있어요"
            }
        }
    }
    
    // main image tap gesture
    @objc func tapImageView() {
        let storyboard = UIStoryboard(name: "Attendance", bundle: Bundle.main)
        guard let attendanceViewController = storyboard.instantiateViewController(withIdentifier: "attendanceView") as? AttendanceViewController else { return }
        navigationController?.pushViewController(attendanceViewController, animated: true)
    }
}
