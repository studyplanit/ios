//
//  PlanModel.swift
//  Split
//
//  Created by uno on 2020/10/29.
//

import Foundation

class PlanModel {
    
    struct Plan {
        let plnaTitle: String?
//        let planCategory: Int?
        let planPeriod: Double?
//        var startDate: String?
//        var endDate: String?
    }
    
    static var challengePlans: [Plan] = [
        Plan(plnaTitle: "출석 챌린지 플랜 - 1일", planPeriod: 1),
        Plan(plnaTitle: "출석 챌린지 플랜 - 7일", planPeriod: 7),
        Plan(plnaTitle: "출석 챌린지 플랜 - 15일", planPeriod: 15),
        Plan(plnaTitle: "출석 챌린지 플랜 - 30일", planPeriod: 30)
    ]
    
    static var eventPlans: [Plan] = [
        Plan(plnaTitle: "중간고사 출석 플랜", planPeriod: 14),
        Plan(plnaTitle: "기말고사 출석 플랜", planPeriod: 14),
        Plan(plnaTitle: "여름방학 출석 플랜", planPeriod: 14),
        Plan(plnaTitle: "겨울방학 출석 플랜", planPeriod: 14)
    ]
    
    static var plans: [[Plan]] = [
        challengePlans,
        eventPlans
    ]
    
}
