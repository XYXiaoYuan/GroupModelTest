//
//  MyFinancialProductListModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation
import HandyJSON

struct MyFinancialProductListModel {
    
    /// 产品名称
    var productName: String = "活期理财- 随存随取 - FIL"
    
    /// 存入数量
    var depositAmount: String = "12%"
    /// 持有收益
    var possessProfit: String = "1214841515389"
    /// 昨天收益
    var yesterdayProfit: String = "12586"
    /// 收益利率
    var benefitRate: String = "+23.02%"
    
    /// 到期时间
    var expiredData: String = "2021-04-27 12:12:12"
    /// 定时理财时间
    var fixDuration: String = "30天"
}

extension MyFinancialProductListModel {
    static func defaultCurrnetData() -> [MyFinancialProductListModel] {
        return [
            MyFinancialProductListModel(productName: "活期理财- 随存随取 - FIL", depositAmount: "10000", possessProfit: "1214841515389", yesterdayProfit: "12586"),
            MyFinancialProductListModel(productName: "活期理财- 随存随取 - ETH", depositAmount: "2000", possessProfit: "39829389", yesterdayProfit: "849354"),
            MyFinancialProductListModel(productName: "活期理财- 随存随取 - BTC", depositAmount: "3000", possessProfit: "24863.25", yesterdayProfit: "239832"),
            MyFinancialProductListModel(productName: "活期理财- 随存随取 - PAM", depositAmount: "4000", possessProfit: "248631.14", yesterdayProfit: "2548")
        ]
    }
    
    static func defaultFixData() -> [MyFinancialProductListModel] {
        return [
            MyFinancialProductListModel(productName: "定期理财- 稳健收益 - USDT", depositAmount: "10000", possessProfit: "121", yesterdayProfit: "12", expiredData: "2021-04-27 12:12:12", fixDuration: "30天"),
            MyFinancialProductListModel(productName: "定期理财- 稳健收益 - USDT", depositAmount: "12000", possessProfit: "26", yesterdayProfit: "56", expiredData: "2021-04-27 12:12:12", fixDuration: "60天"),
            MyFinancialProductListModel(productName: "定期理财- 稳健收益 - BTC", depositAmount: "20000", possessProfit: "1658", yesterdayProfit: "369", expiredData: "2021-04-27 12:12:12", fixDuration: "90天")
        ]
    }
}

