//
//  Member.swift
//  Split
//
//  Created by najin on 2020/10/14.
//

import Foundation

class MemberVO: Decodable, Encodable {
    static let shared = MemberVO()
    
    var id: Int?
    var nickname: String?
    var phone: String?
    var mail: String?
    var point: Int?
}



