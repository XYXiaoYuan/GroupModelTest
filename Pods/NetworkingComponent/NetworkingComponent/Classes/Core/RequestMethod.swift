//
//  RequestMethod.swift
//  MCNetworkManager
//
//  Created by chenhuan on 2019/6/25.
//

import Foundation
import Moya

/// 请求类型
public enum RequestMethod {

    case get(String)
    case post(String)

    /// 请求路径
    public var path: String {
        switch self {
        case .get(let path): return path
        case .post(let path): return path
        }
    }

    /// 请求方法
    public var method: Moya.Method {
        switch self {
        case .get: return .get
        case .post: return .post
        }
    }

}
