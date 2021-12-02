//
//  BaseWebViewController.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2020/8/2.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit
import WebKit
import RSBaseConfig
import RSExtension
import BaseViewController

class BaseWebViewController: BaseViewController {
    
    /// 是否设置了代理和监听
    private var hasAddObserver: Bool = false
    /// 当前的请求
    var currentRequest: URLRequest?
    /// 请求的url
    var requestUrlStr: String? {
        get {
            return currentRequest?.url?.absoluteString
        }
        set {
            guard var urlStr = newValue else {
                currentRequest = nil
                return
            }

            if isNeedURLEncode {
                urlStr = urlStr.urlEncoded()
            }
            
            if let url = URL.init(string: urlStr) {
                debugPrint("🍗🍗🍗 请求的url = \(urlStr) 🍗🍗🍗")
                let request = URLRequest.init(url: url)
                
                currentRequest = request
                if webView.superview != nil {
                    webView.load(request)
                }
            }
        }
    }
    
    /// 是否需要导航栏
    public var isHiddenNav: Bool = false {
        didSet {
            navi_topView.isHidden = isHiddenNav
            progressView.isHidden = isHiddenNav
            viewWillLayoutSubviews()
        }
    }
    
    /// 是否需要URL编码
    public var isNeedURLEncode: Bool = true

    /// 导航栏barStyle样式
    internal var barStyle: UIStatusBarStyle = .default
    /// 关闭整个webView的barItem
    internal var closeItem: BarButtonItem?
    
    /// 便捷构造器
    convenience init(url: String, isNeedURLEncode: Bool = true, barStyle: UIStatusBarStyle = .default) {
        self.init()
        self.barStyle = barStyle
        self.isNeedURLEncode = isNeedURLEncode
        self.requestUrlStr = url
                
        configWebView()
    }
    
    convenience init(url: String, isNeedURLEncode: Bool = true, barStyle: UIStatusBarStyle = .default, rightItem: BarButtonItem) {
        self.init(url: url, isNeedURLEncode: isNeedURLEncode, barStyle: barStyle)
        self.rightItem = rightItem
    }
    
    convenience init(url: String, isNeedURLEncode: Bool = true, barStyle: UIStatusBarStyle = .default, barView: UIView) {
        self.init(url: url, isNeedURLEncode: isNeedURLEncode, barStyle: barStyle)
        navi_topView.insertSubview(barView, at: 0)
    }
    
    convenience init(url: String, isNeedURLEncode: Bool = true, barStyle: UIStatusBarStyle = .default, rightItem: BarButtonItem, barView: UIView) {
        self.init(url: url, isNeedURLEncode: isNeedURLEncode, barStyle: barStyle, rightItem: rightItem)
        navi_topView.insertSubview(barView, at: 0)
    }
    
    internal func configWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new , context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        hasAddObserver = true
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    //MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        navi_topView.backgroundColor = .white
        
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(progressView)
        
        if let request = currentRequest {
            webView.load(request)
        }
    }
    
    override func setupNavi() {
        super.setupNavi()
        
        let backItem = BarButtonItem(icon: UIImage(named: "common_back"), config: { (barButton) in
            barButton.enlargeEdge = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 10)
            barButton.size = CGSize(width: 22, height: 24)
        }) { [ weak self] (_) in
            self?.dismiss()
        }
        
        let closeItem = BarButtonItem(icon: UIImage(named: "common_navclose"), config: { (barButton) in
            barButton.enlargeEdge = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
            barButton.size = CGSize(width: 22, height: 24)
        }) { [ weak self] (_) in
            self?.closePage()
        }
        closeItem.isHidden = true
        self.closeItem = closeItem
        
        leftItems = [backItem, closeItem]
    }
        
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var y: CGFloat = navbarMaxY
        if isHiddenNav {
            y = statusBarH
        }
        webView.frame = CGRect(x: 0, y: y, width: screenWidth, height: screenHeight - y)
        progressView.frame = CGRect(x: 0, y: navbarMaxY, width: screenWidth, height: 1.5)
    }
    
    deinit {
       if hasAddObserver {
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
            webView.removeObserver(self, forKeyPath: "title")
            webView.removeObserver(self, forKeyPath: "canGoBack")
        }

        print("######\(self.classForCoder) ☠️☠️☠️ 已销毁~~~~~~~~~~~~~~~~~~~~~~~~~~ 请求地址 = \(requestUrlStr ?? "") 界面导航栏标题 = \(title ?? "")")
    }
    
    //MARK: - Pravite Method
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1.0
            print(Float(self.webView.estimatedProgress))
            progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
        
        if keyPath == "title" {
            if object as? WKWebView == webView {
                title = webView.title ?? ""
                
                if barStyle == .default {
                    smartTitleView?.titleLabel?.textColor = UIColor.black
                    smartTitleView?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                    leftItem?.updateButtonIcon(icon: UIImage.navBack)
                    closeItem?.updateButtonIcon(icon: UIImage(named: "common_navclose"))
                } else {
                    smartTitleView?.titleLabel?.textColor = UIColor.white
                    smartTitleView?.titleLabel?.font = UIFont.medium(17)
//                    smartTitleView?.titleLabel?.adjustsFontSizeToFitWidth = true
                    leftItem?.updateButtonIcon(icon: UIImage.navBackWhite)
                    closeItem?.updateButtonIcon(icon: UIImage(named: "common_navclose_white"))
                }
            }
        }
        
        if keyPath == "canGoBack" {
            if let closeItem = closeItem {
                closeItem.isHidden = !webView.canGoBack
            }
        }
    }
    
    //MARK: - Event Method
    @objc func refreshAction() {
        if let requestUrlStr = requestUrlStr {
            if let url = URL.init(string: requestUrlStr) {
                let request = URLRequest.init(url: url)
                webView.load(request)
            }
        }
    }
    
    // MARK: - Getting and Setting
    // webView
    private(set) lazy var webView: WKWebView = {
        let webView = WKWebView.init(frame: CGRect.zero)
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = UIColor.white
        webView.scrollView.backgroundColor = UIColor.white
        return webView
    }()
    
    private(set) lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = 0x0091FF.uiColor
        progressView.trackTintColor = UIColor.white
        return progressView
    }()
    
}

// MARK: - WKUIDelegate
extension BaseWebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertVc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定".localized, style: .default) { (action) in
            completionHandler()
        }
        alertVc.addAction(action)
        present(alertVc, animated: true, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertVc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定".localized, style: .default) { (action) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "取消".localized, style: .default) { (action) in
            completionHandler(false)
        }
        alertVc.addAction(sureAction)
        alertVc.addAction(cancelAction)
        present(alertVc, animated: true, completion: nil)
        
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertVc = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定".localized, style: .default) { (action) in
            completionHandler(alertVc.textFields?.last?.text)
        }
        alertVc.addAction(action)
        present(alertVc, animated: true, completion: nil)
    }
}

//MARK: - WKNavigationDelegate
extension BaseWebViewController: WKNavigationDelegate {
    // 服务器开始请求的时候调用
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    // 进度条代理事件
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
    }
    
    // 内容返回时调用
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    // 开始加载
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    // 跳转失败的时候调用
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    // 服务器请求跳转的时候调用
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    // 加载成功时
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
    }
    
    // 内容加载失败时候调用
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}

extension BaseWebViewController {
    @objc func dismiss() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            closePage()
        }
    }
    
    @objc func closePage() {
        if (navigationController?.children.count ?? 0) > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            (navigationController ?? self).dismiss(animated: true, completion: nil)
        }
    }
}

public extension String {
    // 将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    // 将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
