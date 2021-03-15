//
//  GroupProvider.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/1/6.
//  Copyright © 2021 cfans. All rights reserved.
//  组模型协议

import Foundation

protocol GroupProvider {
    /// 占位
    associatedtype GroupModel where GroupModel: Equatable
    
    /// 是否需要往组模型列表中添加当前组模型
    func isNeedAppend(with current: GroupModel, listMs: [GroupModel]) -> Bool
    /// 获取当前组模型在组模型列表的下标
    func index(with current: GroupModel, listMs: [GroupModel]) -> Int
}

extension GroupProvider {
    func isNeedAppend(with current: GroupModel, listMs: [GroupModel]) -> Bool {
        return !listMs.contains(current)
    }
    
    func index(with current: GroupModel, listMs: [GroupModel]) -> Int {
        return listMs.firstIndex(of: current) ?? 0
    }
}
