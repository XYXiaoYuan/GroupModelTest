//
//  BottomViewController.swift
//  AlertViewComponent
//
//  Created by 袁小荣 on 2020/7/16.
//  从下往上推出的界面,比如国家码选择

import UIKit
import Foundation
import RSExtension

open class BottomViewController: CustomModalViewController {
    
    public private(set) lazy var effectView: UIVisualEffectView = {
        let effct = UIBlurEffect(style: .mcStyle)
        let effectView = UIVisualEffectView(effect: effct)
        effectView.backgroundColor = UIColor.white//UIColor.dynamic(UIColor.white, dark: UIColor.black)
        return effectView
    }()
    
    open var contentView: UIView {
        return effectView.contentView
    }
    
    @objc open func contentViewHeight() -> CGFloat {
        return 500
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgView)
        view.addSubview(effectView)
        
        updateContentView()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if isBeingDismissed {
            return
        }
        
        view.bounds = UIScreen.main.bounds
        
        updateContentView()
    }

    open func updateContentView() {
        let bounds = view.bounds
        let h = contentViewHeight()
        self.bgView.center = self.view.center
        effectView.frame = CGRect(x: bounds.minX, y: bounds.minY + (bounds.height - h), width: bounds.width, height: h)
        effectView.corner([.topLeft, .topRight], radii: 16.0)
        effectView.layer.masksToBounds = true
        effectView.setNeedsLayout()
    }
}

// MARK: - 自定义modal
extension BottomViewController {
    override open func customPresent(container: UIView, duration: TimeInterval, completeHandle: @escaping ((Bool) -> Void)) {
        self.effectView.y = self.view.bounds.height

        UIView.animate(withDuration: duration, animations: {
            self.effectView.y = self.view.bounds.height - self.effectView.height
            
            self.bgView.alpha = 1.0
        }) { (fin) in
            completeHandle(fin)
        }
        
    }
    
    override open func customDismiss(container: UIView, duration: TimeInterval, completeHandle: @escaping ((Bool) -> Void)) {

        UIView.animate(withDuration: duration, animations: {
            self.effectView.y = self.view.bounds.height
            
            self.bgView.alpha = 0.0
        }) { (fin) in
            completeHandle(fin)
        }
        
    }
}
