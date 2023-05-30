//
//  EDCommodityCofigTableViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit

class EDCommodityCofigTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var options: [Option] = []
    
    lazy var orderBackgroundView: UIView = {
        let view = UIView()
        return view
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
    
    lazy var configAddingBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(billTableView)
        view.addSubview(alartView)
        billTableView.backgroundColor = UIColor(named: "BackgroundGray")
        view.insertSubview(orderBackgroundView, aboveSubview: billTableView)
        orderBackgroundView.addSubview(confirmBtn)

        billTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        orderBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(208)
        }

        confirmBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-98)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(50)
        }

        alartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        billTableView.register(EDComConfigView.self, forCellReuseIdentifier: "billing")
        billTableView.showsHorizontalScrollIndicator = false
        billTableView.showsVerticalScrollIndicator = false
        billTableView.dataSource = self
        billTableView.delegate = self
        billTableView.isHidden = false
        alartView.isHidden = true

        orderBackgroundView.backgroundColor = UIColor(named: "ComponentBackground")
        
        self.confirmBtn.setTitle("添加类目", for: .normal)
        self.confirmBtn.backgroundColor = UIColor(named: "TennisBlur")
        self.confirmBtn.setTitleColor(.black, for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(self.addConfig), for: .touchDown)
        self.confirmBtn.setCorner(radii: 15)
    }

    func setupAlart() {
        orderBackgroundView.isHidden = true
        billTableView.isHidden = true
        alartView.isHidden = false
        alartView.text = NSLocalizedString("空空如也", comment: "")
        alartView.font = UIFont.systemFont(ofSize: 22)
        alartView.textAlignment = .center
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
            return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt _: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) { _, _, _ in
            let option = self.options.remove(at: indexPath.row)
            EDOptionRequest.delete(option.id) { options in
                self.options = options
                self.billTableView.reloadData()
            }
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return options.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 106
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDComConfigView()
        cell.setupUI()
        cell.setupEvent(option: options[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EDComConfigEditingViewController()
        vc.option = options[indexPath.row]
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    @objc func addConfig() {
        let vc = EDComConfigEditingViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}
