//
//  StringExtension.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation

extension String {
    func toPng() -> Data {
        let pngData = Data(base64Encoded: self)
        return pngData ?? Data()
    }
}
