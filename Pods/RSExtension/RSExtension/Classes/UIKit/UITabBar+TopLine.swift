//
//  UITabBar+TopLine.swift
//  Pods-RSExtension_Example
//
//  Created by 李强会 on 2020/7/18.
//

import UIKit

extension UITabBar {
    
    /// 隐藏顶部一条黑线 ff_color需要的颜色
    public func ff_hideTopLine(_ ff_color: UIColor = .white){
        
        if #available(iOS 13.0, *){
            let vv_line = UIView(frame: CGRect(x: 0, y: -1, width: UIScreen.main.bounds.width, height: 1))
            vv_line.backgroundColor = ff_color
            self.addSubview(vv_line)
 
        }  else{
            self.shadowImage = UIImage()
            self.backgroundImage = UIImage()
        }
    }

}
