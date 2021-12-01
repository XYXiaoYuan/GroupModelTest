//
//  GradientButton.swift
//  OverSea_iOS
//
//  Created by 袁小荣 on 2020/11/18.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit
import Foundation

/// 渐变颜色button
open class GradientButton: UIButton {
    
    private var gradientMap: [UIControl.State.RawValue: GradientProvide]?
    private var currentGradient: GradientProvide? {
        gradientMap?[state.rawValue] ?? gradientMap?[UIControl.State.normal.rawValue]
    }
    
    public func setBgGradient(_ gradient: GradientProvide = Gradient(starColor: 0x2295ED.uiColor, endColor: 0x053AC2.uiColor, direction: .horizontal(false)), for state: UIControl.State = .normal) {
        if gradientMap == nil {
            gradientMap = [:]
        }
        gradientMap?[state.rawValue] = gradient
        setNeedsDisplay()
    }
    
    public func setBgGradientAll(_ gradient: GradientProvide = Gradient(starColor: 0x2295ED.uiColor, endColor: 0x053AC2.uiColor, direction: .horizontal(false)), for allState: [UIControl.State] = [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.disabled, UIControl.State.selected]) {
        if gradientMap == nil {
            gradientMap = [:]
        }
        
        allState.forEach { gradientMap?[$0.rawValue] = gradient }
        setNeedsDisplay()
    }
    
    public static func ff_gradient(name: String) -> GradientButton {
        let button = GradientButton(type: .custom)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.regular(16)
        button.setTitle(name, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBgGradientAll()
        return button
    }
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        currentGradient?.drawGradient(in: rect)
    }
    
}
