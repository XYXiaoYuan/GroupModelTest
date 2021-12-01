//
//  FinancialPayMentModel.swift
//  Pandamine_iOS
//
//  Created by huang on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

struct FinancialPayMentModel: HandyJSON {
    /// (USDT/HLC/HX)支付名称
    var displayName: String = ""
    /// logo
    var logo: String = ""
    /// (USDT/HLC)支付
    var description: String = ""
    /// (USDT,HLC,HX)id
//    var id: PayPluginType = .usdt
}
