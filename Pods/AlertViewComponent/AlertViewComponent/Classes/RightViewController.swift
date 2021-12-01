//
//  RightViewController.swift
//  AlertViewComponent
//
//  Created by 袁小荣 on 2020/7/27.
//  从右往走推出的界面,比如筛选

import UIKit
import Foundation
import Foundation
import RSExtension

open class RightViewController: CustomModalViewController {
    
    public private(set) lazy var effectView: UIVisualEffectView = {
        let effct = UIBlurEffect(style: .mcStyle)
        let effectView = UIVisualEffectView(effect: effct)
        effectView.backgroundColor = UIColor.white//UIColor.dynamic(UIColor.white, dark: UIColor.black)
        return effectView
    }()
    
    open var contentView: UIView {
        return effectView.contentView
    }
    
    @objc open func contentViewX() -> CGFloat {
        return 85.0
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
        let x = contentViewX()
        let w = view.frame.size.width - x
        self.bgView.center = self.view.center
        
        effectView.frame = CGRect(x: x, y: 0, width: w, height: UIScreen.main.bounds.size.height)
        effectView.corner([.topLeft, .topRight], radii: 10.0)
        effectView.layer.masksToBounds = true
        effectView.setNeedsLayout()
    }
}

// MARK: - 自定义modal
extension RightViewController {
    override open func customPresent(container: UIView, duration: TimeInterval, completeHandle: @escaping ((Bool) -> Void)) {
        self.effectView.x = self.view.bounds.width
        UIView.animate(withDuration: duration, animations: {
            self.effectView.x = self.view.bounds.width - self.effectView.width
            self.bgView.alpha = 1.0
        }) { (fin) in
            completeHandle(fin)
        }
    }
    
    override open func customDismiss(container: UIView, duration: TimeInterval, completeHandle: @escaping ((Bool) -> Void)) {
        self.bgView.layer.mask = nil
        UIView.animate(withDuration: duration, animations: {
            self.effectView.x = self.view.bounds.width
            self.bgView.alpha = 0.0
        }, completion: completeHandle)
    }
}
