//
//  UIView+Corner.swift
//  RSExtension
//
//  Created by 袁小荣 on 2020/7/17.
//

import UIKit

public extension UIView {
    
    /// 添加圆角(path)
    /// - Parameter corner: 圆角方向
    /// - Parameter radii: 圆角半径
    func corner(_ corner: UIRectCorner, radii: CGFloat) {
        let rect = self.bounds
        let mskP = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
        let mskL = CAShapeLayer.init()
        mskL.frame = rect
        mskL.path = mskP.cgPath
        self.layer.addSublayer(mskL)
        self.layer.mask = mskL
    }
    
    /// 添加圆角
    /// - Parameter radius: 圆角半径
    func cornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    /// 添加边框
    /// - Parameter width: 边框宽度
    /// - Parameter color: 边框颜色
    func border(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// 添加阴影
    /// - Parameter shadowOpacity: 阴影透明度
    /// - Parameter shadowColor: 阴影颜色
    /// - Parameter shadowOffset: 阴影偏移
    /// - Parameter shadowRadius: 阴影半径
    func shadow(shadowOpacity: CGFloat, shadowColor: UIColor, shadowOffset: CGSize, shadowRadius: CGFloat) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        clipsToBounds = false
    }
    
    /// 添加阴影(添加一个layer)
    /// - Parameter shadowOpacity: 阴影透明度
    /// - Parameter shadowColor: 阴影颜色
    /// - Parameter shadowOffset: 阴影偏移
    /// - Parameter shadowRadius: 阴影半径
    func shadowLayer(shadowOpacity: CGFloat, shadowColor: UIColor, shadowOffset: CGSize, shadowRadius: CGFloat) {
        let size = self.bounds.size
        let width = size.width
        let height = size.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width + 3, y: 0))
        path.addLine(to: CGPoint(x: width + 3, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        let layer = self.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
    
    /// 给view同时添加圆角和阴影(添加一个layer)
    /// - Parameter cornerRadius: 圆角半径
    /// - Parameter shadowOpacity: 阴影透明度
    /// - Parameter shadowColor: 阴影颜色
    /// - Parameter shadowOffset: 阴影偏移
    /// - Parameter shadowRadius: 阴影半径
    func roundShadowLayer(cornerRadius: CGFloat, shadowOpacity: CGFloat, shadowColor: UIColor, shadowOffset: CGSize, shadowRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        let subLayer = CALayer()
        let fixframe = self.frame
        subLayer.frame = CGRect.init(x: fixframe.origin.x + 1, y: fixframe.origin.y + 1, width: fixframe.width - 2, height: fixframe.height - 2)
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.cornerRadius = cornerRadius // 圆角半径
        subLayer.shadowOpacity = Float(shadowOpacity) // 阴影透明度
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = shadowOffset   // 阴影偏移
        subLayer.shadowRadius = shadowRadius;// 阴影半径
        self.superview?.layer.insertSublayer(subLayer, below: self.layer)
    }
    
    func cornerWithBezierPath(cornerRadii: CGSize) {
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
