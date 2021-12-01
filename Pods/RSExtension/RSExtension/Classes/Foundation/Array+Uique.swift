//
//  Array+Uique.swift
//  MCExtension
//
//  Created by tofu on 2020/4/23.
//

import UIKit

// MARK: - 数组元素去重
public extension Array where Element: Equatable {
    /// 去重
    var unique: [Element]{
        var curIdx = -1
        return self.filter {
            curIdx += 1
            return self.firstIndex(of: $0) == curIdx
        }
    }
}
