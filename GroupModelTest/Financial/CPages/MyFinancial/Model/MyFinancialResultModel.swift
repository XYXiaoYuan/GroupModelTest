//
//  MyFinancialResultModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation
import HandyJSON

public class MyFinancialResultModel {
    
    /// 活期理财资产
    var currentWealth: String = "23892839.20"
    /// 定时理财资产
    var fixWealth: String = "268426456839.20"
    
    /// 活期资产
    var currentItems: [MyFinancialItemModel] = MyFinancialItemModel.currentItems()

    /// 定期资产
    var fixItems: [MyFinancialItemModel] = MyFinancialItemModel.fixItems()
    
    public required init() {}
}

public struct MyFinancialItemModel {
    
    /// 图标
    var icon: String = ""
    
    /// 币名称
    var iconName: String = "USDT"
    
    /// 大约收益
    var aboutProfits: String = "0"
    
}

extension MyFinancialItemModel {
    static func currentItems() -> [MyFinancialItemModel] {
        return [
            MyFinancialItemModel(icon: "", iconName: "USDT", aboutProfits: "12131.19"),
            MyFinancialItemModel(icon: "", iconName: "FIL", aboutProfits: "12154.86"),
            MyFinancialItemModel(icon: "", iconName: "ETH", aboutProfits: "3695.65"),
            MyFinancialItemModel(icon: "", iconName: "BTC", aboutProfits: "78453.25")
        ]
    }
    
    static func fixItems() -> [MyFinancialItemModel] {
        return [
            MyFinancialItemModel(icon: "", iconName: "USDT", aboutProfits: "12.19"),
            MyFinancialItemModel(icon: "", iconName: "FIL", aboutProfits: "45896.86"),
            MyFinancialItemModel(icon: "", iconName: "ETH", aboutProfits: "36.65"),
            MyFinancialItemModel(icon: "", iconName: "BTC", aboutProfits: "9996.25")
        ]
    }
}
