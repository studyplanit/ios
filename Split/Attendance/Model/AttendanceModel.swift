//
//  AttendanceModel.swift
//  Split
//
//  Created by uno on 2020/11/05.
//

import Foundation

// QR인증 응답
struct QRAuthResponse: Codable {
    let authenticate: Int
    let message: String
    let name: String
    let code: String
}
