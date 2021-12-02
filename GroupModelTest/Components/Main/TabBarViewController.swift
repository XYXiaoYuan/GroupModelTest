//
//  TabBarViewController.swift
//  GroupModelTest
//
//  Created by 袁小荣 on 2021/12/3.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit
import Foundation

struct TabbarItem {
    let rootVcType: UIViewController.Type
    let iconName: String
    let selectIconName: String
    let title: String
    
    init(vcType: UIViewController.Type, iconName: String, title: String) {
        self.rootVcType = vcType
        self.iconName = iconName
        self.selectIconName = iconName.appending("_pre")
        self.title = title
    }
}

class TabBarViewController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewControllers()
    }
    
    private func addViewControllers() {
        let items = tabbarItems()
        
        for i in 0..<items.count {
            let item = items[i]
            let vc = item.rootVcType.init()
            
            if !item.iconName.isEmpty {
                let bar = vc.tabBarItem as UITabBarItem
                bar.setTitleTextAttributes([.foregroundColor: 0x929AA4.uiColor, .font: UIFont.regular(10)], for: .normal)
                bar.setTitleTextAttributes([.foregroundColor: 0x0091FF.uiColor, .font: UIFont.medium(10)], for: .selected)
                bar.image = UIImage(named: item.iconName)
                
                bar.tag = i
            }
            let navc  = NavigationController(rootViewController: vc)
            navc.tabBarItem.title = item.title
            navc.isNavigationBarHidden = true
            addChild(navc)
        }
    }
    
    private func tabbarItems() -> [TabbarItem] {
        return [
            TabbarItem(vcType: ViewController.self, iconName: "tabbar_home", title: "首页".localized),
            TabbarItem(vcType: ViewController.self, iconName: "tabbar_category", title: "分类".localized),
            TabbarItem(vcType: ViewController.self, iconName: "tabbar_shopcar", title: "购物车".localized),
            TabbarItem(vcType: ViewController.self, iconName: "tabbar_mine", title: "我的".localized),
        ]
    }
    
    private func setupTabBarShadowImage() {
        let shadowImage = UIImage.imageFromColor(color: UIColor.clear)
        if #available(iOS 13, *) {
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: 0x929AA4.uiColor, .font: UIFont.regular(10)]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: 0x0091FF.uiColor, .font: UIFont.medium(10)]
            appearance.stackedLayoutAppearance.normal.badgeTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.medium(10)]
            appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = 0xF5542E.uiColor
            appearance.stackedLayoutAppearance.normal.badgePositionAdjustment = .init(horizontal: 3, vertical: 0)
            let backgroundImage = UIImage.imageFromColor(color: UIColor.white)
            appearance.backgroundImage = backgroundImage
            appearance.shadowImage = shadowImage
            tabBar.standardAppearance = appearance
        } else {
            //IOS13以下，加这个就没毛玻璃
            let appearance = UITabBar.appearance()
            appearance.shadowImage = UIImage()
        }
    }
}
