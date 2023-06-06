//
//  EDExpressDetailViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/6/4.
//

import Foundation
import UIKit

class EDExpressDetailViewController: UIViewController {
    var express = Express()
    lazy var senderAddressView: EDAddressCell = {
        let view = EDAddressCell()
        return view
    }()

    lazy var recipientAddressView: EDAddressCell = {
        let view = EDAddressCell()
        return view
    }()

    lazy var orderStateLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var orderLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var orderNumLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var billingView: EDTraceView = {
        let view = EDTraceView()
        return view
    }()

    lazy var billingViewBackground: UIView = {
        let view = UIView()
        return view
    }()

    lazy var paymentLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var paymentNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var commoTypeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var commoTypeNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var priceNumLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var sentBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    lazy var orderCreateTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var createTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var orderPayedTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var payedTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var orderDoneTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var doneTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(orderStateLabel)
        view.addSubview(senderAddressView)
        view.addSubview(recipientAddressView)
        view.addSubview(billingViewBackground)
        billingViewBackground.addSubview(billingView)
        view.addSubview(paymentLabel)
        view.addSubview(paymentNameLabel)
        view.addSubview(commoTypeLabel)
        view.addSubview(commoTypeNameLabel)
        view.addSubview(priceLabel)
        view.addSubview(priceNumLabel)
        view.addSubview(orderLabel)
        view.addSubview(orderNumLabel)
        view.addSubview(orderCreateTimeLabel)
        view.addSubview(createTimeLabel)
        view.addSubview(orderPayedTimeLabel)
        view.addSubview(payedTimeLabel)
        view.addSubview(orderDoneTimeLabel)
        view.addSubview(doneTimeLabel)
        view.addSubview(cancelBtn)
        view.addSubview(sentBtn)

        orderStateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(98)
            make.height.equalTo(40)
        }

        billingViewBackground.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(recipientAddressView.snp.bottom).offset(12)
            make.height.equalTo(88)
        }

        senderAddressView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(orderStateLabel.snp.bottom).offset(12)
            make.height.equalTo(143)
        }

        recipientAddressView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(senderAddressView.snp.bottom).offset(12)
            make.height.equalTo(143)
        }

        billingView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }

        paymentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(billingView.snp.bottom).offset(12)
            make.height.equalTo(30)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(commoTypeLabel.snp.bottom).offset(12)
            make.height.equalTo(30)
        }

        paymentNameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(paymentLabel.snp.top)
            make.height.equalTo(30)
        }

        commoTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(paymentLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(30)
        }
        commoTypeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(commoTypeLabel.snp.top)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(30)
        }

        priceNumLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(priceLabel.snp.top)
            make.height.equalTo(30)
        }

        orderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(30)
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
        }

        orderCreateTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(30)
            make.top.equalTo(orderLabel.snp.bottom).offset(12)
        }

        orderPayedTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(30)
            make.top.equalTo(orderCreateTimeLabel.snp.bottom).offset(12)
        }

        orderDoneTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(30)
            make.top.equalTo(orderPayedTimeLabel.snp.bottom).offset(12)
        }

        orderNumLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(30)
            make.top.equalTo(priceNumLabel.snp.bottom).offset(12)
        }

        createTimeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(30)
            make.top.equalTo(orderNumLabel.snp.bottom).offset(12)
        }

        payedTimeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(30)
            make.top.equalTo(createTimeLabel.snp.bottom).offset(12)
        }

        doneTimeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(30)
            make.top.equalTo(payedTimeLabel.snp.bottom).offset(12)
        }
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-138)
            make.width.equalTo(108)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(32)
        }

        sentBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-138)
            make.width.equalTo(108)
            make.height.equalTo(50)
            make.right.equalToSuperview().offset(-32)
        }

        orderStateLabel.text = express.state.displayName
        orderStateLabel.font = UIFont.systemFont(ofSize: 24)
        senderAddressView.setupEvent(address: express.de)
        recipientAddressView.setupEvent(address: express.sh)
        billingView.setupUI()
        billingView.setupEvent(trace: express.trace[express.trace.count - 1])
        paymentLabel.text = "支付方式"
        paymentNameLabel.text = express.payment.displayName
        commoTypeLabel.text = "物品类型"
        commoTypeNameLabel.text = express.commoType
        priceNumLabel.text = "¥\(express.price)"
        priceLabel.text = "总计"
        cancelBtn.setTitleColor(UIColor(named: "ContentBackground"), for: .normal)
        cancelBtn.backgroundColor = UIColor(named: "ComponentBackground")
        cancelBtn.setCorner(radii: 10)
        if express.state == .ToPay {
            sentBtn.setTitle("修改地址", for: .normal)
            sentBtn.addTarget(self, action: #selector(changerecipAddress), for: .touchDown)
            cancelBtn.setTitle("取消订单", for: .normal)
            cancelBtn.isHidden = false
            cancelBtn.addTarget(self, action: #selector(cancelOrder), for: .touchDown)
            billingViewBackground.isHidden = true
            paymentLabel.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(24)
                make.top.equalTo(recipientAddressView.snp.bottom).offset(12)
                make.height.equalTo(30)
            }
        } else if express.state == .ToSend {
            sentBtn.setTitle("修改地址", for: .normal)
            sentBtn.addTarget(self, action: #selector(changerecipAddress), for: .touchDown)
            cancelBtn.isHidden = true
            billingViewBackground.isHidden = true
            paymentLabel.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(24)
                make.top.equalTo(recipientAddressView.snp.bottom).offset(12)
                make.height.equalTo(30)
            }
        } else if express.state == .ToDelivery {
            sentBtn.setTitle("确认收货", for: .normal)
            sentBtn.addTarget(self, action: #selector(confirmDelivery), for: .touchDown)
            cancelBtn.isHidden = true
        } else {
            sentBtn.isHidden = true
            cancelBtn.isHidden = true
        }
        sentBtn.setTitleColor(UIColor(named: "ContentBackground"), for: .normal)
        sentBtn.backgroundColor = UIColor(named: "TennisBlur")
        sentBtn.setCorner(radii: 10)
        orderLabel.text = "快递单号"
        orderNumLabel.text = "\(express.id)"
        orderCreateTimeLabel.text = "创建时间"
        createTimeLabel.text = express.createdTime.convertToString()

        if let payedTime = express.payedTime {
            orderPayedTimeLabel.isHidden = false
            payedTimeLabel.isHidden = false
            orderPayedTimeLabel.text = "支付时间"
            payedTimeLabel.text = payedTime.convertToString()
        } else {
            orderPayedTimeLabel.isHidden = true
            payedTimeLabel.isHidden = true
        }

        if let doneTime = express.completedTime {
            orderDoneTimeLabel.isHidden = false
            doneTimeLabel.isHidden = false
            orderDoneTimeLabel.text = "完成时间"
            doneTimeLabel.text = doneTime.convertToString()
        } else {
            orderDoneTimeLabel.isHidden = true
            doneTimeLabel.isHidden = true
        }

        senderAddressView.backgroundColor = UIColor(named: "ComponentBackground")
        recipientAddressView.backgroundColor = UIColor(named: "ComponentBackground")
        senderAddressView.setCorner(radii: 10)
        recipientAddressView.setCorner(radii: 10)
        billingViewBackground.setCorner(radii: 10)
        billingViewBackground.backgroundColor = UIColor(named: "ComponentBackground")
    }

    @objc func cancelOrder() {}

    @objc func confirmDelivery() {}

    @objc func changerecipAddress() {
//        let vc = EDAddressManagementViewController()
//        vc.selectedCompletionHandler = { address in
//            self.recipientAddressView.setupEvent(address: address)
//        }
//        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func cancelRefund() {}

    @objc func cancelReturn() {}

    @objc func sentOrder() {
//        let vc = EDDeliveryViewController()
//        navigationController?.present(vc, animated: true)
    }
}
