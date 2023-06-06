//
//  EDExpressInfoView.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/6/4.
//

import Foundation
import UIKit

class EDExpressInfoView: UIView {
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func setupUI() {
        addSubview(placeLabel)
        addSubview(nameLabel)

        placeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        placeLabel.font = UIFont.systemFont(ofSize: 22)
    }

    func setupEvent(place: String, name: String) {
        placeLabel.text = place
        nameLabel.text = name
    }
}

