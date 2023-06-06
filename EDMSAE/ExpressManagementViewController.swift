//
//  ExpressManagementViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit
import JXSegmentedView

class ExpressManagementViewController: UIViewController {
    let allOrdersDS = expressesDataSource()
    let ordersToPayDS = expressesDataSource()
    let ordersToDeliveryDS = expressesDataSource()
    let ordersToConfirmDS = expressesDataSource()
    let ordersCompletedDS = expressesDataSource()

    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentTMView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    lazy var allOrderTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersToPayTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersToDeliveryTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersToConfirmTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersCompletedTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundGray")
        let titles = ["全部订单"] + OrderState.allCases.compactMap { $0.displayName }

        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalColor = UIColor(named: "ContentBackground") ?? .black
        dataSource.titleSelectedColor = .black
        dataSource.titles = titles
        segmentedDataSource = dataSource
        // 配置指示器
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorColor = UIColor(named: "TennisBlur") ?? .blue
        segmentTMView.indicators = [indicator]

        segmentTMView.dataSource = segmentedDataSource
        segmentTMView.delegate = self
        segmentTMView.listContainer = listContainerView

        view.addSubview(segmentTMView)
        view.addSubview(listContainerView)

        segmentTMView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(103)
        }
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentTMView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        allOrderTableView.delegate = allOrdersDS
        allOrderTableView.dataSource = allOrdersDS
        allOrderTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "allOrders")
        ordersToPayTableView.delegate = ordersToPayDS
        ordersToPayTableView.dataSource = ordersToPayDS
        ordersToPayTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToPay")

        ordersToDeliveryTableView.delegate = ordersToDeliveryDS
        ordersToDeliveryTableView.dataSource = ordersToDeliveryDS
        ordersToDeliveryTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToDelivery")
        ordersToConfirmTableView.delegate = ordersToConfirmDS
        ordersToConfirmTableView.dataSource = ordersToConfirmDS
        ordersToConfirmTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToConfirm")
        ordersCompletedTableView.delegate = ordersCompletedDS
        ordersCompletedTableView.dataSource = ordersCompletedDS
        ordersCompletedTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersCompleted")
        refreshData()
    }

    func refreshData() {
        let filterOrders = expresses
        allOrdersDS.orders = filterOrders
        allOrderTableView.reloadData()
        ordersToPayDS.orders = filterOrders.filter { $0.state == .ToPay }
        ordersToPayTableView.reloadData()
        ordersToDeliveryDS.orders = filterOrders.filter { $0.state == .ToSend }
        ordersToDeliveryTableView.reloadData()
        ordersToConfirmDS.orders = filterOrders.filter { $0.state == .ToDelivery }
        ordersToConfirmTableView.reloadData()
        ordersCompletedDS.orders = filterOrders.filter { $0.state == .Done }
        ordersCompletedTableView.reloadData()
    }
}

class expressesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var orders: [Express] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        orders.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDUserExpressCell()
        cell.setupEvent(express: orders[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EDExpressDetailViewController()
        vc.express = orders[indexPath.row]
        if let parentVC = tableView.getParentViewController() {
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        170
    }
}

extension ExpressManagementViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentTMView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt: Int) -> JXSegmentedListContainerViewListDelegate {
        switch initListAt {
        case 0:
            allOrderTableView.reloadData()
            return allOrderTableView
        case 1:
            ordersToPayTableView.reloadData()
            return ordersToPayTableView
        case 2:
            ordersToDeliveryTableView.reloadData()
            return ordersToDeliveryTableView
        case 3:
            ordersToConfirmTableView.reloadData()
            return ordersToConfirmTableView
        case 4:
            ordersCompletedTableView.reloadData()
            return ordersCompletedTableView
        default:
            allOrderTableView.reloadData()
            return allOrderTableView
        }
    }
}

extension ExpressManagementViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentTMView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            // 先更新数据源的数据

            dotDataSource.dotStates[index] = false
            // 再调用reloadItem(at: index)
            segmentTMView.reloadItem(at: index)
        }
    }

    func segmentedView(_: JXSegmentedView, didScrollSelectedItemAt _: Int) {}
}
