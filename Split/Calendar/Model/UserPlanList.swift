//
//  UserPlanList.swift
//  Split
//
//  Created by uno on 2020/11/08.
//

import Foundation

// 유저별 전체 플랜 목록
class UserPlanList {
    static let shared = UserPlanList()
    
    var planLogID: Int?
    var planName, type, startDate, endDate: String?
    var setTime: String?
    var needAuthNum, nowAuthNum: Int?
    var planProgress: String?
    
}

// 유저별 오늘 플랜 목록
class UserTodayPlanList {
    static let shared = UserTodayPlanList()
    
    var planLogID: Int?
    var planName, type, startDate, endDate: String?
    var setTime: String?
    var needAuthNum, nowAuthNum: Int?
    var planProgress: String?
    
}
