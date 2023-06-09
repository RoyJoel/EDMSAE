//
//  EDComConfigEditingViewController.swift
//  Pods
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit

class EDComConfigEditingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    var option = Option()
    var completionHandler: ((Option) -> Void)?
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
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        return btn
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
        view.addSubview(confirmBtn)
        
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
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(inventoryTextField.snp.bottom).offset(44)
            make.centerX.equalToSuperview()
            make.width.equalTo(108)
            make.height.equalTo(44)
        }
        
        
        let introConfig = EDTextFieldConfig(placeholderText: "商品类目")
        introTextfield.setup(with: introConfig)
        let priceConfig = EDTextFieldConfig(placeholderText: "")
        priceTextField.setup(with: priceConfig)
        let inventoryConfig = EDTextFieldConfig(placeholderText: "")
        inventoryTextField.setup(with: inventoryConfig)
        
        priceLabel.text = "价格"
        inventoryLabel.text = "库存"
        
        introTextfield.textField.delegate = self
        priceTextField.textField.delegate = self
        inventoryTextField.textField.delegate = self
        
        iconView.setCorner(radii: 15)
        imagePicker.delegate = self
        iconView.image = UIImage(systemName: "camera")
        iconView.isUserInteractionEnabled = true
        iconView.addTapGesture(self, #selector(changeIcon))
        confirmBtn.setTitle("保存", for: .normal)
        confirmBtn.setTitleColor(.black, for: .normal)
        confirmBtn.backgroundColor = UIColor(named: "TennisBlur")
        confirmBtn.addTarget(self, action: #selector(confirm), for: .touchDown)
        setupEvent(option: option)
    }
    
    func setupEvent(option: Option) {
        iconView.image = UIImage(data: option.image.toPng())
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
    @objc func confirm() {
        let option = Option(id: option.id, image: (iconView.image?.pngData() ?? Data()).base64EncodedString(), intro: introTextfield.textField.text ?? "", price: Double(priceTextField.textField.text ?? "0") ?? 0, inventory: Int(inventoryTextField.textField.text ?? "0") ?? 0)
        (completionHandler ?? {_ in})(option)
        dismiss(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
