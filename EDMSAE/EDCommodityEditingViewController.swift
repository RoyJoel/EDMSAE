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
     
}
