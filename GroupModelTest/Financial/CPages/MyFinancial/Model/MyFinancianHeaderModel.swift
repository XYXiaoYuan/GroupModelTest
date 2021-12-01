//
//  MyFinancianHeaderModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

struct MyFinancianHeaderModel {
    var name: String
    var detail: String
    var bottomLeft: String
    var bottomRight: String
}

extension MyFinancianHeaderModel {
    static func myCurrentHeaderModel() -> MyFinancianHeaderModel {
        return MyFinancianHeaderModel(name: "我的活期理财",
                                      detail: "昨日收益/持有收益（折合USDT）",
                                      bottomLeft: "名称/存入数量/昨日收益",
                                      bottomRight: "持有收益/收益利率")
    }
    
    static func myFixHeaderModel() -> MyFinancianHeaderModel {
        return MyFinancianHeaderModel(name: "我的定期理财",
                                      detail: "昨日收益/持有收益（折合USDT）",
                                      bottomLeft: "名称/存入数量/昨日收益",
                                      bottomRight: "持有收益/收益利率")
    }
}
