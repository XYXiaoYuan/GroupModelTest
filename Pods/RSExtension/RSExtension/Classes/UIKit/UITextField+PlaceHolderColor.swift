//
//  UITextField+PlaceHolderColor.swift
//  Pods-RSExtension_Example
//
//  Created by 李强会 on 2020/7/18.
//

import UIKit

extension UITextField{
    
    /// 设置提示占位符字体颜色
    public func ff_setPlaceholderColor(ff_color:UIColor){
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder!,attributes: [NSAttributedString.Key.foregroundColor: ff_color])
    }
}
