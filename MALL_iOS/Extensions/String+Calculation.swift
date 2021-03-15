//
//  String+Extension.swift
//  News
//
//  Created by chenhuan on 2018/3/6.
//  Copyright © 2018年 chenhuan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// 文本的高度计算
    ///
    /// - Parameters:
    ///   - fontSize: 字体的大小
    ///   - width: 文本的最大宽度
    /// - Returns: 文本高度
    public func textHeight(fontSize: CGFloat, width: CGFloat,lineSpacing: CGFloat = 0) -> CGFloat {
        if lineSpacing != 0 {
            let paraph = NSMutableParagraphStyle()
            paraph.lineSpacing = lineSpacing
            return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize),.paragraphStyle:paraph], context: nil).size.height
        }else {
            return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
        }
    }
    
    public func ttBoundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil) -> CGSize {
        let attritube = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: attritube.length)
        attritube.addAttributes([NSAttributedString.Key.font: font], range: range)
        if lineSpacing != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing!
            attritube.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        }
        let rect = attritube.boundingRect(with: constrainedSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        var size = rect.size
        if let currentLineSpacing = lineSpacing {
            // 文本的高度减去字体高度小于等于行间距，判断为当前只有1行
            let spacing = size.height - font.lineHeight
            if spacing <= currentLineSpacing && spacing > 0 {
                size = CGSize(width: size.width, height: font.lineHeight)
            }
        }
        return size
    }
}
