//
//  EDSignInViewController.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import UIKit
import TMComponent

class EDSignInViewController: UIViewController, UITextFieldDelegate  {
    lazy var loginNameTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()

    lazy var passwordTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()

    lazy var signUpBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var signInBtn: TMSignInBtn = {
        let btn = TMSignInBtn()
        return btn
    }()

    lazy var forgetPasswordBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 创建 AVPlayer 对象

        view?.addSubview(loginNameTextField)
        view?.addSubview(passwordTextField)
        view?.addSubview(signInBtn)
        view?.addSubview(forgetPasswordBtn)
        view?.addSubview(signUpBtn)
        loginNameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(348)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginNameTextField.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        signUpBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.left.equalTo(passwordTextField.snp.centerX).offset(12)
            make.width.equalTo(138)
            make.height.equalTo(48)
        }
        forgetPasswordBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.right.equalTo(passwordTextField.snp.centerX).offset(-12)
            make.width.equalTo(138)
            make.height.equalTo(48)
        }
        signInBtn.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 75, y: 530, width: 150, height: 150)
        signInBtn.setupView()
        loginNameTextField.setup(with: EDTextFieldConfig(placeholderText: "用户名"))
        passwordTextField.setup(with: EDTextFieldConfig(placeholderText: "密码"))
        let signUpBtnConfig = TMButtonConfig(title: "新人？注册", action: #selector(signUpVCUp), actionTarget: self)
        signUpBtn.setUp(with: signUpBtnConfig)
        loginNameTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        let forgetPasswordBtnConfig = TMButtonConfig(title: "忘记密码？", action: #selector(resetPasswordVCUp), actionTarget: self)
        forgetPasswordBtn.setUp(with: forgetPasswordBtnConfig)
        // 设置 completion 回调
        signInBtn.completion = { [weak self] in
            guard let self = self else {
                return
            }
            // 在这里处理登录接口返回数据之前的逻辑
            if let loginName = self.loginNameTextField.textField.text, let password = self.passwordTextField.textField.text {
                if !loginName.isEmpty, !password.isEmpty {
                    EDUser.user.loginName = loginName
                    EDUser.user.password = password
                    EDUser.signIn { user, error in
                        guard error == nil else {
                            if let window = self.signInBtn.window {
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("登录失败", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                (window.rootViewController as? EDSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                                }
                            }
                            self.signInBtn.stopBouncing()
                            return
                        }
                        guard let user = user else {
                            if let window = self.signInBtn.window {
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("登录失败", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                (window.rootViewController as? EDSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                                }
                            }
                            self.signInBtn.stopBouncing()
                            return
                        }
                        EDUser.user = user
                        var loggedinUser = (UserDefaults.standard.array(forKey: TMUDKeys.loggedinUser.rawValue) as? [String]) ?? []
                        loggedinUser.append(EDUser.user.loginName)
                        let userInfo = try? PropertyListEncoder().encode(EDUser.user)
                        UserDefaults.standard.set(loggedinUser, forKey: TMUDKeys.loggedinUser.rawValue)
                        UserDefaults.standard.set(user.token, forKey: TMUDKeys.JSONWebToken.rawValue)
                        // 登录成功后，跳转到下一个界面
                        if let window = self.signInBtn.window {
                            let homeVC = TabViewController()
                            window.rootViewController = homeVC
                        }
                        self.signInBtn.stopBouncing()
                    }
                } else {
                    if let window = self.signInBtn.window {
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("用户名为空", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        (window.rootViewController as? EDSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                    }
                    self.signInBtn.stopBouncing()
                }
            } else {
                if let window = self.signInBtn.window {
                    let toastView = UILabel()
                    toastView.text = NSLocalizedString("账户名为空", comment: "")
                    toastView.numberOfLines = 2
                    toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                    toastView.backgroundColor = UIColor(named: "ComponentBackground")
                    toastView.textAlignment = .center
                    toastView.setCorner(radii: 15)
                    (window.rootViewController as? EDSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                    }
                }
                self.signInBtn.stopBouncing()
            }
        }
    }

    @objc func signUpVCUp() {
        let vc = TMSignUpViewController()
        present(vc, animated: true)
    }

    @objc func resetPasswordVCUp() {
        let vc = TMResetPasswordViewController()
        present(vc, animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === loginNameTextField.textField {
            return passwordTextField.textField.becomeFirstResponder()
        } else if textField === passwordTextField.textField {
            signInBtn.handleTapGesture()
            return textField.resignFirstResponder()
        } else {
            return textField.resignFirstResponder()
        }
    }
}
