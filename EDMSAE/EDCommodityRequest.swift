//
//  EDCommodityRequest.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation

class EDCommodityRequest {
    static func getAll(completionHandler: @escaping ([Commodity]) -> Void) {
        EDNetWork.get("/commodity/getAll") { json, _ in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.compactMap { Commodity(json: $0) })
        }
    }
    static func delete(_ id: Int, completionHandler: @escaping ([Commodity]) -> Void) {
        EDNetWork.post("/commodity/delete", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.compactMap { Commodity(json: $0) })
        }
    }
    
    static func add(commodity: Commodity, completionHandler: @escaping ([Commodity]) -> Void) {
        EDNetWork.post("/commodity/add", dataParameters: commodity) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.compactMap { Commodity(json: $0) })
        }
    }
    static func update(commodity: Commodity, completionHandler: @escaping (Commodity) -> Void) {
        EDNetWork.post("/commodity/update", dataParameters: commodity) { json in
            guard let json = json else {
                return
            }
            completionHandler( Commodity(json: json) )
        }
    }
}
