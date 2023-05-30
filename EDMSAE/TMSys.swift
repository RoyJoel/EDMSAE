//
//  TMSys.swift
//  EDMSAE
//
//  Created by Jason Zhang on 2023/5/29.
//

import Foundation
import Reachability
import UIKit

class TMSys {
    var reachability: Reachability?
    static let shard = TMSys()
    private init() {}

    func initWindow() -> UIWindow {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = initStyle()
        window.rootViewController = initRootViewController()
        window.makeKeyAndVisible()
        return window
    }

    func enterForeground() {
        if reachability?.connection != .unavailable {
            auth()
        }
    }

    func initRootViewController() -> UIViewController {
        let isNotFirstDownload = UserDefaults.standard.bool(forKey: TMUDKeys.isNotFirstDownload.rawValue)
        if !isNotFirstDownload {
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: TMUDKeys.isNotFirstDownload.rawValue)
            }
            return EDSignInViewController()
        } else {
                return EDSignInViewController()
        }
    }

    func initStyle() -> UIUserInterfaceStyle {
            return .unspecified
    }

    func auth() {
        if let token = UserDefaults.standard.string(forKey: TMUDKeys.JSONWebToken.rawValue) {
            EDUser.auth(token: token) { userLoginName, userPassword, error in
                guard error == nil else {
                    if let window = UIApplication.shared.windows.first {
                        let signInVC = EDSignInViewController()
                        window.rootViewController = signInVC
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("The login information has expired\n please log in again", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        (window.rootViewController as? EDSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                        window.rootViewController = EDSignInViewController()
                    }
                    return
                }
                guard let userLoginName = userLoginName else {
                    return
                }
                guard let userPassword = userPassword else {
                    return
                }
                EDUser.user.loginName = userLoginName
                EDUser.user.password = userPassword
                EDUser.signIn { user, error in
                    guard error == nil else {
                        if let window = UIApplication.shared.windows.first {
                            let toastView = UILabel()
                            toastView.text = NSLocalizedString("No such loginname or password", comment: "")
                            toastView.numberOfLines = 2
                            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                            toastView.backgroundColor = UIColor(named: "ComponentBackground")
                            toastView.textAlignment = .center
                            toastView.setCorner(radii: 15)
                            (window.rootViewController as? EDSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                            }
                            window.rootViewController = EDSignInViewController()
                        }
                        return
                    }
                    guard let user = user else {
                        if let window = UIApplication.shared.windows.first {
                            let toastView = UILabel()
                            toastView.text = NSLocalizedString("Login Failed", comment: "")
                            toastView.numberOfLines = 2
                            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                            toastView.backgroundColor = UIColor(named: "ComponentBackground")
                            toastView.textAlignment = .center
                            toastView.setCorner(radii: 15)
                            (window.rootViewController as? EDSignInViewController)?.view?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                            }
                            window.rootViewController = EDSignInViewController()
                        }
                        return
                    }
                    UserDefaults.standard.set(user.token, forKey: TMUDKeys.JSONWebToken.rawValue)
                }
            }
        } else {
            if let window = UIApplication.shared.windows.first {
                let signInVC = EDSignInViewController()
                window.rootViewController = signInVC
            }
        }
    }
}

