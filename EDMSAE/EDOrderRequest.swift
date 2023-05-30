//
//  EDOrderRequest.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation

class EDOrderRequest {
    static func getAll(completionHandler: @escaping ([Order]) -> Void) {
        EDNetWork.get("/order/getAll") { json, _ in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Order(json: $0) })
        }
    }
}
