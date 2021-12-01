//
//  Gradient+Extension.swift
//  Remind
//
//  Created by gg on 17/01/2018.
//  Copyright © 2018 ganyi. All rights reserved.
//

import Foundation
extension CAGradientLayer{
    ///MARK:- cell绘制圆角并修改缩小宽度
    public func customCollectionDraw(withRectCorner rectCorner: UIRectCorner){
        
        let size  = CGSize(width: 2, height: 2)
        let corner : UIRectCorner = [rectCorner]
        
        let maskFrame = bounds
        let path = UIBezierPath(roundedRect: maskFrame, byRoundingCorners: corner, cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = maskFrame
        maskLayer.path = path.cgPath
        mask = maskLayer
    }
}
