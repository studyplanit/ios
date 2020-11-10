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

// 회원별 전체 플랜 모델
struct UserTotalPlan: Codable {
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

// 회원별 오늘 플랜 모델
struct UserTodayPlan: Codable {
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
