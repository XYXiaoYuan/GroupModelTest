//
//  CustomModalViewController.swift
//  AlertViewComponent
//
//  Created by 袁小荣 on 2020/7/16.
//

import UIKit
import Foundation
import RSBaseConfig

public extension UIBlurEffect.Style {
    static var mcStyle: Self {
        if #available(iOS 13.0, *) {
            return .systemUltraThinMaterial
        } else {
            // Fallback on earlier versions
            return .light
        }
    }
}

open class CustomModalViewController: UIViewController {
    private var presented: Bool = false
    
    /// 黑色背景
    public lazy var bgView: UIView = {
        let v = UIView.init()
        v.alpha = 0.0
        let maxWidth = max(screenWidth, screenHeight)
        let minWidth = min(screenWidth, screenHeight)
        v.frame = CGRect.init(x: 0.0, y: 0.0, width: minWidth, height: maxWidth)
        v.center = self.view.center
        return v
    }()

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("######\(self.classForCoder) ☠️☠️☠️ 已销毁~~~~~~~~~~~~~~~~~~~~~~~~~~")
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CustomModalViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presented = true
        return self
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presented = false
        return self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pVc = CoustomPresentationController.init(presentedViewController: presented, presenting: presenting)
        
        return pVc
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension CustomModalViewController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerV = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        let handle = {(finish: Bool) in
            transitionContext.completeTransition(finish)
        }
        
        if self.presented {
            // 消失动画
            self.customDismiss(container: containerV, duration: duration, completeHandle: handle)
        } else {
            // 展示动画
            self.customPresent(container: containerV, duration: duration, completeHandle: handle)
        }
    }
}

// MARK: - 子类实现跳转
extension CustomModalViewController {
    @objc open func customPresent(container: UIView, duration: TimeInterval, completeHandle: @escaping ((_ finish: Bool) -> Void)) {
        let transf = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height)
        self.view.transform = transf
        
        UIView.animate(withDuration: duration, animations: {
             self.view.transform = CGAffineTransform.identity
        }, completion: completeHandle)
        
    }
    @objc open func customDismiss(container: UIView, duration: TimeInterval, completeHandle: @escaping ((_ finish: Bool) -> Void)) {
        UIView.animate(withDuration: duration, animations: {
            self.view.alpha = 0.0
            self.bgView.alpha = 0.0
        }, completion: completeHandle)
    }
}

/// 转场控制器
class CoustomPresentationController: UIPresentationController {
    override func containerViewDidLayoutSubviews() {
        self.presentedView?.frame = self.containerView?.bounds ?? UIScreen.main.bounds
    }
    
    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.presentedView ?? UIView.init())
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        self.containerView?.removeFromSuperview()
    }
    
    override var presentationStyle: UIModalPresentationStyle {
        return .custom
    }
}
