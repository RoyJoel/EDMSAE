//
//  EDCommodityEditingViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit
import TMComponent

class EDCommodityEditingViewController: UIViewController, UITableViewDataSource {
    var configItems = ComCag.allCases
    var com = Commodity()
    var completionHandler: ((Commodity) -> Void)?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var nameTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()
    lazy var introLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var introTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    lazy var cagLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var cagSelectionView: TMPopUpView = {
        let popupView = TMPopUpView()
        return popupView
    }()
    
    lazy var optionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var configSelectionView: EDComConfigTableView = {
        let view = EDComConfigTableView()
        return view
    }()
    
    lazy var leftBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var rightBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundGray")
        title = "编辑商品信息"
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(introLabel)
        view.addSubview(introTextView)
        view.addSubview(cagLabel)
        view.addSubview(cagSelectionView)
        view.addSubview(optionLabel)
        view.addSubview(configSelectionView)
        view.addSubview(leftBtn)
        view.addSubview(rightBtn)
        view.bringSubviewToFront(configSelectionView)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(103)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(24)
        }
        nameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(44)
        }
        introLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(24)
        }
        introTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(introLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(118)
        }
        cagLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(introTextView.snp.bottom).offset(12)
            make.width.equalTo(108)
            make.height.equalTo(44)
        }
        cagSelectionView.frame = CGRect(x: 120, y: 349, width: 261, height: 44)
        optionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(cagLabel.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(24)
        }
        configSelectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(optionLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(126)
        }
        
        leftBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(68)
            make.width.equalTo(108)
            make.top.equalTo(configSelectionView.snp.bottom).offset(44)
            make.height.equalTo(44)
        }
        
        rightBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-68)
            make.width.equalTo(108)
            make.top.equalTo(configSelectionView.snp.bottom).offset(44)
            make.height.equalTo(44)
        }
        
        nameLabel.text = "商品标题"
        introLabel.text = "商品介绍"
        cagLabel.text = "商品类别"
        optionLabel.text = "商品类目"
        let nameConfig = EDTextFieldConfig(placeholderText: "请输入商品标题")
        nameTextField.setup(with: nameConfig)
        cagSelectionView.delegate = cagSelectionView
        cagSelectionView.dataSource = self
        cagSelectionView.setupUI()
        cagSelectionView.selectedCompletionHandler = { index in
            let selectedConfig = self.configItems.remove(at: index)
            self.configItems.insert(selectedConfig, at: 0)
            self.cagSelectionView.reloadData()
        }
        
        nameTextField.textField.text = com.name
        introTextView.text = com.intro
        let selectedConfig = configItems.remove(at: com.cag.rawValue)
        configItems.insert(selectedConfig, at: 0)
        configSelectionView.setup(with: com.options)
        if com == Commodity() {
            leftBtn.setTitle("放入仓库", for: .normal)
            rightBtn.setTitle("一键上架", for: .normal)
            leftBtn.addTarget(self, action: #selector(addCommodityToWarehouse), for: .touchDown)
            rightBtn.addTarget(self, action: #selector(startSellingCommodity), for: .touchDown)
        }else if com.state == .ToArrived {
            leftBtn.setTitle("删除商品", for: .normal)
            rightBtn.setTitle("一键上架", for: .normal)
            leftBtn.addTarget(self, action: #selector(deleteCommodity), for: .touchDown)
            rightBtn.addTarget(self, action: #selector(sellCommodity), for: .touchDown)
        }else if com.state == .Banned {
            leftBtn.setTitle("删除商品", for: .normal)
            rightBtn.setTitle("重新上架", for: .normal)
            leftBtn.addTarget(self, action: #selector(deleteCommodity), for: .touchDown)
            rightBtn.addTarget(self, action: #selector(sellCommodity), for: .touchDown)
        }else if com.state == .selling {
            leftBtn.setTitle("放回仓库", for: .normal)
            rightBtn.setTitle("一键下架", for: .normal)
            leftBtn.addTarget(self, action: #selector(putCommodityToWarehouse), for: .touchDown)
            rightBtn.addTarget(self, action: #selector(offCommodity), for: .touchDown)
        }
        leftBtn.backgroundColor = UIColor(named: "TennisBlur")
        rightBtn.backgroundColor = UIColor(named: "TennisBlur")
        leftBtn.setTitleColor(.black, for: .normal)
        rightBtn.setTitleColor(.black, for: .normal)
    }
    
    func getCommodityInfo() -> Commodity {
        return Commodity(id: com.id, options: configSelectionView.options, name: nameTextField.textField.text ?? "", intro: introTextView.text ?? "", orders: com.orders, cag: configItems[0], state: com.state)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TMPopUpCell()
        cell.setupUI()
        cell.setupEvent(title: configItems[indexPath.row].displayName)
        return cell
    }
     
    @objc func addCommodityToWarehouse() {
        var newCommodity = getCommodityInfo()
        newCommodity.state = .ToArrived
        EDCommodityRequest.add(commodity: newCommodity) { _ in
            self.navigationController?.popViewController(animated: true)
            
            NotificationCenter.default.post(name: Notification.Name(ToastNotification.refreshCommoditiesData.notificationName.rawValue), object: nil)
        }
    }
    
    @objc func putCommodityToWarehouse() {
        var commodity = getCommodityInfo()
        commodity.state = .ToArrived
        EDCommodityRequest.update(commodity: commodity) { _ in
            self.navigationController?.popViewController(animated: true)
            
            NotificationCenter.default.post(name: Notification.Name(ToastNotification.refreshCommoditiesData.notificationName.rawValue), object: nil)
        }
    }
    
    @objc func offCommodity() {
        var commodity = getCommodityInfo()
        commodity.state = .Banned
        EDCommodityRequest.update(commodity: commodity) { _ in
            self.navigationController?.popViewController(animated: true)
            
            NotificationCenter.default.post(name: Notification.Name(ToastNotification.refreshCommoditiesData.notificationName.rawValue), object: nil)
            
        }
    }
    
    @objc func sellCommodity() {
        var commodity = getCommodityInfo()
        commodity.state = .selling
        EDCommodityRequest.update(commodity: commodity) { _ in
            self.navigationController?.popViewController(animated: true)
            
            NotificationCenter.default.post(name: Notification.Name(ToastNotification.refreshCommoditiesData.notificationName.rawValue), object: nil)
            
        }
    }
    
    @objc func deleteCommodity() {
        let commodity = getCommodityInfo()
        EDCommodityRequest.delete(commodity.id) { _ in
            self.navigationController?.popViewController(animated: true)
            
            NotificationCenter.default.post(name: Notification.Name(ToastNotification.refreshCommoditiesData.notificationName.rawValue), object: nil)
        }
    }
    @objc func startSellingCommodity() {
        var newCommodity = getCommodityInfo()
        newCommodity.state = .selling
        EDCommodityRequest.add(commodity: newCommodity) { _ in
            self.navigationController?.popViewController(animated: true)
            
            NotificationCenter.default.post(name: Notification.Name(ToastNotification.refreshCommoditiesData.notificationName.rawValue), object: nil)
        }
    }
}
