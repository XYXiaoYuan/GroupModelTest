//
//  UILabel+Extension.swift
//  Remind
//
//  Created by zxd on 2018/3/22.
//  Copyright © 2018年 ganyi. All rights reserved.
//

import UIKit

extension UILabel {
     public func drawTopCorner() {
        let radiu:CGSize = CGSize.init(width: 3, height: 3)
        let corner : UIRectCorner = [UIRectCorner.topLeft,UIRectCorner.topRight]
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: radiu)
        let maskLayer : CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

extension UILabel{
    /// Returns UILabel with font ff_lable
    public static func ff_label(ff_text:String? = nil,ff_color:UIColor? = nil, ff_align:NSTextAlignment = .left,ff_font:UIFont)->UILabel{
        let ff_lab = UILabel()
        ff_lab.text = ff_text
        if let c = ff_color{
            ff_lab.textColor = c
        }
        ff_lab.textAlignment = ff_align
        ff_lab.font = ff_font
        return ff_lab
    }
}
