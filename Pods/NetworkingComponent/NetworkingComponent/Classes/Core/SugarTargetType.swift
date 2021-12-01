//
//  SugarTargetType.swift
//  MCNetworkManager
//
//  Created by chenhuan on 2019/6/25.
//

import Foundation
import Moya
import MapKit

/// 快速设置接口的请求路径和参数
public struct NetworkConfig {
    public var route: RequestMethod
    public var params: [String: Any]
    public var parameters: Parameters?

    public init(route: RequestMethod, params: [String: Any]) {
        self.route = route
        self.params = params
        self.parameters = Parameters(values: params)
    }
}

public protocol SugarTargetType: TargetType {
    var url: URL { get }
    var route: RequestMethod { get }
    var parameters: Parameters? { get }
    var timeout: TimeInterval { get }
    var config: NetworkConfig { get }
//    var isIgnoreUid: Bool { get}
}

public extension SugarTargetType {

    var baseURL: URL {
        return URL.init(string: NetworkingHost.api)!
    }
    
    var url: URL {
        return self.defaultURL
    }

    var defaultURL: URL {
        return self.path.isEmpty ? self.baseURL : self.baseURL.appendingPathComponent(self.path)
    }

    var path: String {
        return self.route.path
    }

    var method: Moya.Method {
        return self.route.method
    }

    var task: Task {
        switch self.route.method {
        case .get:
            guard let parameters = self.parameters else { return .requestPlain }
            return .requestParameters(parameters: parameters.values, encoding: URLEncoding.default)
        default:
            guard let parameters = self.parameters else { return .requestPlain }
            return .requestParameters(parameters: parameters.values, encoding: parameters.encoding)
        }
    }

    var timeout : TimeInterval {
        return Parameters.defaultTimeout
    }
    
    var config: NetworkConfig {
        return NetworkConfig(route: route, params: [:])
    }

    var headers: [String : String]? {
        return [ "Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return "".data(using: .utf8) ?? Data()
    }

//    var isIgnoreUid: Bool {
//        return true
//    }
    
}
