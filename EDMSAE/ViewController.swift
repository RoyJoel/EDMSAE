//
//  ViewController.swift
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

class ViewController: EDViewController {
    let allOrdersDS = ordersDataSource()
    let ordersToPayDS = ordersDataSource()
    let ordersToDeliveryDS = ordersDataSource()
    let ordersToConfirmDS = ordersDataSource()
    let ordersCompletedDS = ordersDataSource()
    let ordersToRefundDS = ordersDataSource()
    let ordersOnReturningDS = ordersDataSource()
    let ordersReturnedDS = ordersDataSource()
    
    var orders: [Order] = ordersa
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
            make.top.equalToSuperview().offset(48)
        }
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentTMView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        allOrderTableView.delegate = allOrdersDS
        allOrdersDS.orders = orders
        allOrderTableView.dataSource = allOrdersDS
        allOrderTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "allOrders")
        
        ordersToPayTableView.delegate = ordersToPayDS
        ordersToPayDS.orders = orders.filter{ $0.state == .ToPay }
        ordersToPayTableView.dataSource = ordersToPayDS
        ordersToPayTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToPay")
        
        ordersToDeliveryTableView.delegate = ordersToDeliveryDS
        ordersToDeliveryDS.orders = orders.filter { $0.state == .ToSend }
        ordersToDeliveryTableView.dataSource = ordersToDeliveryDS
        ordersToDeliveryTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToDelivery")
        ordersToConfirmTableView.delegate = ordersToConfirmDS
        ordersToConfirmDS.orders = orders.filter { $0.state == .ToDelivery }
        ordersToConfirmTableView.dataSource = ordersToConfirmDS
        ordersToConfirmTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToConfirm")
        ordersCompletedTableView.delegate = ordersCompletedDS
        ordersCompletedDS.orders = orders.filter { $0.state == .Done }
        ordersCompletedTableView.dataSource = ordersCompletedDS
        ordersCompletedTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersCompleted")
        ordersToRefundTableView.delegate = ordersToRefundDS
        ordersToRefundDS.orders = orders.filter { $0.state == .ToRefund }
        ordersToRefundTableView.dataSource = ordersToRefundDS
        ordersToRefundTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToRefund")
        ordersOnReturningTableView.delegate = ordersOnReturningDS
        ordersOnReturningDS.orders = orders.filter { $0.state == .ToReturn }
        ordersOnReturningTableView.dataSource = ordersOnReturningDS
        ordersOnReturningTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersOnReturning")
        ordersReturnedTableView.delegate = ordersReturnedDS
        ordersReturnedDS.orders = orders.filter { $0.state == .Refunded }
        ordersReturnedTableView.dataSource = ordersReturnedDS
        ordersReturnedTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersReturned")
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

extension ViewController: JXSegmentedListContainerViewDataSource {
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

extension ViewController: JXSegmentedViewDelegate {
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

class EDUserOrderTableView: UITableView {}

extension EDUserOrderTableView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}

class EDUserOrderCell: UITableViewCell {
    lazy var orderLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var BillingView: EDBillingView = {
        let view = EDBillingView()
        return view
    }()

    lazy var paymentAndPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(orderLabel)
        contentView.addSubview(BillingView)
        contentView.addSubview(paymentAndPriceLabel)
        layoutSubviews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        orderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(12)
        }

        BillingView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(orderLabel.snp.bottom).offset(8)
            make.height.equalTo(68)
        }
        paymentAndPriceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(BillingView.snp.bottom).offset(8)
            make.height.equalTo(30)
        }
        orderLabel.font = UIFont.systemFont(ofSize: 22)
        paymentAndPriceLabel.font = UIFont.systemFont(ofSize: 16)
        paymentAndPriceLabel.textAlignment = .right
        paymentAndPriceLabel.textColor = UIColor(named: "blurGray")
    }

    func setupEvent(order: Order) {
        orderLabel.text = "order #\(order.id)"
        BillingView.setup(with: order.bills)
        paymentAndPriceLabel.text = "\(order.payment) ¥\(order.totalPrice)"
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view is EDBillingView {
            return self
        }else {
            return view
        }
    }
}


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

struct Order: Codable, Equatable {
    var id: Int
    var bills: [Bill]
    var shippingAddress: Address
    var deliveryAddress: Address
    var payment: Payment
    var totalPrice: Double
    var createdTime: TimeInterval
    var payedTime: TimeInterval?
    var completedTime: TimeInterval?
    var state: OrderState

    init(id: Int, bills: [Bill], shippingAddress: Address, deliveryAddress: Address, payment: Payment, totalPrice: Double, createdTime: TimeInterval, payedTime: TimeInterval? = nil, completedTime: TimeInterval? = nil, state: OrderState) {
        self.id = id
        self.bills = bills
        self.shippingAddress = shippingAddress
        self.deliveryAddress = deliveryAddress
        self.payment = payment
        self.totalPrice = totalPrice
        self.createdTime = createdTime
        self.payedTime = payedTime
        self.completedTime = completedTime
        self.state = state
    }

    init(json: JSON) {
        id = json["id"].intValue
        bills = json["bills"].arrayValue.map { Bill(json: $0) }
        shippingAddress = Address(json: json["shippingAddress"])
        deliveryAddress = Address(json: json["deliveryAddress"])
        payment = Payment(rawValue: json["payment"].stringValue) ?? .WeChat
        totalPrice = json["totalPrice"].doubleValue
        createdTime = json["createdTime"].doubleValue
        payedTime = json["payedTime"].doubleValue
        completedTime = json["completedTime"].doubleValue
        state = OrderState(rawValue: json["state"].intValue) ?? .ToPay
    }

    init() {
        self = Order(json: JSON())
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let billsArray = dictionary["bills"] as? [[String: Any]],
            let shippingAddressDict = dictionary["shippingAddress"] as? [String: Any],
            let deliveryAddressDict = dictionary["deliveryAddress"] as? [String: Any], let payment = dictionary["payment"] as? String, let state = dictionary["state"] as? Int, let totalPrice = dictionary["totalPrice"] as? Double,
            let createdTime = dictionary["createdTime"] as? TimeInterval else {
            return nil
        }

        self.id = id
        bills = billsArray.compactMap { Bill(dictionary: $0) }
        shippingAddress = Address(dictionary: shippingAddressDict)!
        deliveryAddress = Address(dictionary: deliveryAddressDict)!
        self.state = OrderState(rawValue: state) ?? .ToPay
        self.payment = Payment(rawValue: payment) ?? .WeChat
        self.totalPrice = totalPrice
        self.createdTime = createdTime

        if let payedTime = dictionary["payedTime"] as? TimeInterval {
            self.payedTime = payedTime
        }

        if let completedTime = dictionary["completedTime"] as? TimeInterval {
            self.completedTime = completedTime
        }
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "bills": bills.map { $0.toDictionary() },
            "shippingAddress": shippingAddress.toDictionary(),
            "deliveryAddress": deliveryAddress.toDictionary(),
            "totalPrice": totalPrice,
            "payment": payment.rawValue,
            "state": state.rawValue,
            "createdTime": createdTime,
        ]

        if let payedTime = payedTime {
            dict["payedTime"] = payedTime
        }

        if let completedTime = completedTime {
            dict["completedTime"] = completedTime
        }

        return dict
    }

    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id &&
            lhs.bills == rhs.bills &&
            lhs.shippingAddress == rhs.shippingAddress &&
            lhs.deliveryAddress == rhs.deliveryAddress && lhs.payment == rhs.payment && lhs.totalPrice == rhs.totalPrice &&
        lhs.createdTime == rhs.createdTime && lhs.state == rhs.state &&
            lhs.payedTime == rhs.payedTime &&
            lhs.completedTime == rhs.completedTime
    }
}


class EDBillingView: UIView {
    private var bills: [Bill] = []
    func setup(with bills: [Bill]) {
        self.bills = bills
        if bills.count == 1 {
            let billView = EDComBillingCell()
            addSubview(billView)
            billView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            billView.setupEvent(bill: bills[0])
        } else if bills.count == 2 {
            let billView = EDComBillingCell()
            addSubview(billView)
            billView.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalToSuperview().dividedBy(2).offset(6)
            }
            let additionalView = EDComBillingCell()
            addSubview(additionalView)
            additionalView.snp.makeConstraints { make in
                make.right.top.bottom.equalToSuperview()
                make.left.equalTo(billView.snp.right).offset(6)
            }
            billView.setupEvent(bill: bills[0])
            additionalView.setupEvent(bill: bills[1])
        } else {
            let imageView = UIImageView()
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().offset(-12)
                make.width.equalTo(imageView.snp.height)
            }
            imageView.image = UIImage(named: bills[0].com.images[0])
            imageView.setCorner(radii: 15)
            var lastView = imageView
            for bill in 1 ..< min(5, bills.count) {
                let imageView = UIImageView()
                addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.left.equalTo(lastView.snp.right).offset(6)
                    make.top.equalToSuperview().offset(12)
                    make.bottom.equalToSuperview().offset(-12)
                    make.width.equalTo(imageView.snp.height)
                }
                imageView.image = UIImage(named: bills[bill].com.images[0])
                imageView.setCorner(radii: 15)
                lastView = imageView
            }

            let countLabel = UILabel()
            addSubview(countLabel)
            countLabel.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.top.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().offset(-12)
                make.right.equalToSuperview()
            }
            countLabel.text = "共\(bills.count)种商品"

            addTapGesture(self, #selector(enterCountView))
        }
    }

    @objc func enterCountView() {
        let vc = EDBillTableViewController()
        vc.bills = bills
        if let parentVC = getParentViewController() {
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

struct Address: Codable, Equatable {
    var id: Int
    var name: String
    var sex: Sex
    var phoneNumber: String
    var province: String
    var city: String
    var area: String
    var detailedAddress: String

    init(id: Int, name: String, sex: Sex, phoneNumber: String, province: String, city: String, area: String, detailedAddress: String) {
        self.id = id
        self.name = name
        self.sex = sex
        self.phoneNumber = phoneNumber
        self.province = province
        self.city = city
        self.area = area
        self.detailedAddress = detailedAddress
    }

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        sex = Sex(rawValue: json["sex"].stringValue) ?? .Man
        phoneNumber = json["phoneNumber"].stringValue
        province = json["province"].stringValue
        city = json["city"].stringValue
        area = json["area"].stringValue
        detailedAddress = json["detailedAddress"].stringValue
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let sexRawValue = dictionary["sex"] as? String,
            let sex = Sex(rawValue: sexRawValue),
            let phoneNumber = dictionary["phoneNumber"] as? String,
            let province = dictionary["province"] as? String,
            let city = dictionary["city"] as? String,
            let area = dictionary["area"] as? String,
            let detailedAddress = dictionary["detailedAddress"] as? String else {
            return nil
        }

        self.init(id: id, name: name, sex: sex, phoneNumber: phoneNumber, province: province, city: city, area: area, detailedAddress: detailedAddress)
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "sex": sex.rawValue,
            "phoneNumber": phoneNumber,
            "province": province,
            "city": city,
            "area": area,
            "detailedAddress": detailedAddress,
        ]
    }

    init() {
        self = Address(json: JSON())
    }

    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.sex == rhs.sex &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.province == rhs.province &&
            lhs.city == rhs.city &&
            lhs.area == rhs.area &&
            lhs.detailedAddress == rhs.detailedAddress
    }
}

struct District: Codable {
    let citycode: [String]
    let adcode: String
    let name: String
    let center: String
    let level: AddressLevel
    let districts: [District]?

    init(json: JSON) {
        citycode = json["citycode"].arrayValue.compactMap { $0.stringValue }
        adcode = json["adcode"].stringValue
        name = json["name"].stringValue
        center = json["center"].stringValue
        level = AddressLevel(rawValue: json["level"].stringValue) ?? .district
        districts = json["districts"].arrayValue.compactMap { District(json: $0) }
    }
}

enum AddressLevel: String, Codable {
    case province
    case city
    case district
}


struct Bill: Codable, Equatable {
    var id: Int
    var com: Commodity
    var quantity: Int
    var cag: Int

    init(id: Int, com: Commodity, quantity: Int, cag: Int) {
        self.id = id
        self.com = com
        self.quantity = quantity
        self.cag = cag
    }

    init(json: JSON) {
        id = json["id"].intValue
        com = Commodity(json: json["com"])
        quantity = json["quantity"].intValue
        cag = json["cag"].intValue
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let comDict = dictionary["comId"] as? [String: Any], let com = Commodity(dict: comDict),
            let quantity = dictionary["quantity"] as? Int,
            let cag = dictionary["cag"] as? Int else {
            return nil
        }

        self.init(id: id, com: com, quantity: quantity, cag: cag)
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "com": com.toDictionary(),
            "quantity": quantity,
            "cag": cag,
        ]
    }

    init() {
        self = Bill(json: JSON())
    }

    static func == (lhs: Bill, rhs: Bill) -> Bool {
        return lhs.id == rhs.id &&
            lhs.com == rhs.com &&
            lhs.quantity == rhs.quantity &&
            lhs.cag == rhs.cag
    }
}

enum Payment: String, Codable, CaseIterable {
    case WeChat
    case AliPay
}


class EDComBillingCell: UITableViewCell {
    lazy var comIconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var nameView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(comIconView)
        contentView.addSubview(nameView)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(priceLabel)

        layoutSubviews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        comIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-48)
            make.width.equalTo(comIconView.snp.height)
            make.left.equalToSuperview().offset(12)
        }

        nameView.snp.makeConstraints { make in
            make.top.equalTo(comIconView.snp.top)
            make.left.equalTo(comIconView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-6)
        }

        quantityLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.width.equalTo(58)
            make.top.equalTo(nameView.snp.bottom).offset(6)
        }

        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(quantityLabel.snp.right).offset(-12)
            make.bottom.equalTo(comIconView.snp.bottom)
            make.width.equalTo(108)
        }
        comIconView.setCorner(radii: 10)
        quantityLabel.textAlignment = .right
        priceLabel.textAlignment = .right
        priceLabel.font = UIFont.systemFont(ofSize: 17)
        nameView.font = UIFont.systemFont(ofSize: 20)
        quantityLabel.font = UIFont.systemFont(ofSize: 15)
    }

    func setupEvent(bill: Bill) {
        comIconView.image = UIImage(named: bill.com.images[0])
        nameView.text = bill.com.name
        quantityLabel.text = "x\(bill.quantity)"
        priceLabel.text = "¥\(bill.com.price)"
    }
}

struct Commodity: Codable, Equatable {
    var id: Int
    var images: [String]
    var name: String
    var intro: String
    var price: Double
    var limit: Int
    var orders: Int
    var cag: Int

    init(id: Int, images: [String], name: String, intro: String, price: Double, limit: Int, orders: Int, cag: Int) {
        self.id = id
        self.images = images
        self.name = name
        self.intro = intro
        self.price = price
        self.limit = limit
        self.orders = orders
        self.cag = cag
    }

    init(json: JSON) {
        id = json["id"].intValue
        images = json["images"].arrayValue.compactMap { $0.stringValue }
        name = json["name"].stringValue
        intro = json["intro"].stringValue
        price = json["price"].doubleValue
        limit = json["limit"].intValue
        orders = json["orders"].intValue
        cag = json["cag"].intValue
    }

    init() {
        self = Commodity(json: JSON())
    }

    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "images": images,
            "name": name,
            "intro": intro,
            "price": price,
            "limit": limit,
            "orders": orders,
            "cag": cag,
        ]
        return dict
    }

    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? Int, let images = dict["images"] as? [String], let name = dict["name"] as? String, let intro = dict["intro"] as? String, let price = dict["price"] as? Double, let limit = dict["limit"] as? Int, let orders = dict["orders"] as? Int, let cag = dict["cag"] as? Int else {
            return nil
        }
        self = Commodity(id: id, images: images, name: name, intro: intro, price: price, limit: limit, orders: orders, cag: cag)
    }

    static func == (lhs: Commodity, rhs: Commodity) -> Bool {
        return lhs.id == rhs.id && lhs.images == rhs.images && lhs.name == rhs.name && lhs.intro == rhs.intro && lhs.price == rhs.price && lhs.limit == rhs.limit && lhs.orders == rhs.orders && lhs.cag == rhs.cag
    }
}


enum Sex: String, Codable, CaseIterable {
    case Man
    case Woman
}

class EDBillTableViewController: UITableViewController {
    var bills: [Bill] = []

    override func viewDidLoad() {
        tableView.register(EDComBillingCell.self, forCellReuseIdentifier: "billing")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return bills.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        super.tableView(tableView, heightForRowAt: indexPath)
        return 168
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        let cell = EDComBillingCell()
        cell.setupEvent(bill: bills[indexPath.row])
        return cell
    }
}




let com1 = Commodity(id: 0, images: ["Aus", "JasonZhang", "Aus", "JasonZhang", "Aus"], name: "DUNLOP邓禄普澳网AO官方比赛网球", intro: "澳大利亚网球公开赛官方指定用球 \n Wilson 公司全力打造的比赛用球！为大满贯比赛严格要求而设计的独特的网球,有OPTI-VIS增强视觉效果处理,更加清晰可见,更添专业品质。\n 具有Nano Play纳米科技，耐打性佳、弹性好，外表增添了加亮材料，大大增加了比赛或训练中捕球的机会性、可视性。", price: 123, limit: 9, orders: 2, cag: 1)

let com2 = Commodity(id: 0, images: ["Wim"], name: "Slazenger史莱辛格网球 温网比赛官方用球", intro: "澳大利亚网球公开赛官方指定用球；Wilson 公司全力打造的比赛用球！为大满贯比赛严格要求而设计的独特的网球,有OPTI-VIS增强视觉效果处理,更加清晰可见,更添专业品质。具有Nano Play纳米科技，耐打性佳、弹性好，外表增添了加亮材料，大大增加了比赛或训练中捕球的机会性、可视性。", price: 123, limit: 1, orders: 2, cag: 2)

let com: [Commodity] = [com1, com2]

let bill1 = Bill(id: 1, com: com1, quantity: 2, cag: 0)
let bill2 = Bill(id: 2, com: com2, quantity: 3, cag: 0)
let address1 = Address(id: 1, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "陕西省", city: "西安市", area: "灞桥区", detailedAddress: "西安邮电大学雁塔校区")
let address2 = Address(id: 1, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "陕西省", city: "西安市", area: "雁塔区", detailedAddress: "西安邮电大学雁塔校区")
let address3 = Address(id: 1, name: "张嘉诚", sex: .Man, phoneNumber: "18840250882", province: "陕西省", city: "西安市", area: "新城区", detailedAddress: "西安邮电大学雁塔校区")
var addresss = [address1, address2, address3]

let order: Order = Order(id: 1, bills: [bill1, bill2, bill2], shippingAddress: address1, deliveryAddress: address1, payment: .WeChat, totalPrice: 984.00, createdTime: 1_682_329_527, payedTime: 1_682_415_927, completedTime: 1_682_588_727, state: .Done)

let order1: Order = Order(id: 1, bills: [bill1, bill2, bill2], shippingAddress: address1, deliveryAddress: address1, payment: .WeChat, totalPrice: 984.00, createdTime: 1_682_329_527, payedTime: nil, completedTime: nil, state: .ToPay)

let ordersa: [Order] = [order, order, order1]


class EDViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = UIColor(named: "ContentBackground")
        view.backgroundColor = UIColor(named: "BackgroundGray")
    }
}


struct User: Codable, Equatable {
    var id: Int
    var loginName: String
    var password: String
    var name: String
    var icon: String
    var sex: Sex
    var token: String

    init(id: Int, loginName: String, password: String, name: String, icon: String, sex: Sex, token: String) {
        self.id = id
        self.loginName = loginName
        self.password = password
        self.name = name
        self.icon = icon
        self.sex = sex
        self.token = token
    }

    init(json: JSON) {
        id = json["id"].intValue
        loginName = json["loginName"].stringValue
        password = json["password"].stringValue
        name = json["name"].stringValue
        icon = json["icon"].stringValue
        sex = Sex(rawValue: json["sex"].stringValue) ?? .Man
        token = json["token"].stringValue
    }

    init() {
        self = User(json: JSON())
    }

    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "loginName": loginName,
            "password": password,
            "name": name,
            "icon": icon,
            "sex": sex.rawValue,
            "token": token,
        ]

        return dict
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let loginName = dictionary["loginName"] as? String,
            let password = dictionary["password"] as? String,
            let name = dictionary["name"] as? String,
            let icon = dictionary["icon"] as? String,
            let sexRawValue = dictionary["sex"] as? String,
            let sex = Sex(rawValue: sexRawValue),
            let token = dictionary["token"] as? String
        else {
            return nil
        }

        self = User(id: id, loginName: loginName, password: password, name: name, icon: icon, sex: sex, token: token)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
            lhs.loginName == rhs.loginName &&
            lhs.password == rhs.password &&
            lhs.name == rhs.name &&
            lhs.icon == rhs.icon &&
            lhs.sex == rhs.sex
    }
}

struct signupResponse: Codable {
    var user: User
    var res: Bool
}

struct UserSignUpResponse: Codable {
    var code: Int
    var count: Int
    var data: signupResponse
}

struct UserResponse: Codable {
    var code: Int
    var count: Int
    var data: User
}


class EDUser {
    // 未登录时为默认信息
    static var user = User()

    static func signIn(completionHandler: @escaping (User?, Error?) -> Void) {
        // 将要加密的字符串连接在一起
        let password = user.password

        // 计算 SHA256 哈希值
        if let data = password.data(using: .utf8) {
            let hash = SHA256.hash(data: data)
            let hashString = hash.map { String(format: "%02x", $0) }.joined()

            let para = [
                "loginName": user.loginName,
                "password": hashString,
            ]
            EDNetWork.post("/user/signIn", dataParameters: para) { json in
                guard let json = json else {
                    completionHandler(nil, EDNetWorkError.netError("账号或密码错误"))
                    return
                }
                completionHandler(User(json: json), nil)
            }
        }
    }

    static func signUp(completionHandler: @escaping (String?, Error?) -> Void) {
        EDNetWork.post("/user/signUp", dataParameters: EDUser.user, responseBindingType: UserSignUpResponse.self) { response in
            guard let res = response else {
                completionHandler(nil, EDNetWorkError.netError("账号或密码错误"))
                return
            }
            EDUser.user = res.data.user
            completionHandler(EDUser.user.token, nil)
        }
    }

    static func resetPassword(completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": user.loginName,
            "password": user.password,
        ]
        EDNetWork.post("/user/resetPassword", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func updateInfo(completionHandler: @escaping (User?) -> Void) {
        EDNetWork.post("/user/update", dataParameters: EDUser.user) { json in
            guard let json = json else {
                completionHandler(nil)
                return
            }
            EDUser.user = User(json: json)
            completionHandler(EDUser.user)
        }
    }

    static func auth(token: String, completionHandler: @escaping (String?, String?, Error?) -> Void) {
        let headers: HTTPHeaders = ["Authorization": token]
        EDNetWork.get("/auth", headers: headers) { json, error in
            guard error == nil else {
                completionHandler(nil, nil, error)
                return
            }
            guard let json = json else {
                completionHandler(nil, nil, nil)
                return
            }
            completionHandler(json["loginName"].stringValue, json["password"].stringValue, nil)
        }
    }

    static func getDeviceID() -> String? {
        if let uuid = UIDevice.current.identifierForVendor {
            return uuid.uuidString
        }
        return nil
    }
}


class EDNetWork {
    static let EDURL = "http://localhost:8080"

    static func get(_ parameters: String, headers: HTTPHeaders? = nil, completionHandler: @escaping (JSON?, Error?) -> Void) {
        AF.request(URL(string: EDURL + parameters)!, headers: headers).response { response in
            guard response.response?.statusCode != 401 else {
                completionHandler(nil, EDNetWorkError.authError("认证失败"))
                return
            }
            guard let jsonData = response.data else {
                completionHandler(nil, nil)
                return
            }
            let json = try? JSON(data: jsonData)
            completionHandler(json?["data"], nil)
        }
    }

    static func post<T: Decodable>(_ URLParameters: String, dataParameters: Encodable, responseBindingType: T.Type, completionHandler: @escaping (T?) -> Void) {
        guard let json = try? JSONEncoder().encode(dataParameters) else {
            return // 序列化失败，处理错误
        }

        guard let dictionary = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return // 转换失败，处理错误
        }

        AF.request(URL(string: EDURL + URLParameters)!, method: .post, parameters: dictionary, encoding: JSONEncoding.default).responseDecodable(of: responseBindingType.self) { response in
            switch response.result {
            case let .success(T):
                // 成功解码，处理 Response 对象
                completionHandler(T)
            case .failure:
                // 解码失败，处理错误
                completionHandler(nil)
            }
        }
    }

    static func post(_ URLParameters: String, dataParameters: Encodable, completionHandler: @escaping (JSON?) -> Void) {
        guard let json = try? JSONEncoder().encode(dataParameters) else {
            return // 序列化失败，处理错误
        }

        guard let dictionary = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return // 转换失败，处理错误
        }

        AF.request(URL(string: EDURL + URLParameters)!, method: .post, parameters: dictionary, encoding: JSONEncoding.default).response { response in
            guard let jsonData = response.data else {
                completionHandler(nil)
                return
            }
            let json = try? JSON(data: jsonData)
            completionHandler(json?["data"])
        }
    }

    static func post<T: Decodable>(_ URLParameters: String, dataParameters: Parameters?, responseBindingType: T.Type, completionHandler: @escaping (T?) -> Void) {
        AF.request(URL(string: EDURL + URLParameters)!, method: .post, parameters: dataParameters, encoding: JSONEncoding.default).responseDecodable(of: responseBindingType.self) { response in
            switch response.result {
            case let .success(T):
                // 成功解码，处理 Response 对象
                completionHandler(T)
            case .failure:
                // 解码失败，处理错误
                completionHandler(nil)
            }
        }
    }

    static func post(_ URLParameters: String, dataParameters: Parameters?, completionHandler: @escaping (JSON?) -> Void) {
        AF.request(URL(string: EDURL + URLParameters)!, method: .post, parameters: dataParameters, encoding: JSONEncoding.default).response { response in
            guard let jsonData = response.data else {
                completionHandler(nil)
                return
            }
            let json = try? JSON(data: jsonData)
            completionHandler(json?["data"])
        }
    }
}

enum EDNetWorkError: Error {
    case authError(String)
    case netError(String)
}


class TMSignInViewController: UIViewController {
    lazy var loginNameTextField: TMTextField = {
        let textField = TMTextField()
        return textField
    }()

    lazy var passwordTextField: TMTextField = {
        let textField = TMTextField()
        return textField
    }()

    lazy var signUpBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var signInBtn: TMSignInBtn = {
        let btn = TMSignInBtn()
        return btn
    }()

    lazy var forgetPasswordBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.addSubview(loginNameTextField)
        view?.addSubview(passwordTextField)
        view?.addSubview(signInBtn)
        view?.addSubview(forgetPasswordBtn)
        view?.addSubview(signUpBtn)
        loginNameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(348)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginNameTextField.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        signUpBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.centerX.equalTo(passwordTextField.snp.right)
            make.width.equalTo(178)
            make.height.equalTo(48)
        }
        forgetPasswordBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.centerX.equalTo(passwordTextField.snp.left)
            make.width.equalTo(178)
            make.height.equalTo(48)
        }
        signInBtn.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 75, y: 530, width: 150, height: 150)
        signInBtn.setupView()
        loginNameTextField.setup(with: TMTextFieldConfig(placeholderText: "Login Name"))
        passwordTextField.setup(with: TMTextFieldConfig(placeholderText: "Password"))
        let signUpBtnConfig = TMButtonConfig(title: "Newer? signup", action: #selector(signUpVCUp), actionTarget: self)
        signUpBtn.setUp(with: signUpBtnConfig)
        let forgetPasswordBtnConfig = TMButtonConfig(title: "Forget passWord?", action: #selector(resetPasswordVCUp), actionTarget: self)
        forgetPasswordBtn.setUp(with: forgetPasswordBtnConfig)
        // 设置 completion 回调
        signInBtn.completion = { [weak self] in
            guard let self = self else {
                return
            }
            // 在这里处理登录接口返回数据之前的逻辑
            if let loginName = self.loginNameTextField.textField.text, let password = self.passwordTextField.textField.text {
                if !loginName.isEmpty, !password.isEmpty {
                    EDUser.user.loginName = loginName
                    EDUser.user.password = password
                    EDUser.signIn { user, error in
                        guard error == nil else {
                            if let window = self.signInBtn.window {
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("login failed", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                (window.rootViewController as? TMSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                                }
                            }
                            self.signInBtn.stopBouncing()
                            return
                        }
                        guard let user = user else {
                            if let window = self.signInBtn.window {
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("login failed", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                (window.rootViewController as? TMSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                                }
                            }
                            self.signInBtn.stopBouncing()
                            return
                        }
                        EDUser.user = user
                        var loggedinUser = (UserDefaults.standard.array(forKey: TMUDKeys.loggedinUser.rawValue) as? [String]) ?? []
                        loggedinUser.append(EDUser.user.loginName)
                        UserDefaults.standard.set(loggedinUser, forKey: TMUDKeys.loggedinUser.rawValue)
                        UserDefaults.standard.set(user.token, forKey: TMUDKeys.JSONWebToken.rawValue)
                        // 登录成功后，跳转到下一个界面
                        if let window = self.signInBtn.window {
                            let homeVC = UINavigationController(rootViewController: ViewController())
                            window.rootViewController = homeVC
                        }
                        self.signInBtn.stopBouncing()
                    }
                } else {
                    if let window = self.signInBtn.window {
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("loginName can not be null", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        (window.rootViewController as? TMSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                    }
                    self.signInBtn.stopBouncing()
                }
            } else {
                if let window = self.signInBtn.window {
                    let toastView = UILabel()
                    toastView.text = NSLocalizedString("loginName can not be null", comment: "")
                    toastView.numberOfLines = 2
                    toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                    toastView.backgroundColor = UIColor(named: "ComponentBackground")
                    toastView.textAlignment = .center
                    toastView.setCorner(radii: 15)
                    (window.rootViewController as? TMSignInViewController)?.view.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                    }
                }
                self.signInBtn.stopBouncing()
            }
        }
    }

    @objc func signUpVCUp() {
        let vc = TMSignUpViewController()
        present(vc, animated: true)
    }

    @objc func resetPasswordVCUp() {
        let vc = TMResetPasswordViewController()
        present(vc, animated: true)
    }
}


class TMSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let configItems = ["Please enter a name for yourself", "Please choose a profile picture.", "What is your gender?", "What is your age?", "How many years have you been playing?", "What is your height in centimeters?", "What is your width in kilograms?", "What is your grip type?", "What is your backhand type?", "Please enter a account for yourself.", "Please enter a password for yourself."]
    var currentIndex = 0

    var completionHandler: (String) -> Void = { _ in }
    var iconCompletionHandler: (Data) -> Void = { _ in }

    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressViewStyle = .default
        return view
    }()

    lazy var signInTitleView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var nameTextField: TMTextField = {
        let label = TMTextField()
        return label
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()

    lazy var sexTextField: TMSelectionView = {
        let label = TMSelectionView()
        return label
    }()

    lazy var ageTextField: TMTextField = {
        let label = TMTextField()
        return label
    }()

    lazy var accountTextField: TMTextField = {
        let label = TMTextField()
        return label
    }()

    lazy var passwordTextField: TMTextField = {
        let label = TMTextField()
        return label
    }()

    lazy var nextConfigBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var lastConfigBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(done)), animated: true)
        view.addSubview(progressView)
        view.addSubview(signInTitleView)
        view.addSubview(nameTextField)
        view.addSubview(iconImageView)
        view.addSubview(sexTextField)
        view.addSubview(ageTextField)
        view.addSubview(accountTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nextConfigBtn)
        view.addSubview(lastConfigBtn)

        signInTitleView.isHidden = false
        nameTextField.isHidden = false
        iconImageView.isHidden = true
        sexTextField.isHidden = true
        ageTextField.isHidden = true
        accountTextField.isHidden = true
        passwordTextField.isHidden = true

        progressView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.width.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        signInTitleView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(88)
            make.left.equalToSuperview().offset(48)
            make.width.equalTo(388)
            make.height.equalTo(50)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(288)
        }
        sexTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(88)
        }
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        nextConfigBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview().offset(68)
            make.width.equalTo(88)
            make.height.equalTo(50)
        }

        lastConfigBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview().offset(-68)
            make.width.equalTo(88)
            make.height.equalTo(50)
        }

        nameTextField.tag = 200
        iconImageView.tag = 201
        sexTextField.tag = 202
        ageTextField.tag = 203
        accountTextField.tag = 204
        passwordTextField.tag = 205

        progressView.setCorner(radii: 8)
        progressView.progress = 0
        progressView.progressTintColor = UIColor(named: "BackgroundGray") // 已有进度颜色
        progressView.trackTintColor = .gray
        signInTitleView.text = configItems[currentIndex]
        let nameConfig = TMTextFieldConfig(placeholderText: configItems[0])
        nameTextField.setup(with: nameConfig)
        iconImageView.image = UIImage(systemName: "camera")
        iconImageView.tintColor = UIColor(named: "ContentBackground")
        iconImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        iconImageView.addTapGesture(self, #selector(changeIcon))
        sexTextField.setupUI()
        sexTextField.setupEvent(config: TMServeViewConfig(selectedImage: "circle.fill", unSelectedImage: "circle", selectedTitle: "man", unselectedTitle: "woman"))
        let ageConfig = TMTextFieldConfig(placeholderText: configItems[3])
        ageTextField.setup(with: ageConfig)
        let accountConfig = TMTextFieldConfig(placeholderText: configItems[9])
        accountTextField.setup(with: accountConfig)
        let passwordConfig = TMTextFieldConfig(placeholderText: configItems[10])
        passwordTextField.setup(with: passwordConfig)
        nextConfigBtn.setupUI()
        let nextBtnConfig = TMButtonConfig(title: "Next Step", action: #selector(stepForward), actionTarget: self)
        nextConfigBtn.setUp(with: nextBtnConfig)
        let lastBtnConfig = TMButtonConfig(title: "Back", action: #selector(stepBackward), actionTarget: self)
        lastConfigBtn.setUp(with: lastBtnConfig)
    }

    func showSubView(tag: Int) {
        currentIndex = tag - 200
        progressView.isHidden = true
        nextConfigBtn.isHidden = true
        lastConfigBtn.isHidden = true
        signInTitleView.text = configItems[currentIndex]
        if let viewWithTag = self.view.viewWithTag(tag) {
            viewWithTag.isHidden = false
            // 遍历所有的子视图，并隐藏除了标记为 201 之外的所有视图
            for subview in view.subviews where subview != viewWithTag {
                subview.isHidden = true
            }
            signInTitleView.isHidden = false
        }
    }

    func setUserInfo(name: String, icon: Data, sex: Sex, age: Int) {
        accountTextField.textField.text = EDUser.user.loginName
        passwordTextField.textField.text = EDUser.user.password
        nameTextField.textField.text = name
        iconImageView.image = UIImage(data: icon)
        sexTextField.isLeft = sex == .Man ? true : false
        ageTextField.textField.text = "\(age)"
    }

    func getUserInfo() {
        EDUser.user.loginName = accountTextField.textField.text ?? ""
        EDUser.user.password = passwordTextField.textField.text ?? ""
        EDUser.user.name = nameTextField.textField.text ?? ""
        EDUser.user.icon = (iconImageView.image?.pngData() ?? Data()).base64EncodedString()
        EDUser.user.sex = sexTextField.isLeft ? .Man : .Woman
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc func stepForward() {
        if currentIndex < configItems.count - 1 {
            currentIndex += 1
            if let view = view.viewWithTag(currentIndex + 199), view is TMTextField {
                if let text = (view as? TMTextField)?.textField.text, !text.isEmpty {
                    if currentIndex == 10 {
                        nextConfigBtn.isEnabled = false
                        TMPlayerRequest.searchPlayer(loginName: text, completionHandler: { res in
                            if res {
                                self.currentIndex -= 1
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("Account already exists", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                self.view.showToast(toastView, duration: 1, point: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)) { _ in
                                }
                                self.nextConfigBtn.isEnabled = true
                            } else {
                                self.progressView.setProgress(Float(self.currentIndex) / Float(self.configItems.count), animated: true)
                                self.signInTitleView.text = self.configItems[self.currentIndex]
                                self.view.viewWithTag(self.currentIndex + 199)?.isHidden = true
                                self.view.viewWithTag(self.currentIndex + 200)?.isHidden = false
                                if let thisView = view.viewWithTag(self.currentIndex + 200) as? TMPopUpView {
                                    self.view.bringSubviewToFront(thisView)
                                }
                                self.nextConfigBtn.isEnabled = true
                            }
                        })
                    } else {
                        progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
                        signInTitleView.text = configItems[currentIndex]
                        self.view.viewWithTag(currentIndex + 199)?.isHidden = true
                        self.view.viewWithTag(currentIndex + 200)?.isHidden = false
                        if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                            self.view.bringSubviewToFront(thisView)
                        }
                    }
                } else {
                    currentIndex -= 1
                    let toastView = UILabel()
                    toastView.text = NSLocalizedString("No Content Input", comment: "")
                    toastView.numberOfLines = 2
                    toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                    toastView.backgroundColor = UIColor(named: "ComponentBackground")
                    toastView.textAlignment = .center
                    toastView.setCorner(radii: 15)
                    self.view.showToast(toastView, duration: 1, point: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)) { _ in
                    }
                }
            } else {
                progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
                signInTitleView.text = configItems[currentIndex]
                view.viewWithTag(currentIndex + 199)?.isHidden = true
                view.viewWithTag(currentIndex + 200)?.isHidden = false
                if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                    view.bringSubviewToFront(thisView)
                }
            }
        } else if currentIndex == configItems.count - 1 {
            getUserInfo()
            EDUser.signUp { token, error in
                guard error == nil else {
                    if self.view.window != nil {
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("login failed", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        self.view.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                    }
                    return
                }
                var loggedinUser = (UserDefaults.standard.array(forKey: TMUDKeys.loggedinUser.rawValue) as? [String]) ?? []
                loggedinUser.append(EDUser.user.loginName)
                UserDefaults.standard.set(loggedinUser, forKey: TMUDKeys.loggedinUser.rawValue)
                UserDefaults.standard.set(token, forKey: TMUDKeys.JSONWebToken.rawValue)
                // 登录成功后，跳转到下一个界面
                if let window = self.view.window {
                    let homeVC = UINavigationController(rootViewController: ViewController())
                    window.rootViewController = homeVC
                }
            }
        }
    }

    @objc func stepBackward() {
        if currentIndex > 0 {
            currentIndex -= 1
            progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
            signInTitleView.text = configItems[currentIndex]
            view.viewWithTag(currentIndex + 200)?.isHidden = false
            view.viewWithTag(currentIndex + 201)?.isHidden = true
            if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                view.bringSubviewToFront(thisView)
            }
        } else if currentIndex == 0 {
            dismiss(animated: true)
        }
    }

    @objc func done() {
        let tag = currentIndex + 200
        if let selectedString = (view.viewWithTag(tag) as? TMTextField)?.textField.text {
            completionHandler(selectedString)
        } else if let selectedString = (view.viewWithTag(tag) as? TMSelectionView)?.isLeft {
            completionHandler(selectedString == true ? Sex.Man.rawValue : Sex.Woman.rawValue)
        } else if let selectedIcon = (view.viewWithTag(tag) as? UIImageView)?.image?.pngData() {
            iconCompletionHandler(selectedIcon)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func changeIcon() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}


class TMResetPasswordViewController: UIViewController {
    lazy var accountLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var accountTextField: TMTextField = {
        let textField = TMTextField()
        return textField
    }()

    lazy var resetLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var resetTextField: TMTextField = {
        let textField = TMTextField()
        return textField
    }()

    lazy var confirmLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var confirmTextField: TMTextField = {
        let textField = TMTextField()
        return textField
    }()

    lazy var reauthBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var submitBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ComponentBackground")
        view.addSubview(accountLabel)
        view.addSubview(accountTextField)
        view.addSubview(resetLabel)
        view.addSubview(resetTextField)
        view.addSubview(confirmLabel)
        view.addSubview(confirmTextField)
        view.addSubview(reauthBtn)
        view.addSubview(submitBtn)

        accountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.equalToSuperview().offset(48)
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        resetLabel.snp.makeConstraints { make in
            make.top.equalTo(accountTextField.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        resetTextField.snp.makeConstraints { make in
            make.top.equalTo(resetLabel.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        confirmLabel.snp.makeConstraints { make in
            make.top.equalTo(resetTextField.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        confirmTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmLabel.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        submitBtn.snp.makeConstraints { make in
            make.top.equalTo(confirmTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(138)
            make.height.equalTo(50)
        }
        reauthBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        let reauthBtnConfig = TMButtonConfig(title: "Verification failed, tap to try again", action: #selector(authenticateUserTapped), actionTarget: self)
        reauthBtn.setUp(with: reauthBtnConfig)
        accountLabel.text = NSLocalizedString("Account", comment: "")
        let accountTFConfig = TMTextFieldConfig(placeholderText: "Enter account")
        accountTextField.setup(with: accountTFConfig)
        resetLabel.text = NSLocalizedString("Reset Password", comment: "")
        let resetTFConfig = TMTextFieldConfig(placeholderText: "Reset Password")
        resetTextField.setup(with: resetTFConfig)
        confirmLabel.text = NSLocalizedString("Confirm Password", comment: "")
        let confirmTFConfig = TMTextFieldConfig(placeholderText: "Confirm Password")
        confirmTextField.setup(with: confirmTFConfig)
        let submitBtnConfig = TMButtonConfig(title: "Submit", action: #selector(submitPassword), actionTarget: self)
        submitBtn.setUp(with: submitBtnConfig)

        accountLabel.isHidden = true
        accountTextField.isHidden = true
        resetLabel.isHidden = true
        resetTextField.isHidden = true
        confirmLabel.isHidden = true
        confirmTextField.isHidden = true
        submitBtn.isHidden = true
        reauthBtn.isHidden = true

        authUser()
    }

    @objc func submitPassword() {
        let loggedinUsers = (UserDefaults.standard.array(forKey: TMUDKeys.loggedinUser.rawValue) as? [String] ?? [])
        if let account = accountTextField.textField.text {
            if loggedinUsers.contains(where: { loginName in
                loginName == account
            }) {
                if let password = resetTextField.textField.text, password == confirmTextField.textField.text {
                    EDUser.user.loginName = account
                    EDUser.user.password = password
                    EDUser.resetPassword { _ in
                    }
                } else {
                    let toastView = UILabel()
                    toastView.text = NSLocalizedString("Confirm password should match the password entered", comment: "")
                    toastView.numberOfLines = 2
                    toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                    toastView.backgroundColor = UIColor(named: "ComponentBackground")
                    toastView.textAlignment = .center
                    toastView.setCorner(radii: 15)
                    view.showToast(toastView, position: .center)
                }
            } else {
                let toastView = UILabel()
                toastView.text = NSLocalizedString("You Have Not Signed In This Account Successfully", comment: "")
                toastView.numberOfLines = 2
                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                toastView.textAlignment = .center
                toastView.setCorner(radii: 15)
                view.showToast(toastView, position: .center)
            }
        }
    }

    @objc func authenticateUserTapped() {
        authUser()
    }

    func authUser() {
        let context = LAContext()
        var error: NSError?

        // 判断设备是否支持Face ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 如果支持，调起Face ID验证
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "使用Face ID验证身份") {
                [weak self] success, _ in
                guard success else {
                    // 如果验证失败，处理错误信息
                    DispatchQueue.main.async {
                        self?.accountLabel.isHidden = true
                        self?.accountTextField.isHidden = true
                        self?.resetLabel.isHidden = true
                        self?.resetTextField.isHidden = true
                        self?.confirmLabel.isHidden = true
                        self?.confirmTextField.isHidden = true
                        self?.reauthBtn.isHidden = false
                    }
                    return
                }

                // 如果验证成功，执行其他操作
                DispatchQueue.main.async {
                    self?.accountLabel.isHidden = false
                    self?.accountTextField.isHidden = false
                    self?.resetLabel.isHidden = false
                    self?.resetTextField.isHidden = false
                    self?.confirmLabel.isHidden = false
                    self?.confirmTextField.isHidden = false
                    self?.submitBtn.isHidden = false
                    self?.reauthBtn.isHidden = true
                }
            }
        } else {
            // 判断设备是否支持Touch ID
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // 如果支持，调起Touch ID验证
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "使用Touch ID验证身份") {
                    [weak self] success, _ in
                    guard success else {
                        // 如果验证失败，处理错误信息
                        DispatchQueue.main.async {
                            self?.accountLabel.isHidden = true
                            self?.accountTextField.isHidden = true
                            self?.resetLabel.isHidden = true
                            self?.resetTextField.isHidden = true
                            self?.confirmLabel.isHidden = true
                            self?.confirmTextField.isHidden = true
                            self?.submitBtn.isHidden = true
                            self?.reauthBtn.isHidden = false
                        }
                        return
                    }

                    // 如果验证成功，执行其他操作
                    DispatchQueue.main.async {
                        self?.accountLabel.isHidden = false
                        self?.accountTextField.isHidden = false
                        self?.resetLabel.isHidden = false
                        self?.resetTextField.isHidden = false
                        self?.confirmLabel.isHidden = false
                        self?.confirmTextField.isHidden = false
                        self?.submitBtn.isHidden = false
                        self?.reauthBtn.isHidden = true
                    }
                }
            } else {
                // 如果不支持Touch ID，显示错误信息
                let ac = UIAlertController(title: "设备无法找回密码", message: error?.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "确定", style: .default))
                present(ac, animated: true)
            }
        }
    }
}


open class TMTextField: UIView {
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 22)
        return textField
    }()

    public func setup(with config: TMTextFieldConfig) {
        setupUI()
        setupEvent(config: config)
    }

    private func setupUI() {
        backgroundColor = UIColor(named: "TennisBlurTextField")
        setCorner(radii: 15)

        addSubview(textField)

        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
    }

    private func setupEvent(config: TMTextFieldConfig) {
        textField.placeholder = config.placeholderText
    }
}


open class TMTextFieldConfig {
    public var placeholderText: String
    init(placeholderText: String) {
        self.placeholderText = placeholderText
    }
}


class TMSelectionView: UIView {
    var isLeft: Bool = true
    lazy var leftServerView: TMServerView = {
        let serveView = TMServerView()
        return serveView
    }()

    lazy var rightServerView: TMServerView = {
        let serveView = TMServerView()
        return serveView
    }()

    func setupUI() {
        addSubview(leftServerView)
        addSubview(rightServerView)
        leftServerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        rightServerView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        leftServerView.addTapGesture(self, #selector(changeServe))
        rightServerView.addTapGesture(self, #selector(changeServe))
    }

    func setupEvent(config: TMServeViewConfig) {
        leftServerView.setup(isServing: isLeft, config: TMServeViewConfig(selectedImage: config.selectedImage, unSelectedImage: config.unSelectedImage, selectedTitle: config.selectedTitle, unselectedTitle: config.selectedTitle))
        rightServerView.setup(isServing: !isLeft, config: TMServeViewConfig(selectedImage: config.selectedImage, unSelectedImage: config.unSelectedImage, selectedTitle: config.unselectedTitle, unselectedTitle: config.unselectedTitle))
    }

    @objc func changeServe() {
        isLeft.toggle()
        leftServerView.changeStats(to: isLeft)
        rightServerView.changeStats(to: !isLeft)
    }
}

class TMSignInBtn: UILabel {
    private var isBouncing = false

    var completion: (() -> Void)?

    func setupView() {
        backgroundColor = UIColor(named: "TennisBlur")
        setCorner(radii: bounds.height / 2)
        // 设置 label 的属性和文本
        font = UIFont.boldSystemFont(ofSize: 20)
        textColor = UIColor(named: "ContentBackground")
        textAlignment = .center
        text = NSLocalizedString("SignIn", comment: "")
        isUserInteractionEnabled = true
        // 添加点击手势
        addTapGesture(self, #selector(handleTapGesture))
    }

    func startBouncing() {
        guard !isBouncing else { return }
        isBouncing = true
        let bounceHeight = CGFloat(50)
        let bounceDuration: TimeInterval = 0.4
        let bounceDelay: TimeInterval = 0.1
        let options: UIView.AnimationOptions = [.curveEaseInOut, .autoreverse, .repeat]

        UIView.animate(withDuration: bounceDuration, delay: bounceDelay, options: options, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: bounceHeight)
        }, completion: nil)
    }

    func stopBouncing() {
        guard isBouncing else { return }
        isBouncing = false
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.layer.removeAllAnimations()
        })
    }

    @objc private func handleTapGesture() {
        // 执行弹跳动画
        startBouncing()
        completion?()
    }
}


class TMServerView: TMView {
    var config = TMServeViewConfig(selectedImage: "", unSelectedImage: "", selectedTitle: "", unselectedTitle: "")
    lazy var selectionView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func setup(isServing: Bool, config: TMServeViewConfig) {
        self.config = config
        addSubview(selectionView)
        addSubview(textLabel)

        selectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(selectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }

        textLabel.textAlignment = .center
        if isServing {
            selectionView.image = UIImage(systemName: config.selectedImage)?.withTintColor(UIColor(named: "Tennis") ?? .black, renderingMode: .alwaysOriginal)
            textLabel.text = NSLocalizedString(config.selectedTitle, comment: "")
        } else {
            selectionView.image = UIImage(systemName: config.unSelectedImage)?.withTintColor(UIColor(named: "Tennis") ?? .black, renderingMode: .alwaysOriginal)
            textLabel.text = NSLocalizedString(config.unselectedTitle, comment: "")
        }
    }

    func changeStats(to isSelected: Bool) {
        if isSelected {
            selectionView.image = UIImage(systemName: config.selectedImage)?.withTintColor(UIColor(named: "Tennis") ?? .black, renderingMode: .alwaysOriginal)
            textLabel.text = NSLocalizedString(config.selectedTitle, comment: "")
        } else {
            selectionView.image = UIImage(systemName: config.unSelectedImage)?.withTintColor(UIColor(named: "Tennis") ?? .black, renderingMode: .alwaysOriginal)
            textLabel.text = NSLocalizedString(config.unselectedTitle, comment: "")
        }
    }
}

class TMServeViewConfig {
    var selectedImage: String
    var unSelectedImage: String
    var selectedTitle: String
    var unselectedTitle: String

    init(selectedImage: String, unSelectedImage: String, selectedTitle: String, unselectedTitle: String) {
        self.selectedImage = selectedImage
        self.unSelectedImage = unSelectedImage
        self.selectedTitle = selectedTitle
        self.unselectedTitle = unselectedTitle
    }
}


enum TMUDKeys: String {
    // 非首次下载
    case isNotFirstDownload

    // 用户token
    case JSONWebToken

    // 此设备登录过的用户
    case loggedinUser
}


class TMPlayerRequest {
    static func searchPlayer(loginName: String, completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": loginName,
        ]
        EDNetWork.post("/player/search", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }
}


class TMSys {
    var reachability: Reachability?
    static let shard = TMSys()
    private init() {}

    func initWindow() -> UIWindow {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = initStyle()
        window.rootViewController = initRootViewController()
        window.makeKeyAndVisible()
        return window
    }

    func enterForeground() {
        if reachability?.connection != .unavailable {
            auth()
        }
    }

    func initRootViewController() -> UIViewController {
        let isNotFirstDownload = UserDefaults.standard.bool(forKey: TMUDKeys.isNotFirstDownload.rawValue)
        if !isNotFirstDownload {
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: TMUDKeys.isNotFirstDownload.rawValue)
            }
            return TMSignInViewController()
        } else {
                return TMSignInViewController()
        }
    }

    func initStyle() -> UIUserInterfaceStyle {
            return .unspecified
    }

    func auth() {
        if let token = UserDefaults.standard.string(forKey: TMUDKeys.JSONWebToken.rawValue) {
            EDUser.auth(token: token) { userLoginName, userPassword, error in
                guard error == nil else {
                    if let window = UIApplication.shared.windows.first {
                        let signInVC = TMSignInViewController()
                        window.rootViewController = signInVC
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("The login information has expired\n please log in again", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        (window.rootViewController as? TMSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                        window.rootViewController = TMSignInViewController()
                    }
                    return
                }
                guard let userLoginName = userLoginName else {
                    return
                }
                guard let userPassword = userPassword else {
                    return
                }
                EDUser.user.loginName = userLoginName
                EDUser.user.password = userPassword
                EDUser.signIn { user, error in
                    guard error == nil else {
                        if let window = UIApplication.shared.windows.first {
                            let toastView = UILabel()
                            toastView.text = NSLocalizedString("No such loginname or password", comment: "")
                            toastView.numberOfLines = 2
                            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                            toastView.backgroundColor = UIColor(named: "ComponentBackground")
                            toastView.textAlignment = .center
                            toastView.setCorner(radii: 15)
                            (window.rootViewController as? TMSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                            }
                            window.rootViewController = TMSignInViewController()
                        }
                        return
                    }
                    guard let user = user else {
                        if let window = UIApplication.shared.windows.first {
                            let toastView = UILabel()
                            toastView.text = NSLocalizedString("Login Failed", comment: "")
                            toastView.numberOfLines = 2
                            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                            toastView.backgroundColor = UIColor(named: "ComponentBackground")
                            toastView.textAlignment = .center
                            toastView.setCorner(radii: 15)
                            (window.rootViewController as? TMSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                            }
                            window.rootViewController = TMSignInViewController()
                        }
                        return
                    }
                    UserDefaults.standard.set(user.token, forKey: TMUDKeys.JSONWebToken.rawValue)
                }
            }
        } else {
            if let window = UIApplication.shared.windows.first {
                let signInVC = TMSignInViewController()
                window.rootViewController = signInVC
            }
        }
    }
}
