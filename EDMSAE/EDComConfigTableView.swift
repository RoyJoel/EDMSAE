//
//  EDComConfigTableView.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit

class EDComConfigTableView: UIView {
    private var options: [Option] = []
    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func setup(with options: [Option]) {
        self.options = options
        addSubview(label)
        if options.count == 0 {
            setupAlart()
        }else {
            label.isHidden = true
            let imageView = UIImageView()
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().offset(-12)
                make.width.equalTo(imageView.snp.height)
            }
            imageView.image = UIImage(named: options[0].image)
            imageView.setCorner(radii: 15)
            var lastView = imageView
            for bill in 1 ..< min(2, options.count) {
                let imageView = UIImageView()
                addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.left.equalTo(lastView.snp.right).offset(6)
                    make.top.equalToSuperview().offset(12)
                    make.bottom.equalToSuperview().offset(-12)
                    make.width.equalTo(imageView.snp.height)
                }
                imageView.image = UIImage(named: options[bill].image)
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
            countLabel.text = "共\(options.count)种商品"
            
        }
        addTapGesture(self, #selector(enterCountView))
    }
    
    func setupAlart() {
        label.isHidden = false
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.text = "点击添加类目"
        label.textAlignment = .center
    }

    @objc func enterCountView() {
        let vc = EDCommodityCofigTableViewController()
        vc.options = options
        if let parentVC = getParentViewController() {
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
