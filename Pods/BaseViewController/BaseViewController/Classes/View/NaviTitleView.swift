//
//  SmartTitleView.swift
//  PhotoGallery
//
//  Created by yuanxiaorong on 2019/9/19.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import UIKit
import RSBaseConfig
import RSExtension

/// 导航栏位置
public enum NaviPosition {
    case left
    case right
}

public class ItemsView: UIView {
    public var margin: CGFloat
    
    public var items: [BarButtonItem]?
    public var position: NaviPosition = .left
    
    public init(margin: CGFloat = 14) {
        self.margin = margin
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(items: [BarButtonItem], position: NaviPosition) {
        self.position = position
        for view in subviews {
            view.removeFromSuperview()
        }
        items.enumerated(position: position) { (item) in
            addSubview(item.itemView)
        }
        self.items = items
    }
    
    // 更新leftItemView的控件布局
    override public func sizeToFit() {
        var leftOffsetX: CGFloat = 5
        var rightOffsetX: CGFloat = margin
        let y = bounds.midY
        let subs = (position == .left) ? subviews : subviews.reversed()
        for view in subs {
            let width = view.bounds.width
            let mid = width * 0.5
            let centerX = (position == .left) ? (leftOffsetX + mid) : (rightOffsetX + mid)
            view.center = CGPoint(x: centerX, y: y)
            leftOffsetX += width + margin
            rightOffsetX += width + margin
        }
        width = leftOffsetX
    }
}

public class NaviTitleView: UIView {
    open var barType: NaviBarView.BarType {
        didSet {
            switch barType {
            case .smartRendering:
                titleView?.alpha =  0
            default:
                titleView?.alpha = 1
                titleView?.backgroundColor = .clear
            }
        }
    }

    /// 导航栏左边View
    private lazy var leftItemsView: ItemsView = {
        let itemsView = ItemsView()
        addSubview(itemsView)
        return itemsView
    }()
   
    /// 导航栏右边View
    private lazy var rightItemsView: ItemsView = {
        let itemsView = ItemsView()
        addSubview(itemsView)
        return itemsView
    }()

    /// 导航栏titleView
    public var titleView: UIView? {
        didSet {
            if let view = oldValue  {
                view.removeFromSuperview()
            }
            if let view = titleView {
                addSubview(view)
            }
        }
    }
    
    public init(frame: CGRect, type: NaviBarView.BarType = .smartRendering) {
        barType = type
        super.init(frame: frame)
    }
    
    /// 设置导航栏按钮的间距
    public func setItemsMargin(_ margin: CGFloat, at position: NaviPosition) {
        switch position {
        case .left:
            leftItemsView.margin = margin
        case .right:
            rightItemsView.margin = margin
        }
    }
    
    /// 左按钮间距
    public var leftItemsMargin: CGFloat {
        set {
            leftItemsView.margin = newValue
        }
        get {
            return leftItemsView.margin
        }
    }
    
    /// 右按钮间距
    public var rightItemsMargin: CGFloat {
        set {
            rightItemsView.margin = newValue
        }
        get {
            return rightItemsView.margin
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        leftItemsView.height = bounds.height
        rightItemsView.height = bounds.height
        leftItemsView.sizeToFit()
        rightItemsView.sizeToFit()
        let leftSize  = leftItemsView.frame.size
        let rightSize = rightItemsView.frame.size
        
        let margin: CGFloat = 14
        leftItemsView.frame = CGRect(origin: CGPoint(x: margin, y: 0), size: leftSize)
        rightItemsView.frame = CGRect(origin: CGPoint(x: bounds.maxX - rightSize.width - margin, y: 0), size: rightSize)
        
        if let view = titleView {
            let maxMinW = min(abs(bounds.midX - rightItemsView.frame.minX), abs(bounds.midX - leftItemsView.frame.maxX))
            view.frame = CGRect(x: bounds.midX - maxMinW, y: 0, width: maxMinW * 2, height: bounds.height)
        }
    }
    
}

extension NaviTitleView {
    /// 导航栏文本Label
    public var titleLabel: UILabel? {
        return titleView as? UILabel
    }
    
    /// 导航栏文字
    public var title: String? {
        set {
            if titleView == nil {
                if newValue?.isEmpty ?? true { return }
                let label = UILabel.init()
                label.font = UIFont.systemFont(ofSize: 17)
                label.textAlignment = .center
                label.textColor = 0x222222.uiColor
                label.text = newValue
                titleView = label
            } else {
                if titleLabel?.text == newValue { return }
                titleLabel?.text = newValue
                setNeedsLayout()
            }
        }
        get {
            return titleLabel?.text
        }
    }
    
    /// 左边的按钮items
    public var leftItems: [BarButtonItem]? {
        set {
            leftItemsView.update(items: newValue ?? [], position: .left)
            setNeedsLayout()
        }
        get {
            return leftItemsView.items
        }
    }
    
    /// 右边的按钮items
    public var rightItems: [BarButtonItem]? {
        set {
            rightItemsView.update(items: newValue ?? [], position: .right)
            setNeedsLayout()
        }
        get {
            return rightItemsView.items
        }
    }
    
}

/// 更新NaviTitleView视图的模型
extension NaviTitleView {
    public func updateItems(_ items: [BarButtonItem], for position: NaviPosition = .left) {
        switch position {
        case .left:
            leftItemsView.update(items: items, position: position)
            setNeedsLayout()
        case .right:
            rightItemsView.update(items: items, position: position)
            setNeedsLayout()
        }
    }
}

extension NaviTitleView: NaviSubView {

    public func updateRendering(progress: CGFloat) {
        /// 这里控制导航栏显示与隐藏...
        if barType == .smartRendering {
            titleView?.alpha = progress
        }
    }
}

fileprivate extension Array {
    func enumerated(position: NaviPosition, block: (_: Element) -> Void) {
        switch position {
        case .right:
            for item in self.enumerated().reversed() {
                block(item.element)
            }
        default:
            for item in self {
                block(item)
            }
        }
    }
}

