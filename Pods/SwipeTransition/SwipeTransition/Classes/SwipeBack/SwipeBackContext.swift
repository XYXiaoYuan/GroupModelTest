//
//  SwipeBackContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171227.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class SwipeBackContext: Context<UINavigationController>, ContextType {
    // Delegate Proxies (strong reference)
    var navigationControllerDelegateProxy: NavigationControllerDelegateProxy? {
        didSet {
            target?.delegate = navigationControllerDelegateProxy
        }
    }

    weak var pageViewControllerPanGestureRecognizer: UIPanGestureRecognizer?

    override var allowsTransitionStart: Bool {
        guard let navigationController = target else { return false }
        return navigationController.viewControllers.count > 1 && super.allowsTransitionStart
    }

    func allowsTransitionFinish(recognizer: UIPanGestureRecognizer) -> Bool {
        guard let view = targetView else { return false }
        /// 这里控制侧滑 灵敏度
        let p = recognizer.translation(in: view).x
       
        if p < 60 {
            return false
        }
        
        let v = recognizer.velocity(in: view).x
        return v > 400
    }

    func didStartTransition() {
        target?.popViewController(animated: true)
    }

    func updateTransition(recognizer: UIPanGestureRecognizer) {
        guard let view = targetView, isEnabled else { return }
        let translation = recognizer.translation(in: view)
        interactiveTransition?.update(value: translation.x, maxValue: view.bounds.width)
    }
}
