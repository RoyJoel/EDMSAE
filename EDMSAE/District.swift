//
//  District.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import SwiftyJSON

struct District: Codable {
    let citycode: [String]
    let adcode: String
    let name: String
    let center: String
    let level: AddressLevel
    let districts: [District]?

    init(json: JSON) {
        citycode = json["citycode"].arrayValue.compactMap { $0.stringValue }
        adcode = json["adcode"].stringValue
        name = json["name"].stringValue
        center = json["center"].stringValue
        level = AddressLevel(rawValue: json["level"].stringValue) ?? .district
        districts = json["districts"].arrayValue.compactMap { District(json: $0) }
    }
}
