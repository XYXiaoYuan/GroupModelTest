//
//  UIImage+Common.swift
//  RSBaseConfig
//
//  Created by 袁小荣 on 2020/7/21.
//

import Foundation

/// 一些常用的图片
public extension UIImage {
    
    /// 返回图片(默认黑色)
    static var navBack: UIImage? {
        return UIImage.base_named(named: "common_back")
    }
    
    /// 返回图片(白色)
    static var navBackWhite: UIImage? {
        return UIImage.base_named(named: "common_back_white")
    }
    
    /// 导航栏右侧搜索图标(默认黑色)
    static var navSearch: UIImage? {
        return UIImage.base_named(named: "nav_search")
    }
    
    /// 搜索框的搜索图标
    static var searchbarSearch: UIImage? {
        return UIImage.base_named(named: "searchbar_search")
    }
    
    /// 更多图标(默认黑色)
    static var moreIcon: UIImage? {
        return UIImage.base_named(named: "common_more")
    }
    
    /// 更多图标(默认黑色)
    static var moreIconWhite: UIImage? {
        return UIImage.base_named(named: "nav_more_white")
    }
    
    /// 3条横线图片
    static var lineIcon: UIImage? {
        return UIImage.base_named(named: "common_line")
    }
}
