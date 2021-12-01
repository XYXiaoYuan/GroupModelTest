//
//  UIImageView+Extension.swift
//  MCExtension
//
//  Created by sessionCh on 2020/5/7.
//

import UIKit


public extension UIImageView {
    /// 旋转动画
    func rotateAnimation() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        rotation.isRemovedOnCompletion = false
        layer.add(rotation, forKey: "kRotationAnimation")
    }
    
    func removeAnimation() {
        layer.removeAllAnimations()
    }
}


public extension UIImageView {
    
    typealias LoadingViewClosure = (UIView?) -> Void
    
    /// 添加一个点击View，需要自己设置view的frame
    /// - Parameters:
    ///   - view: view
    ///   - closure: 点击之后触发的回调
    func addLoadFailedView(_ view: UIView, tapClosure: @escaping LoadingViewClosure) {
        // 去重处理
        guard subviews.first(where: { $0.tag == placeholderTag }) == nil else { return }
        
        // 设置底部视图
        let tapView = UIView(frame: bounds)
        tapView.tag = placeholderTag
        addSubview(tapView)
        view.isHidden = true
        tapView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5)
        
        // 添加tapGesture
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLoadingView))
        tapView.addGestureRecognizer(tapGesture)
        
        // 保存closure
        self.tapPlaceholderViewClosure = tapClosure
        
        // 把视图添加进去
        view.tag = loadFailedTag
        tapView.addSubview(view)
    }
    
    /// 添加一张图片, 可传空 传空就什么都不显示
    /// - Parameters:
    ///   - image: 图片
    ///   - frame: 大小位置
    ///   - closure: 点击之后触发的回调
    func addLoadFailedImage(_ image: UIImage?, frame: CGRect, tapClosure: @escaping LoadingViewClosure) {
        let imgView = UIImageView(frame: frame)
        imgView.image = image
        addLoadFailedView(imgView, tapClosure: tapClosure)
    }
    
    
    /// 显示加载失败的视图
    func showLoadFailedView() {
        guard let view = placeholderView else { return }
        view.subviews.forEach { $0.isHidden = false }
        bringSubviewToFront(view)
    }
    
    /// 隐藏加载失败的视图
    func hiddenLoadFailedView() {
        guard let view = placeholderView else { return }
        view.subviews.forEach { $0.isHidden = true }
        sendSubviewToBack(view)
        // 移除上一次的视图
        view.subviews.forEach {
            // 不要把失败这张图片移除
            if $0.tag != loadFailedTag {
                $0.removeFromSuperview()
            } else {
                $0.isHidden = true
            }
        }
    }
    
    /// 显示加载动画
    /// - Parameters:
    ///   - animation: 是否使用动画
    ///   - style: 样式
    func showLoadingIndicatorView(_ animation: Bool, style: UIActivityIndicatorView.Style = .gray) {
        // 移除上一次的视图
        let indicatorView = UIActivityIndicatorView(style: style)
        indicatorView.center = placeholderView?.center ?? .zero
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        
        showLoadingView(animation, view: indicatorView)
    }
    
    /// 显示加载图片，图片会自动旋转（如果animation设置为YES）
    /// - Parameters:
    ///   - animation: 是否旋转图片
    ///   - image: 图片
    ///   - size: 图片大小
    func showLoadingImage(_ animation: Bool, image: UIImage?, size: CGSize = .zero) {
        
        let imgView = UIImageView(image: image)
        if size != .zero {
            imgView.frame.size = size
        }
        imgView.center = placeholderView?.center ?? .zero
        
        
        if animation {
            let animation = UIImageView.baseAnimationWithKeyPath("transform.rotation.z", fromValue: 0, toValue: Double.pi * 2, duration: 2, repeatCount: 100000)
            imgView.layer.add(animation, forKey: "rotation.z")
        }
        
        showLoadingView(animation, view: imgView)
        
    }
    
    /// 显示加载视图，内部不作任何控制
    /// - Parameters:
    ///   - animation: 是否旋转图片
    ///   - view: 视图
    func showLoadingView(_ animation: Bool, view: UIView?) {
        // 设置为可显示
        guard let placeholderView = placeholderView, let subView = view else { return }
        placeholderView.subviews.forEach { $0.isHidden = false }
        bringSubviewToFront(placeholderView)
        
        // 判断是否需要动画
        if animation {
            // 移除上一次的视图
            placeholderView.subviews.forEach {
                // 不要把失败这张图片移除
                if $0.tag != loadFailedTag {
                    $0.removeFromSuperview()
                }
            }
            // 添加新视图
            placeholderView.addSubview(subView)
        }
        
    }
    
    /// 移除添加的视图
    func removeLoadingView() {
        let view = subviews.first { $0.tag == placeholderTag }
        view?.removeFromSuperview()
    }
    
    // 响应tapGesture的视图
    private var placeholderTag: Int {
        return 100001
    }
    
    // 加载失败的那种图片
    private var loadFailedTag: Int {
        return 100002
    }
    
    // 响应tapGesture的视图
    private var placeholderView: UIView? {
        return subviews.first { $0.tag == placeholderTag }
    }
    
    // 为保存closure所定义的全局变量
    private static  var placeholderString = "UIImageView.placeholderString"
    private var tapPlaceholderViewClosure: LoadingViewClosure? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.placeholderString) as? LoadingViewClosure
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.placeholderString, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 动画处理类
    private class func baseAnimationWithKeyPath(_ path: String,
                                               fromValue: Any?,
                                               toValue: Any?,
                                               duration: CFTimeInterval,
                                               repeatCount: Float = 0,
                                               timingFunction: CAMediaTimingFunctionName = .linear,
                                               fillMode: CAMediaTimingFillMode = .both)
        -> CABasicAnimation {
            
            let animate = CABasicAnimation(keyPath: path)
            //起始值
            animate.fromValue = fromValue;
            //变成什么，或者说到哪个值
            animate.toValue = toValue
            //动画时长
            animate.duration = duration
            //重复次数 Float.infinity 一直重复 OC：HUGE_VALF
            animate.repeatCount = repeatCount
            animate.timingFunction = .init(name: timingFunction)
            animate.fillMode = fillMode
            return animate
            
    }
    
    /// 触摸响应
    @objc private func tapLoadingView(tapGesture: UITapGestureRecognizer) {
        tapPlaceholderViewClosure?(tapGesture.view)
    }
}
