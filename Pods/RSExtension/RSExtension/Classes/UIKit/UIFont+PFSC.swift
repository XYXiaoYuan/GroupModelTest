//
//  UIFont+PFSC.swift
//  Pods-RSExtension_Example
//
//  Created by 李强会 on 2020/7/18.
//

import UIKit

// MARK: - PingFangSC
public extension UIFont  {
    
    // MARK: - 中黑
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont.setupFont(with: "PingFangSC-Medium", size: size)
    }
    
    // MARK: - 粗体
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont.setupFont(with: "PingFangSC-Semibold", size: size)
    }
    
    // MARK: - 常规,和UIFont.systemFont是一样的
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont.setupFont(with: "PingFangSC-Regular", size: size)
    }
}

// MARK: - DINAlternate
public extension UIFont  {
        
    // MARK: - 粗体
    static func dinBold(_ size: CGFloat) -> UIFont {
        return UIFont.setupFont(with: "DINAlternate-Bold", size: size)
    }
}

fileprivate extension UIFont {
    // MARK: - 私有方法,根据传递过来的字体名来设置字体
    static func setupFont(with fontName: String, size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            if let font = UIFont(name: fontName, size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size)
            }
        }
        return UIFont.systemFont(ofSize: size)
    }

//   PingFangSC字体
//   PingFangSC-Medium
//   PingFangSC-Semibold
//   PingFangSC-Light
//   PingFangSC-Ultralight
//   PingFangSC-Regular
//   PingFangSC-Thin

}


extension UIFont {

    /// Returns the PingFans SC font
    public static func ff_PFSCFont(ff_size : CGFloat,ff_style:String="Regular") -> UIFont{
        return UIFont(name: "PingFangSC-\(ff_style)", size: ff_size)!
    }

}
