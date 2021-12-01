//
//  FinancialResultModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation
import HandyJSON

public class FinancialResultModel {
    
    /// 理财产品名称
    var productName: String = "理财产品名称"
    
    /// 活期理财资产
    var currentWealth: String = "23892839.20"
    /// 定时理财资产
    var fixWealth: String = "268426456839.20"
    
    /// 昨天收益
    var yesterdayProfit: String = "650809"
    /// 持有收益
    var possessProfit: String = "5705841"
    /// 累计收益
    var totalProfit: String = "802946"
    
    public required init() {}
}
