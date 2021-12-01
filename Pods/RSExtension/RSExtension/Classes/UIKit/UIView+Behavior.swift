//
//  UIView+Behavior.swift
//  AccountComponent
//
//  Created by tofu on 2018/9/25.
//

import UIKit
import AudioToolbox

public extension UIView {
    /// 振动反馈
    func impactOccurred() -> Void {
        AudioServicesPlaySystemSound(1520)
    }
}

// MARK: - 快速添加单击手势
public extension UIView {
    /// 快速添手势
    @discardableResult
    func addGestureRecognizer<T: UIGestureRecognizer>(type: T.Type, target: Any?, selector: Selector?, gestureRecognizerDelegate: UIGestureRecognizerDelegate? = nil) -> T {
        let gesture = type.init(target: target, action: selector)
        gesture.delegate = gestureRecognizerDelegate
        addGestureRecognizer(gesture)
        return gesture
    }
}
