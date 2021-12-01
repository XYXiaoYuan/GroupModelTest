//
//  GradientProvide.swift
//  OverSea_iOS
//
//  Created by 袁小荣 on 2020/11/18.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit
import Foundation

/// 渐变方向
public enum GradientDirection {
    /// 垂直方向从上至上 isASC: true开始颜色重上至下,false开始颜色重下至上
    case vertical(_ isASC: Bool)
    
    /// 垂直方向从左至右 isASC: true开始颜色重左至右,false开始颜色重右至左
    case horizontal(_ isASC: Bool)
}

public protocol GradientProvide {
    var starColor: UIColor { get }
    var endColor: UIColor { get }
    var direction: GradientDirection { get }
    
    func drawGradient(in rect: CGRect)
}

public struct Gradient: GradientProvide {
    public var starColor: UIColor
    public var endColor: UIColor
    public var direction: GradientDirection
    public init(starColor: UIColor, endColor: UIColor, direction: GradientDirection = .vertical(true) ) {
        self.starColor = starColor
        self.endColor = endColor
        self.direction = direction
    }
}

 extension GradientProvide {
    public func drawGradient(in rect: CGRect) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
                
        var isTop = true
        
        var startP = CGPoint.zero
        var endP   = CGPoint.zero
        
        switch direction {
        case .vertical(let isASC):
            isTop = isASC
            startP = CGPoint.init(x: rect.midX, y: rect.maxY)
            endP   = CGPoint.init(x: rect.midX, y: rect.minY)
            
        case .horizontal(let isASC):
            isTop = isASC
            startP = CGPoint.init(x: rect.minX, y: rect.midY)
            endP   = CGPoint.init(x: rect.maxX, y: rect.midY)
            
        }
        let colors = [starColor.cgColor, endColor.cgColor]

        let p = UnsafeMutablePointer<CGFloat>.allocate(capacity: 2)
        p[0] = 1.0
        p[1] = 0.0
        defer {
            p.deallocate()
        }
        guard let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: p) else { return }
        
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState() // push
            context.addRect(rect)
            context.clip()
            context.drawLinearGradient(gradient, start: isTop ? startP : endP, end: isTop ? endP : startP, options: CGGradientDrawingOptions.init(rawValue: 0))
            context.restoreGState() // pop
        }
    }
}


