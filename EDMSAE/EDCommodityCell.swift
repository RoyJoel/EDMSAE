//
//  EDCommodityCell.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit

class EDCommodityCell: UITableViewCell {
    lazy var comIconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var nameView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var inventoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(comIconView)
        contentView.addSubview(nameView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(inventoryLabel)

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

        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(nameView.snp.left)
            make.top.equalTo(nameView.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-24)
        }
        inventoryLabel.snp.makeConstraints { make in
            make.left.equalTo(nameView.snp.left)
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-24)
        }
        comIconView.setCorner(radii: 10)
        priceLabel.font = UIFont.systemFont(ofSize: 17)
        inventoryLabel.font = UIFont.systemFont(ofSize: 17)
        nameView.font = UIFont.systemFont(ofSize: 20)
    }

    func setupEvent(com: Commodity) {
        if com.options.count == 0 {
            comIconView.image = UIImage(systemName: "camera")
        }else {
            comIconView.image = UIImage(data: com.options[0].image.toPng())
        }
        nameView.text = com.name
        priceLabel.text = "价格：¥\(TMDataConvert.getPriceRange(with: com.options).0) - \(TMDataConvert.getPriceRange(with: com.options).1)"
        inventoryLabel.text = "库存 \(TMDataConvert.getTotalInventory(with: com.options))"
        
    }
}
