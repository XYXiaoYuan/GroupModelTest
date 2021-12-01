//
//  RankMenuModel.swift
//  GoodsRankMenuView
//
//  Created by 袁小荣 on 2020/7/20.
//

import UIKit
import Foundation

public enum RankType {
    case normal // 价格/销量/新品/综合这些
    case filter // 筛选
    case cate   // 分类
}

public struct RankMenuModel {
    /// 标题
    public var title: String
    /// 正常状态下的图片
    var normalImage: UIImage?
    /// 选中状态下的图片
    var selectedImage: UIImage?
    /// 箭头向上的升序图片
    var asendImage: UIImage?
    /// 箭头向下的升序图片
    var descendImage: UIImage?
    
    /// 是否有图片
    public var hasImage: Bool = true
    /// 是否有箭头向上状态,升序
    public var isAsend: Bool = false
    /// 是否有箭头向下状态,降序
    public var isDescend: Bool = true
    
    /// 排序类型 综合排序不传, sales销量排序 price 价格排序 createtime 新品排序
    public var orderString: String?
    /// 排序方式 asc降序 desc升序
    public var byString: String?
    /// type
    public var type: RankType = .normal
    
    mutating func setIsAsend(_ isAsend: Bool) {
        self.isAsend = isAsend
    }
    
    mutating func setIsDescend(_ isDescend: Bool) {
        self.isDescend = isDescend
    }
    
    mutating func setByString(_ byString: String) {
        self.byString = byString
    }
}

public extension RankMenuModel {
    /// 仅有文字的,主要用于综合
    init(title: String,
         hasImage: Bool) {
        self.init(title: title, normalImage: nil, selectedImage: nil, asendImage: nil, descendImage: nil, hasImage: hasImage, isAsend: true, isDescend: false, orderString: nil, byString: nil)
    }
    
    /// 既有文字又有图片的,主要用于价格,新品,销量
    init(title: String,
         normalImage: UIImage,
         asendImage: UIImage,
         descendImage: UIImage,
         hasImage: Bool,
         isAsend: Bool,
         isDescend: Bool,
         orderString: String,
         byString: String,
         type: RankType = .normal) {
        self.init(title: title, normalImage: normalImage, selectedImage: nil, asendImage: asendImage, descendImage: descendImage, hasImage: hasImage, isAsend: isAsend, isDescend: false, orderString: orderString, byString: byString)
    }
    
    /// 仅供筛选按钮使用
    init(title: String, hasImage: Bool, normalImage: UIImage?, selectedImage: UIImage?, type: RankType = .filter) {
        self.init(title: title, normalImage: normalImage, selectedImage: selectedImage, asendImage: nil, descendImage: nil, hasImage: hasImage, isAsend: true, isDescend: false, orderString: nil, byString: nil, type: type)
    }
}
