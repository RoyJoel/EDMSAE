//
//  EDComBillingCell.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit

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
            make.height.equalToSuperview().offset(-12)
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
            make.bottom.equalToSuperview().offset(-12)
        }

        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(quantityLabel.snp.right)
            make.bottom.equalTo(quantityLabel.snp.top).offset(-6)
        }
        comIconView.setCorner(radii: 10)
        quantityLabel.textAlignment = .right
        priceLabel.textAlignment = .right
        priceLabel.font = UIFont.systemFont(ofSize: 17)
        nameView.font = UIFont.systemFont(ofSize: 20)
        quantityLabel.font = UIFont.systemFont(ofSize: 15)
        quantityLabel.textAlignment = .right
    }

    func setupEvent(bill: Bill) {
        comIconView.image = UIImage(data: bill.option.image.toPng())
        nameView.text = bill.com.name
        quantityLabel.text = "x\(bill.quantity)"
        priceLabel.text = "¥\(bill.option.price)"
    }
}
