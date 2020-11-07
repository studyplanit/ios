//
//  PlanAPI.swift
//  Split
//
//  Created by uno on 2020/11/05.
//

import Foundation

struct PlanAPIConstant {
    // 전역 변수로 사용할 수 있게 APIConstants 선언하여 사용
    static let baseURL = "http://211.222.234.14:8898"

    /* 플랜 리스트 */
    static let planListURL = baseURL + "/plan/get.do"
    
    /* 플랜 등록 */
    static let planInsertURL = baseURL + "/plan/insert.do"
    
    /* 회원별 플랜 */
    static let userPlanURL = baseURL + "/member/getMy.do"
    
    /* QR 인증 */
    static let qrAuthURL = baseURL + "/plan/qr.auth"
    
    /* 스플릿존 정보 */
    static let splitZoneInfoURL = baseURL + "/split/get/detail"
}
