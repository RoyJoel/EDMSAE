//
//  EDUserExpressCell.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/6/4.
//

import Foundation
import UIKit

class EDUserExpressCell: UITableViewCell {
    lazy var orderLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var BillingView: EDExpressDestinationView = {
        let view = EDExpressDestinationView()
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
            make.height.equalTo(32)
            make.top.equalToSuperview().offset(6)
        }

        BillingView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(orderLabel.snp.bottom).offset(8)
            make.height.equalTo(88)
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
        BillingView.setupUI()
    }

    func setupEvent(express: Express) {
        orderLabel.text = "快递号 \(express.id)"
        BillingView.setupEvent(sender: express.de, recipient: express.sh)
        paymentAndPriceLabel.text = "\(express.payment.displayName) ¥\(express.price)"
    }
}
