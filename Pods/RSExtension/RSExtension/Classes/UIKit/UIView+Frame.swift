//
//  UIView+Frame.swift
//  BatourTool
//
//  Created by iOS_Dev5 on 2016/10/20.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

import UIKit

// MARK: - x, y, width, height, origin, size
extension UIView {
    /// x
    public var x: CGFloat {
        get { frame.origin.x }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// y
    public var y: CGFloat {
        get { frame.origin.y }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// width
    public var width: CGFloat {
        get { frame.size.width }
        set {
            frame.size.width = newValue
        }
    }
    
    /// height
    public var height: CGFloat {
        get { frame.size.height }
        set {
            frame.size.height = newValue
        }
    }
    
    /// origin
    public var origin: CGPoint {
        get { frame.origin }
        set {
            frame.origin.x = newValue.x
            frame.origin.y = newValue.y
        }
    }
    
    /// size
    public var size: CGSize {
        get { frame.size }
        set {
            frame.size.width = newValue.width
            frame.size.height = newValue.height
        }
    }
}


// MARK: - centerX, centerY
extension UIView {
    /// centerX
    public var centerX: CGFloat {
        get { center.x }
        set {
            frame.origin.x = newValue - frame.size.width / 2
        }
    }
    
    /// centerY
    public var centerY: CGFloat {
        get { center.y }
        set {
            frame.origin.y = newValue - frame.size.height / 2
        }
    }
}

// MARK: - top, right, bottom, left
extension UIView {
    /// top
    public var top: CGFloat { minY }
    
    /// right
    public var right: CGFloat { maxX }
    
    /// bottom
    public var bottom: CGFloat { maxY }
    
    /// left
    public var left: CGFloat { minX }
}


// MARK: - minX, midX, maxX, minY, midY, maxY
extension UIView {
    /// minX
    public var minX: CGFloat { frame.minX }
    
    /// midX
    public var midX: CGFloat { frame.midX }
    
    /// maxX
    public var maxX: CGFloat { frame.maxX }
    
    /// minY
    public var minY: CGFloat { frame.minY }
    
    /// midY
    public var midY: CGFloat { frame.midY }
    
    /// maxY
    public var maxY: CGFloat { frame.maxY }
}

