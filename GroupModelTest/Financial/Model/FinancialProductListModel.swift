//
//  FinancialProductListModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation
import HandyJSON

/// 理财类型
public enum FinancialType: Int, HandyJSONEnum {
    case current = 0 /// 活期理财
    case fix = 1     /// 定期理财
}

public struct FinancialProductListModel {
    /// 产品类型
    var productType: FinancialType = .current
    
    /// 产品名称
    var productName: String = "活期理财- 随存随取 - FIL"
    /// 七日年化
    var profitOf7day: String = "12%"
    
    /// 总累计收益
    var totalProfit: String = "1214841515389"
    /// 总有多少人持有
    var possessNumber: String = "12586"
    
    mutating func setProductType(_ productType: FinancialType) {
        self.productType = productType
    }
}

extension FinancialProductListModel {
    static func defaultCurrnetData() -> [FinancialProductListModel] {
        return [
            FinancialProductListModel(productType: .current, productName: "活期理财- 随存随取 - FIL", profitOf7day: "12%", totalProfit: "1214841515389", possessNumber: "12586"),
            FinancialProductListModel(productType: .current, productName: "活期理财- 随存随取 - ETH", profitOf7day: "15%", totalProfit: "39829389", possessNumber: "849354"),
            FinancialProductListModel(productType: .current, productName: "活期理财- 随存随取 - BTC", profitOf7day: "15%", totalProfit: "24863.25", possessNumber: "239832"),
            FinancialProductListModel(productType: .current, productName: "活期理财- 随存随取 - PAM", profitOf7day: "18%", totalProfit: "248631.14", possessNumber: "2548")
        ]
    }
    
    static func defaultFixData() -> [FinancialProductListModel] {
        return [
            FinancialProductListModel(productType: .fix, productName: "定期理财- 随存随取 - FIL", profitOf7day: "60%～120%", totalProfit: "1214841515389", possessNumber: "12586"),
            FinancialProductListModel(productType: .fix, productName: "定期理财- 随存随取 - ETH", profitOf7day: "60%～120%", totalProfit: "39829389", possessNumber: "849354"),
            FinancialProductListModel(productType: .fix, productName: "定期理财- 随存随取 - BTC", profitOf7day: "60%～120%", totalProfit: "24863.25", possessNumber: "239832"),
            FinancialProductListModel(productType: .fix, productName: "定期理财- 随存随取 - PAM", profitOf7day: "120%～192%", totalProfit: "248631.14", possessNumber: "2548"),
            FinancialProductListModel(productType: .fix, productName: "定期理财- 随存随取 - FIL", profitOf7day: "60%～120%", totalProfit: "1214841515389", possessNumber: "12586"),
            FinancialProductListModel(productType: .fix, productName: "定期理财- 随存随取 - ETH", profitOf7day: "60%～120%", totalProfit: "39829389", possessNumber: "849354"),
            FinancialProductListModel(productType: .fix, productName: "定期理财- 随存随取 - BTC", profitOf7day: "60%～120%", totalProfit: "24863.25", possessNumber: "239832"),
            FinancialProductListModel(productType: .fix, productName: "定期理财- 随存随取 - PAM", profitOf7day: "120%～192%", totalProfit: "248631.14", possessNumber: "2548")
        ]
    }
}
