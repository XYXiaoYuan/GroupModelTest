//
//  Image+Extension.swift
//  Remind
//
//  Created by gg on 27/12/2017.
//  Copyright © 2017 ganyi. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
            
    /// 生成一张颜色图片 -- 对象方法
    /// - Parameter color: 颜色
    public class func image(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 生成一张颜色图片 -- 类方法
    /// - Parameter color: 颜色
    public static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // create a 1 by 1 pixel context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
    // 生成圆形图片
    public func toCircle() -> UIImage {
        // 取最短边长
        let shotest = min(self.size.width, self.size.height)
        // 输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        // 开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        // 添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        // 绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        // 获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
}
