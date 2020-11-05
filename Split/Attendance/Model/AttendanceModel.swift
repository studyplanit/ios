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

