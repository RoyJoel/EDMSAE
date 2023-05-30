//
//  EDComConfigEditingViewController.swift
//  Pods
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit

class EDComConfigEditingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var option = Option()
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var introTextfield: EDTextField = {
        let textField = EDTextField()
        return textField
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var inventoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var priceTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()
    lazy var inventoryTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "编辑类目信息"
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(iconView)
        view.addSubview(introTextfield)
        view.addSubview(priceLabel)
        view.addSubview(inventoryLabel)
        view.addSubview(priceTextField)
        view.addSubview(inventoryTextField)
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(103)
            make.width.equalTo(108)
            make.height.equalTo(108)
        }
        introTextfield.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.height.equalTo(44)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(introTextfield.snp.bottom).offset(12)
            make.left.equalTo(introTextfield.snp.left)
            make.width.equalTo(58)
            make.height.equalTo(38)
        }
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(introTextfield.snp.bottom).offset(12)
            make.left.equalTo(priceLabel.snp.right).offset(4)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(38)
        }
        inventoryLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.left.equalTo(introTextfield.snp.left)
            make.width.equalTo(58)
            make.height.equalTo(38)
        }
        inventoryTextField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.left.equalTo(priceLabel.snp.right).offset(4)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(38)
        }
        
        
        let introConfig = EDTextFieldConfig(placeholderText: "商品类目")
        introTextfield.setup(with: introConfig)
        let priceConfig = EDTextFieldConfig(placeholderText: "")
        priceTextField.setup(with: priceConfig)
        let inventoryConfig = EDTextFieldConfig(placeholderText: "")
        inventoryTextField.setup(with: inventoryConfig)
        
        priceLabel.text = "价格"
        inventoryLabel.text = "库存"
        
        iconView.setCorner(radii: 15)
        imagePicker.delegate = self
        iconView.image = UIImage(systemName: "camera")
        iconView.isUserInteractionEnabled = true
        iconView.addTapGesture(self, #selector(changeIcon))
        setupEvent(option: option)
    }
    
    func setupEvent(option: Option) {
        iconView.image = UIImage(named: option.image)
        introTextfield.textField.text = option.intro
        priceTextField.textField.text = "\(option.price)"
        inventoryTextField.textField.text = "\(option.inventory)"
    }
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            iconView.contentMode = .scaleAspectFit
            iconView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
    }
    @objc func changeIcon() {
        imagePicker.sourceType = .photoLibrary
        navigationController?.present(imagePicker, animated: true)
    }
}
