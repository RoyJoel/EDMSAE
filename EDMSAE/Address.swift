//
//  Address.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import SwiftyJSON

struct Address: Codable, Equatable {
    var id: Int
    var name: String
    var sex: Sex
    var phoneNumber: String
    var province: String
    var city: String
    var area: String
    var detailedAddress: String
    var isDefault: Bool

    init(id: Int, name: String, sex: Sex, phoneNumber: String, province: String, city: String, area: String, detailedAddress: String, isDefault: Bool) {
        self.id = id
        self.name = name
        self.sex = sex
        self.phoneNumber = phoneNumber
        self.province = province
        self.city = city
        self.area = area
        self.detailedAddress = detailedAddress
        self.isDefault = isDefault
    }

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        sex = Sex(rawValue: json["sex"].stringValue) ?? .Man
        phoneNumber = json["phoneNumber"].stringValue
        province = json["province"].stringValue
        city = json["city"].stringValue
        area = json["area"].stringValue
        detailedAddress = json["detailedAddress"].stringValue
        isDefault = json["isDefault"].boolValue
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let sexRawValue = dictionary["sex"] as? String,
            let sex = Sex(rawValue: sexRawValue),
            let phoneNumber = dictionary["phoneNumber"] as? String,
            let province = dictionary["province"] as? String,
            let city = dictionary["city"] as? String,
            let area = dictionary["area"] as? String,
            let detailedAddress = dictionary["detailedAddress"] as? String, let isDefault = dictionary["isDefault"] as? Bool else {
            return nil
        }

        self.init(id: id, name: name, sex: sex, phoneNumber: phoneNumber, province: province, city: city, area: area, detailedAddress: detailedAddress, isDefault: isDefault)
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "sex": sex.rawValue,
            "phoneNumber": phoneNumber,
            "province": province,
            "city": city,
            "area": area,
            "detailedAddress": detailedAddress,
            "isDefault": isDefault,
        ]
    }

    init() {
        self = Address(json: JSON())
    }

    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.sex == rhs.sex &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.province == rhs.province &&
            lhs.city == rhs.city &&
            lhs.area == rhs.area &&
        lhs.detailedAddress == rhs.detailedAddress && lhs.isDefault == rhs.isDefault
    }
}
