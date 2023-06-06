//
//  BillManagementViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/4/30.
//

import UIKit
import TMComponent
import SwiftyJSON
import JXSegmentedView
import Alamofire
import CryptoKit
import Toast_Swift
import LocalAuthentication
import Reachability




class BillManagementViewController: EDViewController {
    let allOrdersDS = ordersDataSource()
    let ordersToPayDS = ordersDataSource()
    let ordersToDeliveryDS = ordersDataSource()
    let ordersToConfirmDS = ordersDataSource()
    let ordersCompletedDS = ordersDataSource()
    let ordersToRefundDS = ordersDataSource()
    let ordersOnReturningDS = ordersDataSource()
    let ordersReturnedDS = ordersDataSource()

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

    lazy var ordersToRefundTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersOnReturningTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersReturnedTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单中心"
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
        ordersToRefundTableView.delegate = ordersToRefundDS
        ordersToRefundTableView.dataSource = ordersToRefundDS
        ordersToRefundTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToRefund")
        ordersOnReturningTableView.delegate = ordersOnReturningDS
        ordersOnReturningTableView.dataSource = ordersOnReturningDS
        ordersOnReturningTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersOnReturning")
        ordersReturnedTableView.delegate = ordersReturnedDS
        ordersReturnedTableView.dataSource = ordersReturnedDS
        ordersReturnedTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersReturned")
        refreshData()
    }

    func refreshData() {
        EDOrderRequest.getAll { orders in
            let filterOrders = orders
            self.allOrdersDS.orders = filterOrders
            self.allOrderTableView.reloadData()
            self.ordersToPayDS.orders = filterOrders.filter { $0.state == .ToPay }
            self.ordersToPayTableView.reloadData()
            self.ordersToDeliveryDS.orders = filterOrders.filter { $0.state == .ToSend }
            self.ordersToDeliveryTableView.reloadData()
            self.ordersToConfirmDS.orders = filterOrders.filter { $0.state == .ToDelivery }
            self.ordersToConfirmTableView.reloadData()
            self.ordersCompletedDS.orders = filterOrders.filter { $0.state == .Done }
            self.ordersCompletedTableView.reloadData()
            self.ordersToRefundDS.orders = filterOrders.filter { $0.state == .ToRefund }
            self.ordersToRefundTableView.reloadData()
            self.ordersOnReturningDS.orders = filterOrders.filter { $0.state == .ToReturn }
            self.ordersOnReturningTableView.reloadData()
            self.ordersReturnedDS.orders = filterOrders.filter { $0.state == .Refunded }
            self.ordersReturnedTableView.reloadData()
        }
    }
}

class ordersDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var orders: [Order] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        orders.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDUserOrderCell()
        cell.setupEvent(order: orders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EDOrderDetailViewController()
        vc.order = orders[indexPath.row]
        if let parentVC = tableView.getParentViewController() {
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        188
    }
}

extension BillManagementViewController: JXSegmentedListContainerViewDataSource {
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
        case 5:
            ordersToRefundTableView.reloadData()
            return ordersToRefundTableView
        case 6:
            ordersOnReturningTableView.reloadData()
            return ordersOnReturningTableView
        default:
            ordersReturnedTableView.reloadData()
            return ordersReturnedTableView
        }
    }
}

extension BillManagementViewController: JXSegmentedViewDelegate {
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







































//let com1 = Commodity(id: 0, images: ["Aus", "JasonZhang", "Aus", "JasonZhang", "Aus"], name: "DUNLOP邓禄普澳网AO官方比赛网球", intro: "澳大利亚网球公开赛官方指定用球 \n Wilson 公司全力打造的比赛用球！为大满贯比赛严格要求而设计的独特的网球,有OPTI-VIS增强视觉效果处理,更加清晰可见,更添专业品质。\n 具有Nano Play纳米科技，耐打性佳、弹性好，外表增添了加亮材料，大大增加了比赛或训练中捕球的机会性、可视性。", price: 123, limit: 9, orders: 2, cag: 1, state: .selling)
//
//let com2 = Commodity(id: 0, images: ["Wim"], name: "Slazenger史莱辛格网球 温网比赛官方用球", intro: "澳大利亚网球公开赛官方指定用球；Wilson 公司全力打造的比赛用球！为大满贯比赛严格要求而设计的独特的网球,有OPTI-VIS增强视觉效果处理,更加清晰可见,更添专业品质。具有Nano Play纳米科技，耐打性佳、弹性好，外表增添了加亮材料，大大增加了比赛或训练中捕球的机会性、可视性。", price: 123, limit: 1, orders: 2, cag: 2, state: .selling)
//
//let com: [Commodity] = [com1, com2]

//let bill1 = Bill(id: 1, com: com1, quantity: 2, option: 0)
//let bill2 = Bill(id: 2, com: com2, quantity: 3, option: 0)
//let address1 = Address(id: 1, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "陕西省", city: "西安市", area: "灞桥区", detailedAddress: "西安邮电大学雁塔校区")
//let address2 = Address(id: 1, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "陕西省", city: "西安市", area: "雁塔区", detailedAddress: "西安邮电大学雁塔校区")
//let address3 = Address(id: 1, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "陕西省", city: "西安市", area: "新城区", detailedAddress: "西安邮电大学雁塔校区")
//var addresss = [address1, address2, address3]
//
//let order: Order = Order(id: 1, bills: [bill1, bill2, bill2], shippingAddress: address1, deliveryAddress: address1, payment: .WeChat, totalPrice: 984.00, createdTime: 1_682_329_527, payedTime: 1_682_415_927, completedTime: 1_682_588_727, state: .Done)
//
//let order1: Order = Order(id: 1, bills: [bill1, bill2, bill2], shippingAddress: address1, deliveryAddress: address1, payment: .WeChat, totalPrice: 984.00, createdTime: 1_682_329_527, payedTime: nil, completedTime: nil, state: .ToPay)

//let ordersa: [Order] = [order, order, order1]




































