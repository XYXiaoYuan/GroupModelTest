//
//  RankMenuModel+Extension.swift
//  GoodsRankMenuView
//
//  Created by 袁小荣 on 2020/7/20.
//

import Foundation

final class GoodsRankMenuViewDummy {}

fileprivate extension UIImage {
    static func ff_named(named name: String) -> UIImage? {
        let curBundle = Bundle(for: GoodsRankMenuViewDummy.self)
        let boudleURL = curBundle.url(forResource: "GoodsRankMenuView", withExtension: "bundle")
        let resourceBundle = Bundle(url: boudleURL!)
        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }
}

public extension RankMenuModel {
    /// 1.综合
    static func comprehensiveModel(_ title: String = "综合") -> RankMenuModel {
        return RankMenuModel(title: title, hasImage: false)
    }
    
    /// 2.1.统一的价格
    static func priceModel(_ title: String = "价格") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "home_arrow"),
                             asendImage: UIImage.ff_named(named: "home_arrow_s"),
                             descendImage: UIImage.ff_named(named: "home_arrow_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: "PRICE",
                             byString: "ASC")
    }
    
    /// 2.2.积分专区的价格
    static func integralPriceModel(_ title: String = "价格") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "integral_arrow"),
                             asendImage: UIImage.ff_named(named: "integral_arrow_s"),
                             descendImage: UIImage.ff_named(named: "integral_arrow_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: "PRICE",
                             byString: "ASC")
    }
    
    /// 3.统一的新品
    static func newGoodsModel(_ title: String = "新品") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "home_arrow"),
                             asendImage: UIImage.ff_named(named: "home_arrow_s"),
                             descendImage: UIImage.ff_named(named: "home_arrow_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: "CREATETIME",
                             byString: "ASC")

    }
    
    /// 4.统一的新店
    static func newShopModel(_ title: String = "新店") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "home_arrow"),
                             asendImage: UIImage.ff_named(named: "home_arrow_s"),
                             descendImage: UIImage.ff_named(named: "home_arrow_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: "CREATETIME",
                             byString: "ASC")

    }
    
    /// 5.1.统一的销量
    static func salesModel(_ title: String = "销量") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "home_arrow"),
                             asendImage: UIImage.ff_named(named: "home_arrow_s"),
                             descendImage: UIImage.ff_named(named: "home_arrow_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: "SALES",
                             byString: "ASC")
    }

    /// 5.2.积分专区的销量
    static func integralSalesModel(_ title: String = "销量") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "integral_arrow"),
                             asendImage: UIImage.ff_named(named: "integral_arrow_s"),
                             descendImage: UIImage.ff_named(named: "integral_arrow_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: "SALES",
                             byString: "ASC")
    }
    
    /// 6.利润
    static func profitModel(_ title: String = "利润") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "home_arrow"),
                             asendImage: UIImage.ff_named(named: "home_arrow_s"),
                             descendImage: UIImage.ff_named(named: "home_arrow_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: "RPOFIT",
                             byString: "ASC")

    }
    
    /// 7.1.统一的筛选
    static func filterModel(_ title: String = "筛选") -> RankMenuModel {
        return RankMenuModel(title: title,
                             hasImage: true,
                             normalImage: UIImage.ff_named(named: "home_filter"),
                             selectedImage: UIImage.ff_named(named: "home_filter_s"))
    }
    
    /// 7.2.积分专区的筛选
    static func integralFilterModel(_ title: String = "筛选") -> RankMenuModel {
        return RankMenuModel(title: title,
                             hasImage: true,
                             normalImage: UIImage.ff_named(named: "integral_filter"),
                             selectedImage: UIImage.ff_named(named: "integral_filter_s"))
    }
    
    /// 8.统一的分类
    static func categoryModel(_ title: String = "分类") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "home_store_x"),
                             asendImage: UIImage.ff_named(named: "home_store_x"),
                             descendImage: UIImage.ff_named(named: "home_store_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: nil,
                             byString: nil)
    }
    
    /// 9.积分排序
    static func integralModel(_ title: String = "分类") -> RankMenuModel {
        return RankMenuModel(title: title,
                             normalImage: UIImage.ff_named(named: "integral_arrow"),
                             asendImage: UIImage.ff_named(named: "integral_arrow_s"),
                             descendImage: UIImage.ff_named(named: "integral_arrow_x"),
                             hasImage: true,
                             isAsend: false,
                             isDescend: true,
                             orderString: nil,
                             byString: nil)
    }
}
