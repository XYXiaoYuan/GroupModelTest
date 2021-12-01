//
//  Mappable.swift
//  TargetComponent
//
//  Created by tofu on 2019/4/13.
//

import UIKit
import HandyJSON

/// HandJSON 协议扩展
public protocol Mappable: HandyJSON {
    associatedtype T
    
    /// 统一处理 JSON 转换 Model
    ///
    /// - Parameter josn: 服务器返回 JSON
    /// - Returns: 对应 Model
    static func mapObject(_ json: [String: Any]) -> Self.T?
    static func mapObject(from json: String?) -> Self.T?
    
    /// 统一处理 JSON 转换 Model 数组
    ///
    /// - Parameter jsonArray: 服务器返回 JSON Array
    /// - Returns: 对应 Model 数组
    static func mapObjects(_ jsonArray: [[String: Any]]) -> [Self.T]?
    static func mapObjects(from json: String?) -> [Self.T]?
    
    /// 时间戳 转换 Date，服务器、Android 时间戳转换到 iOS Date 需要除以 1000
    /// - Parameter timeInterval: 时间戳
    static func transformDate(of timeInterval: Int64?) -> Date
    
    /// iOS 时间戳转换成 服务器、Android 时间戳
    /// - Parameter date: iOS Date
    static func transformTimeInterval(of date: Date?) -> Int64
    
    /// Model 转换 JSON
    ///
    func mapJSONObject() -> [String: Any]?
    
    /// Model 转换 JSONString
    func mapJSONString() -> String?
    
    /// Model 转换 JSONString 并格式化
    ///
    /// - Parameter prettyPrint: 是否格式化输出
    func mapJSONString(prettyPrint: Bool) -> String?
    
    
}

/// HandyJSONEnum 协议扩展
public protocol MappableEnum: HandyJSONEnum { }

extension Mappable {
    
    /// 统一处理 JSON 转换 Model
    ///
    public static func mapObject(_ json: [String: Any]) -> Self? {
        typealias T = Self
        guard let object = JSONDeserializer<T>.deserializeFrom(dict: json) else {
            return nil
        }
        
        return object
    }
    
    public static func mapObject(from json: String?) -> Self? {
        typealias T = Self
        guard let object = JSONDeserializer<T>.deserializeFrom(json: json) else {
            return nil
        }
        
        return object
    }
    
    /// 统一处理 JSON 转换 Model 数组
    ///
    /// - Parameter json: 服务器返回 JSON
    /// - Returns: 对应 Model 数组
    public static func mapObjects(_ jsonArray: [[String: Any]]) -> [Self]? {
        typealias T = Self
        guard let object = JSONDeserializer<T>.deserializeModelArrayFrom(array: jsonArray) as? [Self] else {
            return nil
        }
        
        return object
    }
    
    public static func mapObjects(from json: String?) -> [Self]? {
        typealias T = Self
        guard let object = JSONDeserializer<T>.deserializeModelArrayFrom(json: json) as? [Self] else {
            return nil
        }
        
        return object
    }
    
    /// 时间戳 转换 Date，服务器、Android 时间戳转换到 iOS Date 需要除以 1000
    /// - Parameter timeInterval: 时间戳
    public static func transformDate(of timeInterval: Int64?) -> Date {
        if let timeInterval = timeInterval {
            return Date(timeIntervalSince1970: TimeInterval(timeInterval / 1000))
        }
        return Date()
    }
    
    /// iOS 时间戳转换成 服务器、Android 时间戳
    /// - Parameter date: iOS Date
    public static func transformTimeInterval(of date: Date?) -> Int64 {
        if let date = date {
            return Int64(date.timeIntervalSince1970 * 1000)
        }
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    /// Model 转换 JSON
    ///
    public func mapJSONObject() -> [String: Any]? {
        guard let json = self.toJSON() else { return nil }
        return json
    }
    
    /// Model 转换 JSONString
    public func mapJSONString() -> String? {
        guard let json = self.toJSONString() else { return nil }
        return json
    }
    
    /// Model 转换 JSONString 并格式化
    ///
    /// - Parameter prettyPrint: 是否格式化输出
    public func mapJSONString(prettyPrint: Bool) -> String? {
        guard let json = self.toJSONString(prettyPrint: prettyPrint) else { return nil }
        return json
    }
}

