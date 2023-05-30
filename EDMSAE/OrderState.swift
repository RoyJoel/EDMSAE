//
//  OrderState.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation

enum OrderState: Int, CaseIterable, Codable {
    case ToPay = 0
    case ToSend = 1
    case ToDelivery = 2
    case Done = 3
    case ToRefund = 4
    case ToReturn = 5
    case Refunded = 6
    
    var displayName: String {
        switch self {
        case .ToPay: return "待支付"
        case .ToSend: return "待发货"
        case .ToDelivery: return "待签收"
        case .Done: return "已完成"
        case .ToRefund: return "需退货"
        case .ToReturn: return "需退款"
        case .Refunded: return "已退款"
        }
    }
}
