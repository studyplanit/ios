//
//  PlanAPI.swift
//  Split
//
//  Created by uno on 2020/11/05.
//

import Foundation

struct PlanAPIConstant {
    static let baseURL = "http://211.222.234.14:8898"

    /* 플랜 리스트 */
    static let planListURL = baseURL + "/plan/get.do"
    
    /* 플랜 등록 */
    static let planInsertURL = baseURL + "/plan/insert.do"
    
    /* 유저별 전체 플랜 */
    static let userTotalPlanURL = baseURL + "/member/getMy.do"
    
    /* 유저별 오늘 플랜 */
    static let userTodayPlanURL = baseURL + "/member/getMy.group"
    
    /* 회원별 플랜 삭제 */
    static let userPlanDeleteURL = baseURL + "/plan/delete.do"
    
    /* QR 인증 */
    static let qrAuthURL = baseURL + "/plan/qr.auth"
    
    /* 스플릿존 정보 */
    static let splitZoneInfoURL = baseURL + "/split/get/detail"
}
