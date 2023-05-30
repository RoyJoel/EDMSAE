//
//  EDOptionRequest.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/30.
//

import Foundation

class EDOptionRequest {
    static func delete(_ id: Int, completionHandler: @escaping ([Option]) -> Void) {
        EDNetWork.post("/option/delete", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.compactMap { Option(json: $0) })
        }
    }
    
    static func add(optionRequest: OptionRequest, completionHandler: @escaping ([Option]) -> Void) {
        EDNetWork.post("/option/add", dataParameters: optionRequest) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.compactMap { Option(json: $0) })
        }
    }
    static func update(optionRequest: OptionRequest, completionHandler: @escaping ([Option]) -> Void) {
        EDNetWork.post("/option/update", dataParameters: optionRequest) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.compactMap { Option(json: $0) })
        }
    }
}
