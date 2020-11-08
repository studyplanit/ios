//
//  UserPlanList.swift
//  Split
//
//  Created by uno on 2020/11/08.
//

import Foundation

class UserPlanList {
    static let shared = UserPlanList()
    
    var planLogID: Int?
    var planName, type, startDate, endDate: String?
    var setTime: String?
    var needAuthNum, nowAuthNum: Int?
    var planProgress: String?
    
}
