//
//  NavigationController.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2020/7/19.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit
import BaseViewController

class NavigationController: BaseNavigationController {

    /// 即将push
    override func willPushViewController(_ viewController: UIViewController) {
        /// 设置导航栏返回按钮
        if let vc = (viewController as? BaseViewController) {
            _ = vc.view
            guard vc.leftItems == nil else { return }
            let image = UIImage(named: "common_back")
            let backItem = BarButtonItem(icon: image, config: { (barButton) in
                barButton.enlargeEdge = UIEdgeInsets(top: 18, left: 14, bottom: 14, right: 18)
            }) { [ weak vc] (_) in
                vc?.mc_normalNaviGoBack()
            }
            vc.leftItem = backItem
        }
    }
        
    @objc func popViewController(_ sender: Any) {
        popViewController(animated: true)
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set {
            super.modalPresentationStyle = newValue
        }
        get {
            return children.first?.modalPresentationStyle ?? super.modalPresentationStyle
        }
    }

}

fileprivate extension UIViewController {
    @objc func mc_normalNaviGoBack() {
        navigationController?.popViewController(animated: true)
    }
}
