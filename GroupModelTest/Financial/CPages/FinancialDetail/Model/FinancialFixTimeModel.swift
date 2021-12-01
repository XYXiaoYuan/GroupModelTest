//
//  FinancialFixTimeModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

struct FinancialFixTimeModel {
    var beginTime: String
    var endTime: String
}

extension FinancialFixTimeModel {
    static func defaultModel() -> FinancialFixTimeModel {
        return FinancialFixTimeModel(
            beginTime: "2021-01-27",
            endTime: "2021-04-27"
        )
    }
}
