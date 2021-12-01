//
//  NaviBarViewController.swift
//  PhotoGallery
//
//  Created by yuanxiaorong on 2019/9/9.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import UIKit
import RSBaseConfig
import RSExtension

open class NaviBarViewController: UIViewController {
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
        setupNavi()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("######\(self.classForCoder) ☠️☠️☠️ 已销毁~~~~~~~~~~~~~~~~~~~~~~~~~~")
    }
    
    open lazy var navi_topView: NaviBarView = {
        let bar = NaviBarView.init(frame: naviBarFrame())
        bar.initalNavHeight = naviBarFrame().height
        bar.backgroundColor = .clear
        bar.delegate = self
        return bar
    }()
    
    private var lastViewFrame: CGRect = .zero
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 直接隐藏导航栏
        navigationController?.isNavigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(navi_topView)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubviewToFront(navi_topView)
        navigationController?.isNavigationBarHidden = true
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if lastViewFrame == UIScreen.main.bounds { return }
        view.frame = UIScreen.main.bounds
        lastViewFrame = view.frame
        navi_topView.frame = naviBarFrame()
        navi_topView.setNeedsLayout()
        view.bringSubviewToFront(navi_topView)
    }
        
    /// 子类实现
    @objc open func setupNavi() {
        /// 初始化导航栏...
    }
    
    /// 子类实现的
    @objc open func naviBarFrame() -> CGRect {
        return .init(origin: .zero, size: .init(width: screenWidth, height: navbarMaxY))
    }
}

extension NaviBarViewController: NaviBarContentViewDelegate {
    open func naviBarViewDidUpdateContentFrame(_ naviBar: NaviBarView, contentFrame: CGRect) {
        
    }
    
    open func naviBarViewSmartContentHeight(_ naviBar: NaviBarView) -> CGFloat {
        return 64
    }
}

extension NaviBarViewController {
    public var smartTitleView: NaviTitleView? {
        return (navi_topView.contentSubView as? NaviTitleView)
    }

    public var leftItem: BarButtonItem? {
        set {
            smartTitleView?.leftItems = newValue == nil ? nil : [newValue!]
        }
        get {
            return smartTitleView?.leftItems?.first
        }
    }
    
    public var leftItems: [BarButtonItem]? {
        set {
            smartTitleView?.leftItems = newValue
        }
        get {
            return smartTitleView?.leftItems
        }
    }
    
    public var rightItem: BarButtonItem? {
        set {
            smartTitleView?.rightItems = newValue == nil ? nil : [newValue!]
        }
        get {
            return smartTitleView?.rightItems?.first
        }
    }
    
    public var rightItems: [BarButtonItem]? {
        set {
            smartTitleView?.rightItems = newValue
        }
        get {
            return smartTitleView?.rightItems
        }
    }
}

extension NaviBarViewController {
    /// 设置导航栏透明
    public func setNaviBgClear() {
        navi_topView.backgroundColor = .clear
        navi_topView.contentSubView?.backgroundColor = .clear
    }
}
