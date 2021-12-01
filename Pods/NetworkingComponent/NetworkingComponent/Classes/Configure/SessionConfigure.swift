//
//  SessionConfigure.swift
//  MCNetworkManager
//
//  Created by chenhuan on 2019/6/25.
//

import Foundation
import AdSupport

/// 网络请求环境配置
public enum SessionEnvironment {
    /// 开发环境
    case development
    /// 测试环境
    case test
    /// 预发布环境
    case preProduction
    /// 正式环境
    case production
}

/// 网络请求环境配置
open class SessionConfigure {
    
    public static let shared = SessionConfigure()
    /// 配置环境
    public var environment: SessionEnvironment = .development
    /// 网络配置
    //    public let networking = NetworkingManager<SessionConfigureTargetType>()
    
    private var localIdfa: String?
    private var localUuid: String?
    
    // deviceToken 推送token
    //    public var deviceToken: String = UserDefaults.standard.string(forKey: "token") ?? "" {
    //        didSet {
    //            UserDefaults.standard.setValue(deviceToken, forKey: "token")
    //            networking.sendRequest(.refreshDeviceTokenByMember, mapper: OriginDataResponse.self) { (state, response, message) in
    //                debugPrint("[Networking-Logger] - \(message.rawValue)")
    //            }
    //        }
    //    }
    
    /// 用户 token
    public var userToken: String = (UserDefaults(suiteName:"LoginUser")?.object(forKey: "userToken") as? String) ?? "" {
        didSet {
            if userToken != oldValue {
                UserDefaults(suiteName:"LoginUser")?.setValue(userToken, forKey: "userToken")
            }
        }
    }
    
    /// 用户 uuid
    public var uuid: String = UserDefaults.standard.string(forKey: "uuid") ?? "" {
        didSet {
            if uuid != oldValue {
                UserDefaults.standard.setValue(uuid, forKey: "uuid")
            }
        }
    }
    
    /// 配置接口的api
    public func configApi(config: ((_ environment: SessionEnvironment) -> String)) {
        NetworkingHost.api = config(environment)
    }
    
    /// 获取本地idfa
    //    public var idfa: String {
    //            if let lIdfa = localIdfa {
    //                return lIdfa
    //            }
    //            let uuidString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    //            localIdfa = uuidString
    //
    //            if let currentIdfa = UserDefaults.standard.object(forKey: "uuid_idfa") as? String, currentIdfa == uuidString {
    //
    //            }
    //            else {
    //                UserDefaults.standard.setValue(uuidString, forKey: "uuid_idfa")
    //                /// 注册 idfa 接口
    //                networking.sendRequest(.refreshIdfaByMember, mapper: OriginDataResponse.self)
    //            }
    //
    //            return uuidString
    //    }
    
}


/// baseURL
public struct NetworkingHost {
    
    //    public static let version: String = "v1.0"
    
    /// API HOST: api.mc.cn
    public fileprivate(set) static var api: String = {
        switch SessionConfigure.shared.environment {
        case .development:
            return "http://192.168.16.192:8080/api/"
        case .test:
            return "http://120.24.24.11:8080/api/"
        case .preProduction:
            return "http://pre-web.vcrmall.com/api/"
        case .production:
            return "http://api.vcrmall.com/api/"
        }
    }()
        
    //    /// URL HOST: url.mc.cn
    //    public static let url: String = {
    //        switch SessionConfigure.shared.environment {
    //        case .development:
    //            return "https://test-url.mc.cn/"
    //        case .test:
    //            return "https://url.mc.cn/"
    ////        case .production:
    ////            return "https://url.mc.cn/"
    //        }
    //    }()
    //
    //    /// OSS HOST: upload.mc.cn
    //    public static let oss: String = {
    //        switch SessionConfigure.shared.environment {
    //        case .development:
    //            return "https://test-upload.mc.cn/restful/v3.3/"
    //        case .test:
    //            return "https://upload.mc.cn/restful/v3.3/"
    ////        case .production:
    ////            return "https://pre-api.mc.cn/restful/v3.3/"
    //        }
    //    }()
}


