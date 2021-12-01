//
//  GradientView.swift
//  RSWallet_Example
//
//  Created by 袁小荣 on 2020/7/21.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

/// 渐变颜色视图
open class GradientView: UIView, GradientProvide {
    
    public var starColor: UIColor
    public var endColor: UIColor
    public var direction: GradientDirection
    
    public init(starColor: UIColor, endColor: UIColor, direction: GradientDirection = .vertical(true) ) {
        self.starColor = starColor
        self.endColor = endColor
        self.direction = direction
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
    }
    
    public func update(starColor: UIColor, endColor: UIColor, direction: GradientDirection = .vertical(true) ) {
        self.starColor = starColor
        self.endColor = endColor
        self.direction = direction
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGradient(in: rect)
    }
}


