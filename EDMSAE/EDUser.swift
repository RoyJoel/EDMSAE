//
//  EDUser.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import CryptoKit
import Alamofire
import UIKit

class EDUser {
    // 未登录时为默认信息
    static var user = User()

    static func signIn(completionHandler: @escaping (User?, Error?) -> Void) {
        // 将要加密的字符串连接在一起
        let password = user.password

        // 计算 SHA256 哈希值
        if let data = password.data(using: .utf8) {
            let hash = SHA256.hash(data: data)
            let hashString = hash.map { String(format: "%02x", $0) }.joined()

            let para = [
                "loginName": user.loginName,
                "password": hashString,
            ]
            EDNetWork.post("/user/signIn", dataParameters: para) { json in
                guard let json = json else {
                    completionHandler(nil, EDNetWorkError.netError("账号或密码错误"))
                    return
                }
                completionHandler(User(json: json), nil)
            }
        }
    }

    static func signUp(completionHandler: @escaping (String?, Error?) -> Void) {
        EDNetWork.post("/user/signUp", dataParameters: EDUser.user, responseBindingType: UserSignUpResponse.self) { response in
            guard let res = response else {
                completionHandler(nil, EDNetWorkError.netError("账号或密码错误"))
                return
            }
            EDUser.user = res.data.user
            completionHandler(EDUser.user.token, nil)
        }
    }

    static func resetPassword(completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": user.loginName,
            "password": user.password,
        ]
        EDNetWork.post("/user/resetPassword", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func updateInfo(completionHandler: @escaping (User?) -> Void) {
        EDNetWork.post("/user/update", dataParameters: EDUser.user) { json in
            guard let json = json else {
                completionHandler(nil)
                return
            }
            EDUser.user = User(json: json)
            completionHandler(EDUser.user)
        }
    }

    static func auth(token: String, completionHandler: @escaping (String?, String?, Error?) -> Void) {
        let headers: HTTPHeaders = ["Authorization": token]
        EDNetWork.get("/auth", headers: headers) { json, error in
            guard error == nil else {
                completionHandler(nil, nil, error)
                return
            }
            guard let json = json else {
                completionHandler(nil, nil, nil)
                return
            }
            completionHandler(json["loginName"].stringValue, json["password"].stringValue, nil)
        }
    }

    static func getDeviceID() -> String? {
        if let uuid = UIDevice.current.identifierForVendor {
            return uuid.uuidString
        }
        return nil
    }
}
