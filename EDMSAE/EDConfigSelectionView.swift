//
//  EDConfigSelectionView.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit
import TMComponent

class EDComConfigView: UITableViewCell {
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var introTextfield: UILabel = {
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
    lazy var priceTextField: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var inventoryTextField: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func setupUI() {
        addSubview(iconView)
        addSubview(introTextfield)
        addSubview(priceLabel)
        addSubview(inventoryLabel)
        addSubview(priceTextField)
        addSubview(inventoryTextField)
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalTo(priceLabel.snp.bottom)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(iconView.snp.height)
        }
        introTextfield.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(38)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(introTextfield.snp.bottom).offset(6)
            make.left.equalTo(introTextfield.snp.left)
            make.width.equalTo(68)
            make.height.equalTo(38)
        }
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(introTextfield.snp.bottom).offset(6)
            make.left.equalTo(priceLabel.snp.right).offset(4)
            make.width.equalTo(88)
            make.height.equalTo(38)
        }
        inventoryLabel.snp.makeConstraints { make in
            make.top.equalTo(introTextfield.snp.bottom).offset(6)
            make.left.equalTo(priceTextField.snp.right).offset(4)
            make.width.equalTo(68)
            make.height.equalTo(38)
        }
        inventoryTextField.snp.makeConstraints { make in
            make.top.equalTo(introTextfield.snp.bottom).offset(6)
            make.left.equalTo(inventoryLabel.snp.right).offset(4)
            make.height.equalTo(38)
            make.right.equalToSuperview().offset(-12)
        }
        
        priceLabel.text = "价格"
        inventoryLabel.text = "库存"
        iconView.setCorner(radii: 15)
    }
    
    func setupEvent(option: Option) {
        iconView.image = UIImage(named: option.image)
        introTextfield.text = option.intro
        priceTextField.text = "\(option.price)"
        inventoryTextField.text = "\(option.inventory)"
    }
}
