//
//  CalendarAPI.swift
//  Split
//
//  Created by uno on 2020/11/05.
//

import Foundation

struct CalendarAPIConstant {
    // 전역 변수로 사용할 수 있게 APIConstants 선언하여 사용
    static let baseURL = "http://211.222.234.14:8898"
    
    /* 회원별 플랜 */
    static let userPlanURL = baseURL + "/member/getMy.do"
}
