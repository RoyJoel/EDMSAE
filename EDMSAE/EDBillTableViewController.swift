//
//  EDBillTableViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit

class EDBillTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var bills: [Bill] = []

    lazy var orderBackgroundView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var totalLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var totalNumLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    lazy var billTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    lazy var alartView: UILabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(billTableView)
        view.addSubview(alartView)
        billTableView.backgroundColor = UIColor(named: "BackgroundGray")
        view.insertSubview(orderBackgroundView, aboveSubview: billTableView)
        orderBackgroundView.addSubview(totalLabel)
        orderBackgroundView.addSubview(totalNumLabel)
        orderBackgroundView.addSubview(confirmBtn)

        billTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        orderBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(208)
        }

        totalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(50)
        }

        totalNumLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(50)
        }

        confirmBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)
            make.width.equalTo(108)
            make.height.equalTo(50)
        }

        alartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        billTableView.register(EDComBillingCell.self, forCellReuseIdentifier: "billing")
        billTableView.showsHorizontalScrollIndicator = false
        billTableView.showsVerticalScrollIndicator = false
        billTableView.dataSource = self
        billTableView.delegate = self

        orderBackgroundView.backgroundColor = UIColor(named: "ComponentBackground")
        orderBackgroundView.isHidden = true
        billTableView.isHidden = false
        alartView.isHidden = true
    }

    func setupAlart() {
        orderBackgroundView.isHidden = true
        billTableView.isHidden = true
        alartView.isHidden = false
        alartView.text = NSLocalizedString("空空如也", comment: "")
        alartView.font = UIFont.systemFont(ofSize: 22)
        alartView.textAlignment = .center
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return bills.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 118
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDComBillingCell()
        cell.setupEvent(bill: bills[indexPath.row])
        return cell
    }
}
