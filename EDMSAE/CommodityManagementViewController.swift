//
//  CommodityManagementViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit
import JXSegmentedView
import TABAnimated

class CommodityManagementViewController: EDViewController {
    let allOrdersDS = commoditiesDataSource()
    let commoditiesToPayDS = commoditiesDataSource()
    let commoditiesToDeliveryDS = commoditiesDataSource()
    let commoditiesToConfirmDS = commoditiesDataSource()
    let commoditiesCompletedDS = commoditiesDataSource()
    let commoditiesToRefundDS = commoditiesDataSource()
    let commoditiesOnReturningDS = commoditiesDataSource()
    let commoditiesReturnedDS = commoditiesDataSource()
    
    var commodities: [Commodity] = []
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentTMView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()
    
    lazy var orderBackgroundView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    lazy var allOrderTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()
    
    lazy var commoditiesToPayTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()
    
    lazy var commoditiesToDeliveryTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()
    
    lazy var commoditiesToConfirmTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()
    
    lazy var commoditiesCompletedTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()
    
    lazy var commoditiesToRefundTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()
    
    lazy var commoditiesOnReturningTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()
    
    lazy var commoditiesReturnedTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundGray")
        let titles = ["全部订单"] + CommodityState.allCases.compactMap { $0.displayName }

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
        view.insertSubview(orderBackgroundView, aboveSubview: listContainerView)
        orderBackgroundView.addSubview(confirmBtn)

        segmentTMView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(48)
        }
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentTMView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        orderBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(208)
        }

        confirmBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-98)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(50)
        }
        
        orderBackgroundView.backgroundColor = UIColor(named: "ComponentBackground")
        
        self.confirmBtn.setTitle("添加商品", for: .normal)
        self.confirmBtn.backgroundColor = UIColor(named: "TennisBlur")
        self.confirmBtn.setTitleColor(.black, for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(self.addConfig), for: .touchDown)
        self.confirmBtn.setCorner(radii: 15)
        self.allOrderTableView.delegate = self.allOrdersDS
        self.allOrdersDS.commodities = commodities
        self.allOrderTableView.dataSource = self.allOrdersDS
        self.allOrderTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "allOrders")
        
        self.commoditiesToPayTableView.delegate = self.commoditiesToPayDS
        self.commoditiesToPayDS.commodities = commodities.filter{ $0.state == .ToArrived }
        self.commoditiesToPayTableView.dataSource = self.commoditiesToPayDS
        self.commoditiesToPayTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "commoditiesToPay")
        
        self.commoditiesToDeliveryTableView.delegate = self.commoditiesToDeliveryDS
        self.commoditiesToDeliveryDS.commodities = commodities.filter { $0.state == .selling }
        self.commoditiesToDeliveryTableView.dataSource = self.commoditiesToDeliveryDS
        self.commoditiesToDeliveryTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "commoditiesToDelivery")
        self.commoditiesToConfirmTableView.delegate = self.commoditiesToConfirmDS
        self.commoditiesToConfirmDS.commodities = commodities.filter { $0.state == .Banned }
        self.commoditiesToConfirmTableView.dataSource = self.commoditiesToConfirmDS
        self.commoditiesToConfirmTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "commoditiesToConfirm")
        
        allOrderTableView.tab_startAnimation {
            EDCommodityRequest.getAll { commodities in
                self.allOrdersDS.commodities = commodities
                self.allOrderTableView.reloadData()
                
                self.commoditiesToPayDS.commodities = commodities.filter{ $0.state == .ToArrived }
                self.commoditiesToPayTableView.reloadData()
                
                self.commoditiesToDeliveryDS.commodities = commodities.filter { $0.state == .selling }
                self.commoditiesToDeliveryTableView.reloadData()
                
                self.commoditiesToConfirmDS.commodities = commodities.filter { $0.state == .Banned }
                self.commoditiesToConfirmTableView.reloadData()
                self.allOrderTableView.tab_endAnimation()
            }
        }
    }
    
    @objc func addConfig() {
        let vc = EDCommodityEditingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

class commoditiesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var commodities: [Commodity] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        commodities.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDCommodityCell()
        cell.setupEvent(com: commodities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EDCommodityEditingViewController()
        vc.com = commodities[indexPath.row]
        if let parentVC = tableView.getParentViewController() {
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        188
    }
}

extension CommodityManagementViewController: JXSegmentedListContainerViewDataSource {
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
            commoditiesToPayTableView.reloadData()
            return commoditiesToPayTableView
        case 2:
            commoditiesToDeliveryTableView.reloadData()
            return commoditiesToDeliveryTableView
        case 3:
            commoditiesToConfirmTableView.reloadData()
            return commoditiesToConfirmTableView
        case 4:
            commoditiesCompletedTableView.reloadData()
            return commoditiesCompletedTableView
        case 5:
            commoditiesToRefundTableView.reloadData()
            return commoditiesToRefundTableView
        case 6:
            commoditiesOnReturningTableView.reloadData()
            return commoditiesOnReturningTableView
        default:
            commoditiesReturnedTableView.reloadData()
            return commoditiesReturnedTableView
        }
    }
}

extension CommodityManagementViewController: JXSegmentedViewDelegate {
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
