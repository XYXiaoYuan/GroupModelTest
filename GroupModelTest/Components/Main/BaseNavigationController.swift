//
//  BaseNavigationController.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2020/7/19.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit
import SwipeTransition

extension UIViewController {
    @objc func mc_willBePush(navigationController: UINavigationController) {
        // sub class
    }
}

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        swipeBack = SwipeBackController(navigationController: self)
        
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if let navigationController = navigationController {
            /// 防止界面因卡顿,导致同一界面被多次push
            guard navigationController.topViewController == self else {
                return
            }
        }
        super.performSegue(withIdentifier: identifier, sender: sender)
    }
        
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.isEmpty {
            willPushRootViewController(viewController)
        } else {
            //interactivePopGestureRecognizer?.isEnabled = false
            viewController.hidesBottomBarWhenPushed = true
            willPushViewController(viewController)
        }
        
        super.pushViewController(viewController, animated: animated)
        
        viewController.mc_willBePush(navigationController: self)
    }

    open func willPushViewController(_ viewCtroller: UIViewController) {
        
    }
    open func willPushRootViewController(_ viewCtroller: UIViewController) {
        
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count > 1
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return swipeBack?.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeBack?.navigationController(navigationController, interactionControllerFor: animationController)
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        swipeBack?.navigationController(navigationController, willShow: viewController, animated: animated)
    }

}
