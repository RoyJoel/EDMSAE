//
//  testData.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/6/4.
//

import Foundation

var trace1 = Trace(acceptTime: "2023 05-24 18:29 星期三", acceptStation: "", location: "", action: "【西安市】已签收,签收人是本人,感谢使用安能,期待再次为您服务")

var trace2 = Trace(acceptTime: "2023 05-24 18:27", acceptStation: "", location: "", action: "【西安市】雁塔派件员:何渭中13516829024正在为您派件")

var trace3 = Trace(acceptTime: "2023 05-23 21:45", acceptStation: "", location: "", action: " 【西安市】西安分拨中心快件已到达")

var trace4 = Trace(acceptTime: "2023 05-23 01:28 星期二", acceptStation: "", location: "", action: "【郑州市】郑州分拨中心快件已发出")

var expresses: [Express] = [Express(id: 20190901, de: address2, sh: address1, payment: .aliPayOnline, price: 12, state: .ToDelivery, commoType: "行李", createdTime: Date().timeIntervalSince1970, trace: [trace4, trace3, trace2]), Express(id: 20230607, de: address1, sh: address2, payment: .aliPayOnline, price: 12, state: .ToSend, commoType: "包裹", createdTime: Date().timeIntervalSince1970, trace: [trace4, trace3, trace2, trace1]), Express(id: 20230719, de: address2, sh: address3, payment: .aliPayOnline, price: 12, state: .ToSend, commoType: "家具", createdTime: Date().timeIntervalSince1970, trace: [trace4, trace3, trace2, trace1])]
let pointRecord1 = pointRecord(date: Date().timeIntervalSince1970, type: .clockIn, num: 6)
let pointRecord2 = pointRecord(date: Date().timeIntervalSince1970, type: .express, num: 40)
let pointRecord3 = pointRecord(date: Date().timeIntervalSince1970, type: .exchange, num: 6)
var records: [pointRecord] = [pointRecord1, pointRecord2, pointRecord3]

let points = 138
let address1 = Address(id: 1, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "陕西省", city: "西安市", area: "雁塔区", detailedAddress: "西安邮电大学雁塔校区", isDefault: true)
let address2 = Address(id: 2, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "北京市", city: "北京市", area: "顺义区", detailedAddress: "港鑫家园", isDefault: false)
let address3 = Address(id: 3, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "广东省", city: "广州市", area: "天河区", detailedAddress: "羊城创意产业园3-02荔枝", isDefault: false)
