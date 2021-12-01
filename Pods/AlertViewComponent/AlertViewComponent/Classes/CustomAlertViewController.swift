
//
//  CustomAlertViewController.swift
//  ChatComponent
//
//  Created by yuanxiaorong on 2020/6/30.
//

import UIKit
import SnapKit
import RSBaseConfig
import RSExtension

public protocol CustomAlertView: UIView {
    var grayBgColor: UIColor { get }
    
    var dismissWhenTouchBackground: Bool { get }
    
    func customAlertSize(at rect: CGRect) -> CGSize
    
    func dismissAlert(animated flag: Bool, completion: (() -> Void)?)
}

/// 默认实现
public extension CustomAlertView {
    var grayBgColor: UIColor {
        return UIColor.black.withAlphaComponent(0.4)
    }
    
    var dismissWhenTouchBackground: Bool {
        return false
    }
    
    func dismissAlert(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIViewController.currentViewController()?.dismiss(animated: flag, completion: completion)
        }
    }
}

public class CustomAlertViewController: CustomModalViewController {
    // MARK: - Properties
    let customView: CustomAlertView
    
    // MARK: - Life Cycle
    public init(customView: CustomAlertView) {
        self.customView = customView
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgViewGrayColor = customView.grayBgColor
        bgView.backgroundColor = bgViewGrayColor
        view.addSubview(bgView)
        bgView.addSubview(customView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        customView.snp.makeConstraints { (make) in
            let size = customView.customAlertSize(at: view.bounds)
            make.size.equalTo(size)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if customView.dismissWhenTouchBackground,
            let point = touches.first?.location(in: customView),
            !customView.bounds.contains(point) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    public override func customPresent(container: UIView, duration: TimeInterval, completeHandle: @escaping ((_ finish: Bool) -> Void)) {

        UIView.animate(withDuration: duration, animations: {
            self.view.alpha = 1
            self.bgView.alpha = 1
        }, completion: { (fin) in
            completeHandle(fin)
        })
        
    }
        
    // MARK: - Private Methods
    private func updateFrame(rect: CGRect) {
        bgView.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        let customViewSize = customView.customAlertSize(at: view.bounds)
        customView.frame = CGRect(x: bgView.center.x - 0.5 * customViewSize.width, y: bgView.center.y - 0.5 * customViewSize.height, width: customViewSize.width, height: customViewSize.height)
    }
}

