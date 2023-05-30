//
//  User.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import SwiftyJSON

struct User: Codable, Equatable {
    var id: Int
    var loginName: String
    var password: String
    var name: String
    var icon: String
    var sex: Sex
    var token: String

    init(id: Int, loginName: String, password: String, name: String, icon: String, sex: Sex, token: String) {
        self.id = id
        self.loginName = loginName
        self.password = password
        self.name = name
        self.icon = icon
        self.sex = sex
        self.token = token
    }

    init(json: JSON) {
        id = json["id"].intValue
        loginName = json["loginName"].stringValue
        password = json["password"].stringValue
        name = json["name"].stringValue
        icon = json["icon"].stringValue
        sex = Sex(rawValue: json["sex"].stringValue) ?? .Man
        token = json["token"].stringValue
    }

    init() {
        self = User(json: JSON())
    }

    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "loginName": loginName,
            "password": password,
            "name": name,
            "icon": icon,
            "sex": sex.rawValue,
            "token": token,
        ]

        return dict
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let loginName = dictionary["loginName"] as? String,
            let password = dictionary["password"] as? String,
            let name = dictionary["name"] as? String,
            let icon = dictionary["icon"] as? String,
            let sexRawValue = dictionary["sex"] as? String,
            let sex = Sex(rawValue: sexRawValue),
            let token = dictionary["token"] as? String
        else {
            return nil
        }

        self = User(id: id, loginName: loginName, password: password, name: name, icon: icon, sex: sex, token: token)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
            lhs.loginName == rhs.loginName &&
            lhs.password == rhs.password &&
            lhs.name == rhs.name &&
            lhs.icon == rhs.icon &&
            lhs.sex == rhs.sex
    }
}

struct signupResponse: Codable {
    var user: User
    var res: Bool
}

struct UserSignUpResponse: Codable {
    var code: Int
    var count: Int
    var data: signupResponse
}

struct UserResponse: Codable {
    var code: Int
    var count: Int
    var data: User
}
