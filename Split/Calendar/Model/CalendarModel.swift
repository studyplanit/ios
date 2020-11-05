//
//  CalendarModel.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import Foundation

class SelectedDate {
    
    static let shared = SelectedDate()
    
    var date = "플랜 시간"
    
}

// 회원별로 플랜 가져오기 GET
struct UserPlan: Codable {
    let planLogID: Int
    let planName, type, startDate, endDate: String
    let setTime: String
    let needAuthNum, nowAuthNum: Int
    let planProgress: String

    enum CodingKeys: String, CodingKey {
        case planLogID = "planLogId"
        case planName, type, startDate, endDate, setTime, needAuthNum, nowAuthNum, planProgress
    }
}
