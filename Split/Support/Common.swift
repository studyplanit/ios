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
    let tapPurple = UIColor(displayP3Red: 111/255, green: 67/255, blue: 233/255, alpha: 1)
    let purple = UIColor(displayP3Red: 86/255, green: 57/255, blue: 163/255, alpha: 1)
    let darkgray = UIColor(displayP3Red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
    let lightGray = UIColor(displayP3Red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
    let coralblue = UIColor(displayP3Red: 19/255, green: 129/255, blue: 199/255, alpha: 1)
    
    //에러 alert
    func errorAlert() -> UIAlertController{
        let alert = UIAlertController(title: "에러", message: "서버 접속에 실패했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    //반응형 폰트 함수
    func fontStyle(name: String, size: Float) -> UIFont {
        var responsiveSize: CGFloat
        switch size {
        case 22:
            responsiveSize = UIScreen.main.bounds.size.width * 0.075
        case 20:
            responsiveSize = UIScreen.main.bounds.size.width * 0.065
        case 18:
            responsiveSize = UIScreen.main.bounds.size.width * 0.055
        case 16:
            responsiveSize = UIScreen.main.bounds.size.width * 0.045
        case 14:
            responsiveSize = UIScreen.main.bounds.size.width * 0.035
        case 12:
            responsiveSize = UIScreen.main.bounds.size.width * 0.025
        default:
            responsiveSize = UIScreen.main.bounds.size.width * 0.01
        }
        return UIFont(name: name, size: responsiveSize)!
    }
}

