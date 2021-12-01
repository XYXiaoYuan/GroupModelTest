//
//  UIButton+Extension.swift
//  RSExtension
//
//  Created by 袁小荣 on 2020/7/16.
//

import Foundation
import UIKit

public extension UIButton {
    enum Direction {
        case top, right, bottom, left
    }
    
    func imageDirection(_ direction: Direction, spacing: CGFloat, maxWidth: CGFloat = CGFloat(MAXFLOAT), maxHeight: CGFloat = CGFloat(MAXFLOAT))  {
        setTitle(currentTitle, for: .normal)
        setImage(currentImage, for: .normal)
        
        let imageWidth: CGFloat = CGFloat(imageView?.image?.size.width ?? 0)
        let imageHeight: CGFloat = CGFloat(imageView?.image?.size.height ?? 0)
        
        let attributes = [NSAttributedString.Key.font: titleLabel?.font]
        let size = titleLabel?.text?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil).size
        let lWidth: CGFloat = size?.width ?? 0
        let lHeight: CGFloat = size?.height ?? 0
        let labelWidth: CGFloat = (lWidth > maxWidth) ? maxWidth : lWidth
        let labelHeight: CGFloat = (lHeight > maxHeight) ? maxHeight : lHeight
        
        /// image中心移动的x距离
        let imageOffsetX: CGFloat = (imageWidth + labelWidth) / 2 - imageWidth / 2
        /// image中心移动的y距离
        let imageOffsetY: CGFloat = imageHeight / 2 + spacing / 2
        /// label中心移动的x距离
        let labelOffsetX: CGFloat = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2
        /// label中心移动的y距离
        let labelOffsetY: CGFloat = labelHeight / 2 + spacing / 2
        
        let tempWidth: CGFloat = max(labelWidth, imageWidth);
        let changedWidth: CGFloat = labelWidth + imageWidth - tempWidth;
        let tempHeight: CGFloat = max(labelHeight, imageHeight);
        let changedHeight: CGFloat = labelHeight + imageHeight + spacing - tempHeight;
        
        
        switch direction {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: labelOffsetX, left: -labelOffsetX, bottom: -labelOffsetY, right:labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -changedWidth / 2, bottom: changedHeight - imageOffsetY, right: -changedWidth / 2)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + spacing / 2, bottom: 0, right: -(labelWidth + spacing / 2))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + spacing / 2), bottom: 0, right: imageWidth + spacing / 2)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -labelOffsetX, left: -labelOffsetX, bottom: labelOffsetY, right:labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: changedHeight - imageOffsetY, left: -changedWidth / 2, bottom: imageOffsetY, right: -changedWidth / 2)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 2)
        }
    }
}

open class EnlargeEdgeButton: UIButton {
    
    open var enlargeEdge: UIEdgeInsets = .zero
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if alpha == 0 || isHidden == true || enlargeEdge == .zero {
            return super.hitTest(point, with: event)
        }
        let rect = bounds.enlargeRect(edgeInsets: enlargeEdge)
        return rect.contains(point) ? self : nil
    }
}

extension UIButton{
    /// Return UIButton with title
    public static func ff_btn(ff_title:String) ->UIButton{
        let ff_b = UIButton()
        ff_b.setTitle(ff_title, for: .normal)
        return ff_b
    }
    
    /// Return UIButton with image
    public static func ff_btn(ff_img:String) ->UIButton{
        let ff_b = UIButton()
        ff_b.setImage(UIImage(named: ff_img), for: .normal)
        return ff_b
    }
    
    func ff_btn(vv_img:String, target: Any? ,action: Selector)->UIButton{
        let vv_btn = UIButton.ff_btn(ff_img: vv_img)
        vv_btn.addTarget(target, action: action, for: .touchUpInside)
        return vv_btn
    }
    
    func ff_btn(vv_title:String, target: Any? ,action: Selector)->UIButton{
        let vv_btn = UIButton.ff_btn(ff_title: vv_title)
        vv_btn.addTarget(target, action: action, for: .touchUpInside)
        return vv_btn
    }
}

