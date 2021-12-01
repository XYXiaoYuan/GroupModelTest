//
//  FinancialModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

/// 理财首页组cell的类型
enum FinancialHomeType {
    case asset(model: FinancialResultModel)
    case profit(model: FinancialResultModel)
    case product(currentList: [FinancialProductListModel], fixList: [FinancialProductListModel])
}

extension FinancialHomeType: Equatable {
    public static func == (lhs: FinancialHomeType, rhs: FinancialHomeType) -> Bool {
        switch (lhs, rhs) {
        case (.asset, .asset): return true
        case (.profit, .profit): return true
        case (.product, .product): return true
        default:
            return false
        }
    }
}

public struct FinancialHomeGroupModel: GroupProvider {
    typealias GroupModel = FinancialHomeGroupModel
   
    /// 组模型的类型
    var cellType: FinancialHomeType
    /// 排序
    var sortIndex: Int

    /// 把groupModel添加到listMs中
    func addTo(listMs: inout [FinancialHomeGroupModel]) {
        if isNeedAppend(with: self, listMs: listMs) {
            listMs.append(self)
        } else {
            let indey = index(with: self, listMs: listMs)
            listMs[indey] = self
        }
    }
}

extension FinancialHomeGroupModel: Equatable {
    public static func == (lhs: FinancialHomeGroupModel, rhs: FinancialHomeGroupModel) -> Bool {
        return lhs.cellType == rhs.cellType
    }
}

// MARK: - 理财首页组模型的排序规则模型
struct FinancialHomeGroupSortModel {
    var assetIndex: Int
    var profitIndex: Int
    var productIndex: Int

    static var defaultSort: FinancialHomeGroupSortModel {
        return FinancialHomeGroupSortModel(
            assetIndex: 0,
            profitIndex: 1,
            productIndex: 2)
    }
}
