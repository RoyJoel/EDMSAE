//
//  EDExpressDestinationView.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/6/4.
//

import Foundation
import UIKit

class EDExpressDestinationView: UIView {
    lazy var senderView: EDExpressInfoView = {
        let view = EDExpressInfoView()
        return view
    }()

    lazy var recipientView: EDExpressInfoView = {
        let view = EDExpressInfoView()
        return view
    }()

    lazy var arrowView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    func setupUI() {
        addSubview(senderView)
        addSubview(recipientView)
        addSubview(arrowView)

        senderView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowView.snp.left).offset(-6)
            make.left.equalToSuperview().offset(6)
            make.height.equalTo(68)
        }
        recipientView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(arrowView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-6)
            make.height.equalTo(68)
        }
        arrowView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        arrowView.image = UIImage(systemName: "arrowshape.forward")?.withTintColor(UIColor(named: "ContentBackground") ?? .black, renderingMode: .alwaysOriginal)
        senderView.setupUI()
        recipientView.setupUI()
    }

    func setupEvent(sender: Address, recipient: Address) {
        senderView.setupEvent(place: sender.city, name: sender.name)
        recipientView.setupEvent(place: recipient.city, name: recipient.name)
    }
}
