//
//  FinancialDetailProfitDetailModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

struct FinancialDetailProfitDetailModel {
    var time: String
    var productName: String
    var profit: String
}

extension FinancialDetailProfitDetailModel {
    static func currentProfitDetail() -> [FinancialDetailProfitDetailModel] {
        return [
            FinancialDetailProfitDetailModel(time: "2021-02-29", productName: "活期理财收益", profit: "10.28"),
            FinancialDetailProfitDetailModel(time: "2021-02-28", productName: "活期理财收益", profit: "16.39"),
            FinancialDetailProfitDetailModel(time: "2021-02-27", productName: "活期理财收益", profit: "66.58")
        ]
    }
    
    static func fixProfitDetail() -> [FinancialDetailProfitDetailModel] {
        return [
            FinancialDetailProfitDetailModel(time: "2021-01-29", productName: "定期理财收益", profit: "0.25"),
            FinancialDetailProfitDetailModel(time: "2021-01-28", productName: "定期理财收益", profit: "0.23"),
            FinancialDetailProfitDetailModel(time: "2021-01-27", productName: "定期理财收益", profit: "1.05")
        ]
    }
}
