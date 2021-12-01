//
//  MyFinancialGroupModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

/// 我的理财组cell的类型
enum MyFinancialType {
    case asset(model: MyFinancialResultModel)
    case profit(model: FinancialResultModel)
    case myCurrent(model: MyFinancianHeaderModel, list: [MyFinancialProductListModel])
    case myFix(model: MyFinancianHeaderModel, list: [MyFinancialProductListModel])
}

extension MyFinancialType: Equatable {
    public static func == (lhs: MyFinancialType, rhs: MyFinancialType) -> Bool {
        switch (lhs, rhs) {
        case (.asset, .asset): return true
        case (.profit, .profit): return true
        case (.myCurrent, .myCurrent): return true
        case (.myFix, .myFix): return true
        default:
            return false
        }
    }
}

public struct MyFinancialGroupModel: GroupProvider {
    typealias GroupModel = MyFinancialGroupModel
   
    /// 组模型的类型
    var cellType: MyFinancialType
    /// 排序
    var sortIndex: Int

    /// 把groupModel添加到listMs中
    func addTo(listMs: inout [MyFinancialGroupModel]) {
        if isNeedAppend(with: self, listMs: listMs) {
            listMs.append(self)
        } else {
            let indey = index(with: self, listMs: listMs)
            listMs[indey] = self
        }
    }
}

extension MyFinancialGroupModel: Equatable {
    public static func == (lhs: MyFinancialGroupModel, rhs: MyFinancialGroupModel) -> Bool {
        return lhs.cellType == rhs.cellType
    }
}

// MARK: - 理财首页组模型的排序规则模型
struct MyFinancialGroupSortModel {
    var assetIndex: Int
    var profitIndex: Int
    var myCurrentIndex: Int
    var myFixIndex: Int

    static var defaultSort: MyFinancialGroupSortModel {
        return MyFinancialGroupSortModel(
            assetIndex: 0,
            profitIndex: 1,
            myCurrentIndex: 2,
            myFixIndex: 3)
    }
}
