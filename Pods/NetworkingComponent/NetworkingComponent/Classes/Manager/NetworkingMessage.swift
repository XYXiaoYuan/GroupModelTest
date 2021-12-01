//
//  NetworkingMessage.swift
//  NetworkingComponent
//
//  Created by tofu on 2019/6/26.
//
//
//
import UIKit

/// 网络库提示信息
public struct NetworkingMessage: Hashable, Equatable, RawRepresentable {
    public var rawValue: String
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension NetworkingMessage {
    /// 无网络提示信息
    static let notReachable = NetworkingMessage("无法连接网络，请稍后再试")
    /// 来自缓存
    static let fromCache = NetworkingMessage("fromCache")
    /// 无效数据
    static let invalidData = NetworkingMessage("数据解析失败，请检查网络数据格式")
    /// 无效 UUID
    static let invalidUUID = NetworkingMessage("无法连接网络，请稍后再试")
}
