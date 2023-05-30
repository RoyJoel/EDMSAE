//
//  TMDataConvert.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation

class TMDataConvert {
    static func getPriceRange(with options: [Option]) -> (Double, Double) {
        var max = Double(Int.min)
        var min = Double(Int.max)
        
        for option in options {
            if option.price > max {
                max = option.price
            }
            if option.price < min {
                min = option.price
            }
        }
        
        return (min, max)
    }
    
    static func getTotalInventory(with options: [Option]) -> Int {
        var inventory = 0
        for option in options {
            inventory += option.inventory
        }
        return inventory
    }
}
