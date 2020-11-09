//
//  AttendanceModel.swift
//  Split
//
//  Created by uno on 2020/11/05.
//

import Foundation

// QR 출석 인증
struct QRAuthentication: Codable {
    let authenticate: Bool
    let message: String
}

// 스플릿존 아이디로 스플릿존 정보
struct SplitZone: Codable {
    let name, code: String
}

// QR인증 응답
struct QRAuthResponse: Codable {
    let authenticate: Int
    let message: String
}
