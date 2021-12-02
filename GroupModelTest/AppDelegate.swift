//
//  AppDelegate.swift
//
//  Created by cfans on 2018/9/25.
//  Copyright © 2018年 cfans. All rights reserved.
//

import UIKit

@UIApplicationMain
@objcMembers class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// 设置根试图
        setupKeyWindow()

        #if DEBUG
        do {
            let injectionBundle = Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")
            if let bundle = injectionBundle {
                try bundle.loadAndReturnError()
                print("Injection注入成功 🎉🎉🎉")
            } else{
                print("Injection注入失败,未能检测到Injection 🥀")
            }
        } catch {
            print("Injection注入失败\(error) 🥀")
        }
        #endif

        return true
    }
}

// MARK: - 设置窗口的根控制器
extension AppDelegate {
    private func setupKeyWindow(_ index: Int = 0) {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        let nav = NavigationController(rootViewController: ViewController())
        window?.rootViewController = nav
    }
}

