//
//  Express.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/6/4.
//

import Foundation

struct Express {
    var id: Int
    var de: Address
    var sh: Address
    var payment: payType
    var trace: [Trace]
    var price: Double
    var state: OrderState
    var commoType: String
    var createdTime: TimeInterval
    var payedTime: TimeInterval?
    var completedTime: TimeInterval?

    init(id: Int, de: Address, sh: Address, payment: payType, price: Double, state: OrderState, commoType: String, createdTime: TimeInterval, payedTime: TimeInterval? = nil, completedTime: TimeInterval? = nil, trace: [Trace]) {
        self.id = id
        self.de = de
        self.sh = sh
        self.payment = payment
        self.price = price
        self.state = state
        self.commoType = commoType
        self.createdTime = createdTime
        self.payedTime = payedTime
        self.completedTime = completedTime
        self.trace = trace
    }

    init() {
        self = Express(id: 0, de: address1, sh: address2, payment: .aliPayOnline, price: 12, state: .ToPay, commoType: "行李", createdTime: Date().timeIntervalSince1970, trace: [])
    }
}

struct pointRecord {
    var date: TimeInterval
    var type: RecordType
    var num: Int
}

enum RecordType: String {
    case express = "快递下单"
    case clockIn = "打卡"
    case exchange = "积分兑换"
}

enum payType: String, CaseIterable, Codable {
    case cashOnDelivery
    case aliPayOnline
    case weChatOnline

    var index: Int {
        switch self {
        case .cashOnDelivery:
            return 0
        case .aliPayOnline:
            return 1
        case .weChatOnline:
            return 2
        }
    }

    var displayName: String {
        switch self {
        case .cashOnDelivery:
            return "货到付款"
        case .weChatOnline:
            return "微信支付"
        case .aliPayOnline:
            return "支付宝"
        }
    }

    init(displayName: String) {
        switch displayName {
        case "支付宝":
            self = .aliPayOnline
        case "微信支付":
            self = .weChatOnline
        default:
            self = .cashOnDelivery
        }
    }
}

struct Trace {
    let acceptTime: String
    let acceptStation: String
    let location: String
    let action: String
}
