//
//  FinancialDetailGroupModel.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

/// 理财详情组cell的类型
enum FinancialDetailType {
    case financialCard(model: FinancialResultModel)
    case operationItem(list: [FinancialDetailOperationAction])
    case fixTimeline(model: FinancialFixTimeModel)
    case profitDetail(list: [FinancialDetailProfitDetailModel])
}

extension FinancialDetailType: Equatable {
    public static func == (lhs: FinancialDetailType, rhs: FinancialDetailType) -> Bool {
        switch (lhs, rhs) {
        case (.financialCard, .financialCard): return true
        case (.operationItem, .operationItem): return true
        case (.fixTimeline, .fixTimeline): return true
        case (.profitDetail, .profitDetail): return true
        default:
            return false
        }
    }
}

public struct FinancialDetailGroupModel: GroupProvider {
    typealias GroupModel = FinancialDetailGroupModel
   
    /// 组模型的类型
    var cellType: FinancialDetailType
    /// 排序
    var sortIndex: Int

    /// 把groupModel添加到listMs中
    func addTo(listMs: inout [FinancialDetailGroupModel]) {
        if isNeedAppend(with: self, listMs: listMs) {
            listMs.append(self)
        } else {
            let indey = index(with: self, listMs: listMs)
            listMs[indey] = self
        }
    }
}

extension FinancialDetailGroupModel: Equatable {
    public static func == (lhs: FinancialDetailGroupModel, rhs: FinancialDetailGroupModel) -> Bool {
        return lhs.cellType == rhs.cellType
    }
}

// MARK: - 理财详情组模型的排序规则模型
struct FinancialDetailGroupSortModel {
    var financialCardIndex: Int
    var operationItemIndex: Int
    var fixTimelineIndex: Int
    var profitDetailIndex: Int

    static var defaultSort: FinancialDetailGroupSortModel {
        return FinancialDetailGroupSortModel(
            financialCardIndex: 0,
            operationItemIndex: 1,
            fixTimelineIndex: 2,
            profitDetailIndex: 3)
    }
}
