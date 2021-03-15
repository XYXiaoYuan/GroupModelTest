//
//  HistorySearchModel.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/1/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

struct HistorySearchModel {
    var name: String
}

// MARK: - 搜索历史假数据
extension HistorySearchModel {
    static func historySearchDefaultData() -> [HistorySearchModel] {
        return [
            HistorySearchModel(name: "123"),
            HistorySearchModel(name: "adlfkajfladsfjasdf"),
            HistorySearchModel(name: "sdalfkjaksflajsdfjki0"),
            HistorySearchModel(name: "kkdisasodfd"),
            HistorySearchModel(name: "kskdksa0orjjasdf")
        ]
    }
}

// MARK: - 搜索推荐假数据
extension HistorySearchModel {
    static func recommendSearchDefaultData() -> [HistorySearchModel] {
        return [
            HistorySearchModel(name: "123"),
            HistorySearchModel(name: "adlfkdf"),
            HistorySearchModel(name: "Learn together Chineses"),
            HistorySearchModel(name: "kkdisasodfd"),
            HistorySearchModel(name: "kskdksa0orjjasdf")
        ]
    }
}

// MARK: - 今日热搜假数据
extension HistorySearchModel {
    static func todayHotSearchDefaultData() -> [HistorySearchModel] {
        return [
            HistorySearchModel(name: "123"),
            HistorySearchModel(name: "adlfkajfladsfjasdf"),
            HistorySearchModel(name: "sdalfkjaksflajsdfjki0"),
            HistorySearchModel(name: "kkdisasodfd"),
            HistorySearchModel(name: "kskdksa0orjjasdf"),
            HistorySearchModel(name: "123"),
            HistorySearchModel(name: "adlfkajfladsfjasdf"),
            HistorySearchModel(name: "sdalfkjaksflajsdfjki0"),
            HistorySearchModel(name: "kkdisasodfd"),
            HistorySearchModel(name: "kskdksa0orjjasdf")
        ]
    }
}
