//
//  BarButtonItem.swift
//  PhotoGallery
//
//  Created by yuanxiaorong on 2019/10/16.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import UIKit
import Foundation
import RSBaseConfig
import RSExtension

/// 左右的buttonItem
public class BarButtonItem: NSObject {
    /// 按钮配置闭包
    public typealias ItemConfig = (_ btn: NaviBarButton) -> Void
    /// 按钮点击闭包
    public typealias ItemAction = (_ item: BarButtonItem) -> Void

    /// 绑定事件
    public var action: ItemAction?
    /// 自定义view
    private var barItemView: UIView!
    
    public var itemView: UIView! {
        return barItemView
    }
    
    deinit {
        (barItemView as? NaviBarButton)?.cacheForUse()
    }
    
    // 注意:尾随闭包的最后一个参数 action,要使用 weak 不然会有内存泄漏
    /// 设置左右的buttonItem
    /// - Parameters:
    ///   - icon: 图标,传UIImage
    ///   - title: 文字
    ///   - config: 按钮配置,可以拿到按钮做任何事情
    ///   - customSize: 自定义按钮大小
    ///   - action: 按钮事件
    public init(icon: UIImage? = nil, title: String? = nil, config: ItemConfig? = nil, customSize: CGSize? = nil, action: ItemAction?) {
        super.init()
        let btn = NaviBarButton.getReusedButton()
        btn.setTitle(title, for: .normal)
        if let icon = icon {
            btn.setImage(icon, for: .normal)
        }
        btn.sizeToFit()
        config?(btn)
        
        if let size = customSize {
            btn.bounds = CGRect(origin: .zero, size: size)
        }
        self.action = action
        self.barItemView = btn
        btn.addTarget(self, action: #selector(btnItemClick), for: .touchUpInside)
    }
    
    public init(customView: UIView) {
        self.action = nil
        self.barItemView = customView
    }
    
    public func updateButtonIcon(icon: UIImage?) {
        if let icon = icon {
            (barItemView as? UIButton)?.setImage(icon, for: .normal)
            barItemView.sizeToFit()
        }
    }
    
    public func updateTitile(_ title: String?) {
        (barItemView as? UIButton)?.setTitle(title, for: .normal)
        barItemView.sizeToFit()
    }
    
    @objc private func btnItemClick() {
        action?(self)
    }
}

extension BarButtonItem {
    private var barButton: NaviBarButton? {
        return barItemView as? NaviBarButton
    }
    
    /// 是否隐藏
    public var isHidden: Bool {
        set {
            barItemView.isHidden = newValue
        }
        get {
            return barItemView.isHidden
        }
    }
    
    /// 是否选中
    public var isSelected: Bool {
        set {
            barButton?.isSelected = newValue
        }
        get {
            return barButton?.isSelected ?? false
        }
    }
    
    /// 是否可用
    public var isEnabled: Bool {
        set {
            barButton?.isEnabled = newValue
        }
        get {
            return barButton?.isEnabled ?? true
        }
    }
    
}

/// 左右按钮,可以扩大点击区域(做了重用池重用)
public class NaviBarButton: EnlargeEdgeButton {
    
    /// 重用池
    private static let reusePool: NSMutableSet = NSMutableSet(capacity: 1)
    
    /// 获取重用的button
    internal static func getReusedButton() -> Self {
        guard let btn = reusePool.anyObject() as? Self else {
            return Self()
        }
        reusePool.remove(btn)
        btn.reset()
        return btn
    }
    
    /// 加入缓存池
    internal func cacheForUse() {
        Self.reusePool.add(self)
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        normaConfig()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func normaConfig() {
        titleLabel?.font = UIFont.systemFont(ofSize: 17.auto())
        setTitleColor(UIColor.black, for: .normal)
    }
    
    private func reset() {
        isHidden = false
        isSelected = false
        isEnabled = true
        alpha = 1
        let states: [UIControl.State] = [.normal, .selected, .disabled, .highlighted]
        states.forEach { setTitle(nil, for: $0); setImage(nil, for: $0) }
        normaConfig()
    }
}


