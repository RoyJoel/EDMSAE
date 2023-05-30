//
//  ToastNotification.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/30.
//

import Foundation



enum ToastNotification: String {
    case refreshCommoditiesData

    /// 通知名称
    var notificationName: NSNotification.Name {
        return NSNotification.Name(rawValue)
    }
}
