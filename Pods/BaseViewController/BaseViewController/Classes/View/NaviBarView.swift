//
//  NaviBarView.swift
//  PhotoGallery
//
//  Created by yuanxiaorong on 2019/9/19.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import UIKit
import RSBaseConfig
import RSExtension

@objc public protocol NaviBarContentViewDelegate: NSObjectProtocol {
    
    @objc optional func naviBarViewDidUpdateContentFrame(_ naviBar: NaviBarView, contentFrame: CGRect)
    
    @objc func naviBarViewSmartContentHeight(_ naviBar: NaviBarView) -> CGFloat
}

public protocol NaviSubView: UIView {
    /// 类型
    var barType: NaviBarView.BarType { get }
    
    /// 消失隐藏
    func updateRendering(progress: CGFloat)
}

extension NaviBarView {
   public enum BarType {
        /// 静态
        case staticDisplay
        /// 动态显示(iOS11大标题效果)
        case smartRendering
        /// 动态漂浮
        case dynamicFloating
        /// 高于navbarMaxY导航栏,上滑只显示高度为navbarMaxY的样式
        case scrollFloating
    }
}

open class NaviBarView: UIView {
   
    open var type: BarType {
        return contentSubView?.barType ?? .staticDisplay
    }
    
    weak public var delegate: NaviBarContentViewDelegate?
    public var leftRightMargin: CGFloat = 0 {
        didSet {
            contentSubView?.frame = CGRect.init(x: leftRightMargin, y: contentSubView?.y ?? 0.0, width: frame.width - leftRightMargin * 2, height: contentSubView?.height ?? 0.0)
        }
    }

    /// 整个导航栏(加状态栏): 对外可读写的
    public var contentSubView: NaviSubView? {
        didSet {
            if let subView = oldValue {
                subView.removeFromSuperview()
            }
            if let subView = contentSubView {
                contentView.addSubview(subView)
            }
        }
    }
    
    /// 整个导航栏(加状态栏): 只读
    public private(set) lazy var contentView: UIView = {
        let view = UIView()
        /// config contentView
        return view
    }()

    /// 状态栏
    public lazy var statusBar: UIView = {
        let view = UIView.init()
        view.backgroundColor = .clear
        return view
    }()
    
    public var tempContentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let v = tempContentView {
                v.frame = bounds
                super.addSubview(v)
            }
        }
    }
        
    /// 整个导航的高度
    public var contentSize: CGSize {
        return contentView.bounds.size
    }
    
    /// 整个导航栏初始高度
    internal var initalNavHeight: CGFloat = navbarMaxY
    
    private var lastOffset: CGPoint?
    private var totalOffset: CGFloat = 0.0
    private var isAnimating: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        super.addSubview(contentView)
        super.addSubview(statusBar)
        let top =  screenWidth < screenHeight ? statusBarH : 0.0
        statusBar.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: top))
        contentView.frame = CGRect.init(x: 0, y: top, width: frame.width, height: frame.height - top)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override public func addSubview(_ view: UIView) {
//        #if DEBUG
//        objc_exception_throw(NSError.init(domain: "- [NaviBarView addSubview] is unavailable. using 'contentView' addSubview instead! ", code: -1, userInfo: nil))
//        #endif
//        print("unavailable to addSubview, using 'contentView' addSubview instead!")
//    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let v = super.hitTest(point, with: event)
        return ( (backgroundColor ?? .clear) == .clear && v == self) ? nil : v
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setupUI()
    }
    
    private func setupUI() {
        let top = screenWidth < screenHeight ? statusBarH : 0.0
        statusBar.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: top))
        contentView.frame = CGRect.init(x: 0, y: top, width: frame.width, height: frame.height - top)
        tempContentView?.frame = CGRect.init(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        contentSubView?.frame = CGRect.init(x: leftRightMargin, y: contentSubView?.y ?? 0.0, width: frame.width - leftRightMargin * 2, height: contentSubView?.height ?? 0.0)
    }
}

extension NaviBarView {
    
    /// 滑动
    @objc open func willBeginScroll(with scrollView: UIScrollView) {
        lastOffset = scrollView.contentOffset
    }
    
    /// 滑动
    @objc open func didScroll(with scrollView: UIScrollView) {
        /// 更新标题栏
        switch type {
        case .dynamicFloating:
            /// 更新contentView隐藏
            updateContentViewFrame(with: scrollView)
        case .smartRendering:
            updateTitleView(with: scrollView)
        case .scrollFloating:
            updateNavibarHeight(with: scrollView)
        default: return
        }
    }
    
    private func updateTitleView(with scrollView: UIScrollView) {
        /// 计算progress
        let h = delegate?.naviBarViewSmartContentHeight(self) ?? 64
        let y = scrollView.contentOffset.y + scrollView.contentInset.top
        
        if y > h {
            contentSubView?.updateRendering(progress: 1)
           return
        }
        
        let minY = h * 0.667
        if y < minY  {
            contentSubView?.updateRendering(progress: 0)
            return
        }
        let p = (y - minY) / (h * 0.333)
        contentSubView?.updateRendering(progress: p)
        
    }
    
    private func updateContentViewFrame(with scrollView: UIScrollView) {

        if let lastOffset = lastOffset {

            let offsetY = scrollView.contentOffset.y - lastOffset.y
            if self.contentView.y > 0.0 {
                //往上划，把之前的下划totalOffset 清0
                totalOffset = offsetY > 0 ? totalOffset : 0
            } else if self.contentView.y < 0.0 {
                //往下划，把之前的上划totalOffset 清0
                totalOffset = offsetY < 0 ? totalOffset : 0
            }
            totalOffset += offsetY
            
            let maxOffsetY : CGFloat = 100
            if totalOffset > maxOffsetY, self.contentView.y >= 0.0, !isAnimating  {
                self.isAnimating = true
                //上划
                UIView.animate(withDuration: 0.5, animations: {
                    self.contentView.y = -statusBarH
                }) { (fin) in
                    self.totalOffset = 0.0
                    self.isAnimating = false
                    self.lastOffset = scrollView.contentOffset
                }
                
                delegate?.naviBarViewDidUpdateContentFrame?(self, contentFrame: contentView.frame)
            } else if totalOffset < -maxOffsetY, self.contentView.y < 0.0, !isAnimating {
                //下滑
                self.showContentViewAnimation(with: scrollView)
            } else {
                self.lastOffset = scrollView.contentOffset
            }
        }
        
        if scrollView.contentOffset.y <= 0 {
            var y = -(contentView.frame.height + scrollView.contentOffset.y)
            if y > statusBarH {
                y = statusBarH
            }
            
            if scrollView.contentOffset.y + scrollView.contentInset.top <= 0 {
                //当滚动到最顶部，强制显示contentView
                self.showContentViewAnimation(with: scrollView)
            }
            
            if contentView.frame.origin.y < y {
                delegate?.naviBarViewDidUpdateContentFrame?(self, contentFrame: contentView.frame)
            }
        }
    }
    
    private func showContentViewAnimation(with scrollView: UIScrollView) {
        self.isAnimating = true
        UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 1.1, options: UIView.AnimationOptions.curveLinear, animations: {
            self.contentView.y = statusBarH
        }) { (fin) in
            self.totalOffset = 0.0
            self.isAnimating = false
            self.lastOffset = scrollView.contentOffset
        }
    }
    
    private func updateNavibarHeight(with scrollView: UIScrollView) {
        
        let originHeight = initalNavHeight
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
                
        // 下滑
        if offset <= 0, offset < (originHeight - navbarMaxY) {
            if self.height == originHeight {
                return
            }
            
            UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.1, options: UIView.AnimationOptions.curveLinear, animations: {
                self.height = originHeight + CGFloat(fabs(Double(offset)))
            }, completion: nil)
        }
        
        // 上滑
        if self.height > navbarMaxY, offset < (originHeight - navbarMaxY)  {
            
            UIView.animate(withDuration: 1.1, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.1, options: UIView.AnimationOptions.curveLinear, animations: {
                self.height = originHeight - offset
            }, completion: nil)
        }
        
        // 为了提高性能,提升动效
        // 上面上滑时设置高度是在一个动画里,动画有执行时间
        // 滑动的速度太快时,初始高度可能恢复不到位,在这里重置一下
        if offset > 0, offset + navbarMaxY >= originHeight {
            self.height = navbarMaxY
        }
        
    }
}
