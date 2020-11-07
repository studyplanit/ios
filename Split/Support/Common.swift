//
//  Common.swift
//  Split
//
//  Created by najin on 2020/10/31.
//

import Foundation
import UIKit

class Common {
    //서버 URL
    let baseURL = "http://211.222.234.14:8898"
    //색상 set
    let lightpurple = UIColor(displayP3Red: 122/255, green: 113/255, blue: 230/255, alpha: 1)
    let purple = UIColor(displayP3Red: 171/255, green: 90/255, blue: 234/255, alpha: 1)
    let lightGray = UIColor(displayP3Red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
    let coralBlue = UIColor(displayP3Red: 79/255, green: 162/255, blue: 220/255, alpha: 1)
    
    //에러 alert
    func errorAlert() -> UIAlertController{
        let alert = UIAlertController(title: "에러", message: "서버 접속에 실패했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    //koPubDotumBole 반응형 폰트 지정
    let koPubDotumBold22 = UIFont(name:"KoPubDotumBold", size: UIScreen.main.bounds.size.width * 0.075)!
    let koPubDotumBold20 = UIFont(name:"KoPubDotumBold", size: UIScreen.main.bounds.size.width * 0.065)!
    let koPubDotumBold18 = UIFont(name:"KoPubDotumBold", size: UIScreen.main.bounds.size.width * 0.055)!
    let koPubDotumBold16 = UIFont(name:"KoPubDotumBold", size: UIScreen.main.bounds.size.width * 0.045)!
    let koPubDotumBold14 = UIFont(name:"KoPubDotumBold", size: UIScreen.main.bounds.size.width * 0.035)!
    let koPubDotumBold12 = UIFont(name:"KoPubDotumBold", size: UIScreen.main.bounds.size.width * 0.025)!
    
    //GmarketSansMedium 반응형 폰트 지정
    let GmarketSansMedium22 = UIFont(name:"GmarketSansMedium", size: UIScreen.main.bounds.size.width * 0.075)!
    let GmarketSansMedium20 = UIFont(name:"GmarketSansMedium", size: UIScreen.main.bounds.size.width * 0.065)!
    let GmarketSansMedium18 = UIFont(name:"GmarketSansMedium", size: UIScreen.main.bounds.size.width * 0.055)!
    let GmarketSansMedium16 = UIFont(name:"GmarketSansMedium", size: UIScreen.main.bounds.size.width * 0.045)!
    let GmarketSansMedium14 = UIFont(name:"GmarketSansMedium", size: UIScreen.main.bounds.size.width * 0.035)!
    let GmarketSansMedium12 = UIFont(name:"GmarketSansMedium", size: UIScreen.main.bounds.size.width * 0.025)!
}

