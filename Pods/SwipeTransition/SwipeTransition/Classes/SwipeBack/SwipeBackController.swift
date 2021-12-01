//
//  SwipeBackController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

@objcMembers
public final class SwipeBackController: NSObject {
    public var onStartTransition: ((UIViewControllerContextTransitioning) -> Void)?
    public var onFinishTransition: ((UIViewControllerContextTransitioning) -> Void)?
    private var isFirstPageOfPageViewController: (() -> Bool)?
    
    private var swipePersent: CGFloat = 0.8
    public var allSwipeOffsetPersent: CGFloat {
        get {
            return swipePersent
        }
        set {
            if newValue < 0 {
                swipePersent = 0
            } else if newValue > 1 {
                swipePersent = 1
            } else {
                swipePersent = newValue
            }
        }
    }
    public var isEnabled: Bool {
        get { return context.isEnabled }
        set {
            context.isEnabled = newValue
            if newValue, panGestureRecognizer.view == nil {
                navigationController?.view.addGestureRecognizer(panGestureRecognizer)
            } else {
                panGestureRecognizer.view?.removeGestureRecognizer(panGestureRecognizer)
            }
        }
    }

    private lazy var animator = SwipeBackAnimator(parent: self)
    private let context: SwipeBackContext
    private lazy var panGestureRecognizer = OneFingerDirectionalPanGestureRecognizer(direction: .right, target: self, action: #selector(handlePanGesture(_:)))
    private weak var navigationController: UINavigationController?

    public required init(navigationController: UINavigationController) {
        context = SwipeBackContext(target: navigationController)
        super.init()

        self.navigationController = navigationController
        panGestureRecognizer.delegate = self

        navigationController.view.addGestureRecognizer(panGestureRecognizer)
        setNavigationControllerDelegate(navigationController.delegate)

        // Prioritize the default edge swipe over the custom swipe back
        navigationController.interactivePopGestureRecognizer.map { panGestureRecognizer.require(toFail: $0) }
    }

    deinit {
        panGestureRecognizer.view?.removeGestureRecognizer(panGestureRecognizer)
    }

    public func setNavigationControllerDelegate(_ delegate: UINavigationControllerDelegate?) {
        context.navigationControllerDelegateProxy = NavigationControllerDelegateProxy(delegates: [self] + (delegate.map { [$0] } ?? []) )
    }

    public func observePageViewController(_ pageViewController: UIPageViewController, isFirstPage: @escaping () -> Bool) {
        let scrollView = pageViewController.view.subviews
            .lazy
            .compactMap { $0 as? UIScrollView }
            .first
        scrollView?.panGestureRecognizer.require(toFail: panGestureRecognizer)
        context.pageViewControllerPanGestureRecognizer = scrollView?.panGestureRecognizer
        isFirstPageOfPageViewController = isFirstPage
    }

    @objc private func handlePanGesture(_ recognizer: OneFingerDirectionalPanGestureRecognizer) {
        //print("handlePanGesture: \(recognizer)")
        switch recognizer.state {
        case .began:
            context.startTransition()
        case .changed:
            context.updateTransition(recognizer: recognizer)
        case .ended:
            if context.allowsTransitionFinish(recognizer: recognizer) {
                context.finishTransition()
            } else {
                fallthrough
            }
        case .cancelled:
            context.cancelTransition()
        default:
            break
        }
    }
}

extension SwipeBackController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        ///print("SwipeBackController gestureRecognizerShouldBegin")
        guard context.pageViewControllerPanGestureRecognizer == nil else {
            if gestureRecognizer != context.pageViewControllerPanGestureRecognizer,
                let isFirstPage = isFirstPageOfPageViewController?(), isFirstPage,
                let view = gestureRecognizer.view, panGestureRecognizer.translation(in: view).x > 0 {
                return true
            }
            return false
        }
        /// 控制是否全屏侧滑
        if let view = gestureRecognizer.view, gestureRecognizer.location(in: view).x > view.bounds.minX + view.bounds.width * swipePersent {
            return false
        }
        return context.allowsTransitionStart
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view is UISlider || touch.view is UIButton) {
            return false
        }
        
        if let vc = touch.view?.viewController {
            return vc.isSwipeBackEnabled(gestureRecognizer, shouldReceive: touch)
        }
        
        return true
    }
}

extension SwipeBackController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return operation == .pop && context.isEnabled && context.interactiveTransition != nil ? animator : nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return context.interactiveTransitionIfNeeded()
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated, context.isEnabled {
            context.transitioning = true
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        context.transitioning = false
        panGestureRecognizer.isEnabled = navigationController.viewControllers.count > 1
    }
}


extension UIViewController {
    
    /// 是否允许侧滑手势
    ///
    /// - Parameters:
    ///   - gestureRecognizer: 手势
    ///   - touch: touch时间
    /// - Returns: yes 允许开始侧滑 no 本次侧滑手势失效
    @objc open func isSwipeBackEnabled(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
 
extension UIView {
    var viewController: UIViewController? {
        return getViewController()
    }
    
    private func getViewController() -> UIViewController? {
        guard let nextResponder = next else { return nil }
        
        if  nextResponder.isKind(of: UIViewController.self) {
            return nextResponder as? UIViewController
        }
        
       return (nextResponder as? UIView)?.getViewController()
    }
}
