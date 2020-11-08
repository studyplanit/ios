//
//  AttendanceModel.swift
//  Split
//
//  Created by uno on 2020/11/05.
//

import Foundation

// QR 출석 인증 POST
struct QRAuthentication: Codable {
    let authenticate: Bool
    let message: String
}

// 스플릿존 아이디로 스플릿존 정보 GET
struct SplitZone: Codable {
    let name, code: String
}
