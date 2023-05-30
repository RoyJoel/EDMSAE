//
//  TMPlayerRequest.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation


class TMPlayerRequest {
    static func searchPlayer(loginName: String, completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": loginName,
        ]
        EDNetWork.post("/player/search", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }
}



