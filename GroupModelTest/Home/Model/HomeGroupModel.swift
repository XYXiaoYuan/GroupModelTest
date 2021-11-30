//
//  HomeGroupModel.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2020/7/30.
//  Copyright © 2020 cfans. All rights reserved.
//

import Foundation

// MARK: - 首页组cell的类型
enum HomeGroupCellType {
    case historySearch(list: [HistorySearchModel])
    case recommendSearch(list: [HistorySearchModel])
    case todayHotSearch(list: [HistorySearchModel])
}

extension HomeGroupCellType: Equatable {
    public static func == (lhs: HomeGroupCellType, rhs: HomeGroupCellType) -> Bool {
        switch (lhs, rhs) {
        case (.historySearch, .historySearch): return true
        case (.recommendSearch, .recommendSearch): return true
        case (.todayHotSearch, .todayHotSearch): return true
        default:
            return false
        }
    }
}

// MARK: - 首页组模型
public struct HomeGroupModel: GroupProvider {
    typealias GroupModel = HomeGroupModel
    
    /// 组模型的类型
    var cellType: HomeGroupCellType
    /// 排序
    var sortIndex: Int
    /// 组模型的组标题
    var headerTitle: String
    /// 组头右侧是否需要删除按钮
    var needRightButton: Bool = false
    
    /// 把groupModel添加或替换到listMs中
    func addTo(listMs: inout [HomeGroupModel]) {
        if isNeedAppend(with: self, listMs: listMs) {
            listMs.append(self)
        } else {
            let index = self.index(with: self, listMs: listMs)
            listMs[index] = self
        }
    }
}

extension HomeGroupModel: Equatable {
    public static func == (lhs: HomeGroupModel, rhs: HomeGroupModel) -> Bool {
        return lhs.cellType == rhs.cellType
    }
}

// MARK: - 首页组模型的排序规则模型
struct HomeGroupSortModel {
    /// 搜索历史的排序
    var historySearchIndex: Int
    var recommendSearchIndex: Int
    var todayHotSearchIndex: Int
    
    public static var defaultSort: HomeGroupSortModel {
        return  HomeGroupSortModel(historySearchIndex: 0,
                                   recommendSearchIndex: 1,
                                   todayHotSearchIndex: 2)
        
    }
}
