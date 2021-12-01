//
//  CustomDateTransform.swift
//  MCExtension
//
//  Created by tofu on 2019/11/19.
//

import UIKit
import HandyJSON

/// Date 转换类
///
/// 服务器、Android 时间戳为毫秒，转换到 iOS Date 需要除以 1000
/// iOS 时间戳为秒转换成服务器、Android 时间戳需要乘以1000
///
public class CustomDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = Int64

    public init() {}

    public func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInt = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt / 1000))
        }

        if let timeStr = value as? String {
            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
        }

        return Date()
    }

    public func transformToJSON(_ value: Date?) -> Int64? {
        if let date = value {
            return Int64(date.timeIntervalSince1970 * 1000)
        }
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
