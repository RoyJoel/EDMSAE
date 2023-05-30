//
//  TMSignUpViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit
import TMComponent

class TMSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let configItems = ["起个名字吧", "为你选一张头像", "你的性别是", "设置用户名", "设置密码"]
    var currentIndex = 0

    var completionHandler: (String) -> Void = { _ in }
    var iconCompletionHandler: (Data) -> Void = { _ in }

    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressViewStyle = .default
        return view
    }()

    lazy var signInTitleView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var nameTextField: EDTextField = {
        let label = EDTextField()
        return label
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var sexTextField: TMSelectionView = {
        let label = TMSelectionView()
        return label
    }()

    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()

    lazy var accountTextField: EDTextField = {
        let label = EDTextField()
        return label
    }()

    lazy var passwordTextField: EDTextField = {
        let label = EDTextField()
        return label
    }()

    lazy var nextConfigBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var lastConfigBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(done)), animated: true)
        view.addSubview(progressView)
        view.addSubview(signInTitleView)
        view.addSubview(nameTextField)
        view.addSubview(iconImageView)
        view.addSubview(sexTextField)
        view.addSubview(accountTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nextConfigBtn)
        view.addSubview(lastConfigBtn)

        signInTitleView.isHidden = false
        nameTextField.isHidden = false
        iconImageView.isHidden = true
        sexTextField.isHidden = true
        accountTextField.isHidden = true
        passwordTextField.isHidden = true

        progressView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.width.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        signInTitleView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(88)
            make.left.equalToSuperview().offset(48)
            make.width.equalTo(388)
            make.height.equalTo(50)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(288)
        }
        sexTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(88)
        }
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(signInTitleView.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        nextConfigBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview().offset(68)
            make.width.equalTo(88)
            make.height.equalTo(50)
        }

        lastConfigBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-88)
            make.centerX.equalToSuperview().offset(-68)
            make.width.equalTo(88)
            make.height.equalTo(50)
        }

        nameTextField.tag = 200
        iconImageView.tag = 201
        sexTextField.tag = 202
        accountTextField.tag = 203
        passwordTextField.tag = 204

        progressView.setCorner(radii: 8)
        progressView.progress = 0
        progressView.progressTintColor = UIColor(named: "BackgroundGray") // 已有进度颜色
        progressView.trackTintColor = .gray
        signInTitleView.text = configItems[currentIndex]
        let nameConfig = EDTextFieldConfig(placeholderText: configItems[0])
        nameTextField.setup(with: nameConfig)
        iconImageView.image = UIImage(systemName: "camera")
        iconImageView.tintColor = UIColor(named: "ContentBackground")
        iconImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        iconImageView.addTapGesture(self, #selector(changeIcon))
        let accountConfig = EDTextFieldConfig(placeholderText: configItems[3])
        sexTextField.setupUI()
        sexTextField.setupEvent(config: TMServerViewConfig(selectedImage: "circle.fill", unSelectedImage: "circle", selectedTitle: "男", unselectedTitle: "女"))
        accountTextField.setup(with: accountConfig)
        let passwordConfig = EDTextFieldConfig(placeholderText: configItems[4])
        passwordTextField.setup(with: passwordConfig)
        nextConfigBtn.setupUI()
        let nextBtnConfig = TMButtonConfig(title: "下一步", action: #selector(stepForward), actionTarget: self)
        nextConfigBtn.setUp(with: nextBtnConfig)
        let lastBtnConfig = TMButtonConfig(title: "返回", action: #selector(stepBackward), actionTarget: self)
        lastConfigBtn.setUp(with: lastBtnConfig)
    }

    func showSubView(tag: Int) {
        currentIndex = tag - 200
        progressView.isHidden = true
        nextConfigBtn.isHidden = true
        lastConfigBtn.isHidden = true
        signInTitleView.text = configItems[currentIndex]
        if let viewWithTag = self.view.viewWithTag(tag) {
            viewWithTag.isHidden = false
            // 遍历所有的子视图，并隐藏除了标记为 201 之外的所有视图
            for subview in view.subviews where subview != viewWithTag {
                subview.isHidden = true
            }
            signInTitleView.isHidden = false
        }
    }

    func setUserInfo(name: String, icon: Data, sex: Sex) {
        accountTextField.textField.text = EDUser.user.loginName
        passwordTextField.textField.text = EDUser.user.password
        nameTextField.textField.text = name
        iconImageView.image = UIImage(data: icon)
        sexTextField.isLeft = sex == .Man ? true : false
    }

    func getUserInfo() {
        EDUser.user.loginName = accountTextField.textField.text ?? ""
        EDUser.user.password = passwordTextField.textField.text ?? ""
        EDUser.user.name = nameTextField.textField.text ?? ""
        EDUser.user.sex = sexTextField.isLeft ? .Man : .Woman
        EDUser.user.icon = (iconImageView.image?.pngData() ?? Data()).base64EncodedString()
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc func stepForward() {
        if currentIndex < configItems.count - 1 {
            currentIndex += 1
            if let view = view.viewWithTag(currentIndex + 199), view is EDTextField {
                if let text = (view as? EDTextField)?.textField.text, !text.isEmpty {
                    if currentIndex == 9 {
                        nextConfigBtn.isEnabled = false
                        TMPlayerRequest.searchPlayer(loginName: text, completionHandler: { res in
                            if res {
                                self.currentIndex -= 1
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("此账号已存在", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                self.view.showToast(toastView, duration: 1, point: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)) { _ in
                                }
                                self.nextConfigBtn.isEnabled = true
                            } else {
                                self.progressView.setProgress(Float(self.currentIndex) / Float(self.configItems.count), animated: true)
                                self.signInTitleView.text = self.configItems[self.currentIndex]
                                self.view.viewWithTag(self.currentIndex + 199)?.isHidden = true
                                self.view.viewWithTag(self.currentIndex + 200)?.isHidden = false
                                if let thisView = view.viewWithTag(self.currentIndex + 200) as? TMPopUpView {
                                    self.view.bringSubviewToFront(thisView)
                                }
                                self.nextConfigBtn.isEnabled = true
                            }
                        })
                    } else {
                        progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
                        signInTitleView.text = configItems[currentIndex]
                        self.view.viewWithTag(currentIndex + 199)?.isHidden = true
                        self.view.viewWithTag(currentIndex + 200)?.isHidden = false
                        if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                            self.view.bringSubviewToFront(thisView)
                        }
                    }
                } else {
                    currentIndex -= 1
                    let toastView = UILabel()
                    toastView.text = NSLocalizedString("没有输入内容", comment: "")
                    toastView.numberOfLines = 2
                    toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                    toastView.backgroundColor = UIColor(named: "ComponentBackground")
                    toastView.textAlignment = .center
                    toastView.setCorner(radii: 15)
                    self.view.showToast(toastView, duration: 1, point: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)) { _ in
                    }
                }
            } else {
                progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
                signInTitleView.text = configItems[currentIndex]
                view.viewWithTag(currentIndex + 199)?.isHidden = true
                view.viewWithTag(currentIndex + 200)?.isHidden = false
                if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                    view.bringSubviewToFront(thisView)
                }
            }
        } else if currentIndex == configItems.count - 1 {
            getUserInfo()
            EDUser.signUp { token, error in
                guard error == nil else {
                    if self.view.window != nil {
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("登录失败", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        self.view.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                    }
                    return
                }
                var loggedinUser = (UserDefaults.standard.array(forKey: TMUDKeys.loggedinUser.rawValue) as? [String]) ?? []
                loggedinUser.append(EDUser.user.loginName)
                UserDefaults.standard.set(loggedinUser, forKey: TMUDKeys.loggedinUser.rawValue)
                UserDefaults.standard.set(token, forKey: TMUDKeys.JSONWebToken.rawValue)
                // 登录成功后，跳转到下一个界面
                if let window = self.view.window {
                    let homeVC = TabViewController()
                    window.rootViewController = homeVC
                }
            }
        }
    }

    @objc func stepBackward() {
        if currentIndex > 0 {
            currentIndex -= 1
            progressView.setProgress(Float(currentIndex) / Float(configItems.count), animated: true)
            signInTitleView.text = configItems[currentIndex]
            view.viewWithTag(currentIndex + 200)?.isHidden = false
            view.viewWithTag(currentIndex + 201)?.isHidden = true
            if let thisView = view.viewWithTag(currentIndex + 200) as? TMPopUpView {
                view.bringSubviewToFront(thisView)
            }
        } else if currentIndex == 0 {
            dismiss(animated: true)
        }
    }

    @objc func done() {
        let tag = currentIndex + 200
        if let selectedString = (view.viewWithTag(tag) as? EDTextField)?.textField.text {
            completionHandler(selectedString)
        } else if let selectedIcon = (view.viewWithTag(tag) as? UIImageView)?.image?.pngData() {
            iconCompletionHandler(selectedIcon)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func changeIcon() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}
