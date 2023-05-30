//
//  EDUserOrderTableView.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit
import JXSegmentedView

class EDUserOrderTableView: UITableView {}

extension EDUserOrderTableView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
