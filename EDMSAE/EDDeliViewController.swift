//
//  EDDeliViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/7.
//

import Foundation
import UIKit

class EDDeliViewController: UIViewController, UITextFieldDelegate  {
    lazy var deliLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var deliTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(deliLabel)
        view.addSubview(deliTextField)
        view.addSubview(confirmBtn)
        
        deliLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(32)
            make.height.equalTo(40)
        }
        
        deliTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(44)
            make.right.equalToSuperview().offset(-44)
            make.top.equalTo(deliLabel.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        confirmBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(88)
            make.top.equalTo(deliTextField.snp.bottom).offset(24)
            make.height.equalTo(40)
        }
        
        deliLabel.text = "请输入快递单号"
        let textFieldConfig = EDTextFieldConfig(placeholderText: "请输入快递单号")
        deliTextField.setup(with: textFieldConfig)
        confirmBtn.setTitle("确认", for: .normal)
        confirmBtn.setTitleColor(UIColor(named: "ContentBackground"), for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmToSend), for: .touchDown)
        confirmBtn.setCorner(radii: 10)
        confirmBtn.backgroundColor = UIColor(named: "ComponentBackground")
    }
    
    @objc func confirmToSend() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
