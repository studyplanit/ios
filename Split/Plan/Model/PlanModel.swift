//
//  PlanModel.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import Foundation

// 플랜리스트 GET
struct PlanList: Codable {
    let id: Int
    let name, type: String
    let need: Int
    let imgPath: String?
    let accNumber: Int
}

// 유저가 플랜 등록하기 POST Response
struct PlanRegistration: Codable {
    let planLogID: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case planLogID = "planLogId"
        case message
    }
}

class SubscriptionPlan {
    
    static let shared = SubscriptionPlan()
    
    var member_id: String?
    var plan_id: String?
    var startDate: String?
    var endDate: String?
    var setTime: String?
}
