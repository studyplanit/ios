//
//  Map.swift
//  Split
//
//  Created by najin on 2020/11/04.
//

import Foundation

struct MapVO: Codable {
    var planetId: Int
    var planetCode: String
    var planetName: String
    var address: String
    var startTime: String
    var endTime: String
    var holiday: String
    var lat: Double
    var lng: Double
    var allVisit: Int
    var todayVisit: Int
//    var cafeImage: null,
//    var menuList: null
}
