//
//  CGRect+Extension.swift
//  RSExtension
//
//  Created by 袁小荣 on 2020/7/16.
//

import UIKit

extension CGRect {
    
    public func insertRect(_ insert: UIEdgeInsets) -> CGRect {
        return CGRect.init(x: minX + insert.left, y: minY + insert.top, width: width - insert.left - insert.right, height: height - insert.top - insert.bottom)
    }
    
    public func insertRect(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect {
        return CGRect.init(x: minX + left, y: minY + top, width: width - left - right, height: height - top - bottom)
    }
    
    public func insertRect(_ boder: CGFloat) -> CGRect {
        return CGRect.init(x: minX + boder, y: minY + boder, width: width - boder - boder, height: height - boder - boder)
    }
    
    public func scaleSize(_ scale: CGFloat) -> CGRect {
        return CGRect(origin: origin, size: CGSize(width: width * scale, height: height * scale))
    }
    
    public var center: CGPoint {
        mutating set {
            let oldValue = center
            origin.x += newValue.x - oldValue.x
            origin.y += newValue.y - oldValue.y
        }
        get {
            return CGPoint(x: midX, y: midY)
        }
        
    }
    
    public func centerRect(size: CGSize) -> CGRect {
        return CGRect(x: midX - size.width * 0.5, y: midY - size.height * 0.5, width: size.width, height: size.height)
    }
    
    public func enlargeRect(edgeInsets: UIEdgeInsets) -> CGRect {
        return CGRect(x: minX - edgeInsets.left, y: minY - edgeInsets.top, width: width + (edgeInsets.left + edgeInsets.right), height: height + (edgeInsets.top + edgeInsets.bottom))
    }
    
    
    public func rectMakeScale(_ scale: CGFloat)  -> CGRect {
        let w = scale * width
        let h = scale * height
        
        return CGRect(x: minX + (w - width) * 0.5, y: minY + (h - height) * 0.5, width: w, height: h)
    }
    
    public func layerFrame(for anchorPoint: CGPoint) -> CGRect {
        let offsetX = width * (anchorPoint.x - 0.5)
        let offsetY = height * (anchorPoint.y - 0.5)
        return CGRect(x: minX + offsetX, y: minY + offsetY, width: width, height: height)
    }
    
    public func frame(of targetSize: CGSize, with contentMode: UIView.ContentMode) -> CGRect {
        if size.equalTo(targetSize) { return self }
        if self == .zero { return .zero }
        switch contentMode {
        case .scaleAspectFit:
            let r1 = targetSize.width / targetSize.height
            let r2 = size.width / size.height
            if r1 > r2 {
                let h = width / r1
                return CGRect(x: minX, y: minY + (height -  h) * 0.5, width: width, height:  h)
            }
            let w = height * r1
            return CGRect(x: minX + (width - w) * 0.5, y: minY, width: w, height: height)
        case .scaleAspectFill:
            let r1 = targetSize.width / targetSize.height
            let r2 = size.width / size.height
            if r1 < r2 {
                let h = width / r1
                return CGRect(x: minX, y: minY + (height -  h) * 0.5, width: width, height:  h)
            }
            let w = height * r1
            return CGRect(x: minX + (width - w) * 0.5, y: minY, width: w, height: height)
        case .scaleToFill:
            return self
        case .center:
            return CGRect(x: minX + (width - targetSize.width) * 0.5, y: minY + (height - targetSize.height) * 0.5, width: targetSize.width, height: targetSize.height)
        case .top:
            return CGRect(x: minX + (width - targetSize.width) * 0.5, y: minY, width: targetSize.width, height: targetSize.height)
        case .topLeft:
            return CGRect(origin: origin, size: targetSize)
        case .left:
            return CGRect(x: minX, y: minY + (height - targetSize.height) * 0.5, width: targetSize.width, height: targetSize.height)
        case .bottomLeft:
            return CGRect(x: minX, y: minY + (height - targetSize.height), width: targetSize.width, height: targetSize.height)
        case .bottom:
            return CGRect(x: minX + (width - targetSize.width) * 0.5, y: minY + (height - targetSize.height), width: targetSize.width, height: targetSize.height)
        case .bottomRight:
            return CGRect(x: minX + (width - targetSize.width), y: minY + (height - targetSize.height), width: targetSize.width, height: targetSize.height)
        case .right:
            return CGRect(x: minX + (width - targetSize.width), y: minY + (height - targetSize.height) * 0.5, width: targetSize.width, height: targetSize.height)
        case .topRight:
            return CGRect(x: minX + (width - targetSize.width), y: minY, width: targetSize.width, height: targetSize.height)
        default:
            fatalError()
        }
        
    }
}
