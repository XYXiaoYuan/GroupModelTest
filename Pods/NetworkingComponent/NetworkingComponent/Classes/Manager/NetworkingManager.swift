//
//  NetworkingManager.swift
//  MCNetworkManager
//
//  Created by chenhuan on 2019/6/25.
//

import Foundation
import Moya
import Alamofire
import Result
import HandyJSON

/// 网络请求回调状态
public enum RequestResult {
    /// 请求成功
    case success
    /// 请求失败
    case failure
}

/// 响应头信息
public class ResponseHeader {
    public var date: Date?
    public static let shared = ResponseHeader()
}

/// 网络请求回调函数
public typealias RequestCompletion<T: HandyJSON> = (_ result: RequestResult, _ data: DataResponse<T>, _ message: NetworkingMessage) -> Void

/// 网络请求基类
public final class NetworkingManager<Target: SugarTargetType>: MoyaSugarProvider<Target> {
    
    /// 初始化网络请求
    ///
    /// - Parameter plugins: 插件
    /// - Parameter resultMapper: 服务器返回最外层数据结构
    /// - Parameter logOptions: 打印配置
    public init(plugins: [PluginType] = [], logOptions: NetworkLoggerPlugin.Configuration.LogOptions = .default, resultMapper: PluginType = MoyaMapperPlugin<ResultModel>(resultMapper: ResultModel.self)) {
        let configuration = URLSessionConfiguration.default
        configuration.headers = HTTPHeaders.default
        var allPlugins = Array(plugins)
        allPlugins.append(resultMapper)
        allPlugins.append(NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: logOptions)))
        let session = Session(configuration: configuration, startRequestsImmediately: false)
        super.init(session: session, plugins: allPlugins)
    }
    
    /// 网络请求统一入口，不自动 Mapper 返回原数据
    ///
    /// - Parameters:
    ///   - target: 请求目标
    ///   - completion: 请求完成回调
    @discardableResult
    public func sendRequest(_ taret: Target, completion: RequestCompletion<OriginDataResponse>? = nil) -> Cancellable? {
        sendRequest(taret, mapper: OriginDataResponse.self, completion: completion)
    }
    
    /// 网络请求统一入口
    ///
    /// - Parameters:
    ///   - target: 请求目标
    ///   - mapper: 映射对应类型，如无数据返回或不需要映射，则传参 'OriginResponse.self'
    ///   - completion: 请求完成回调
    @discardableResult
    public func sendRequest<T>(_ target: Target, mapper: T.Type, completion: RequestCompletion<T>? = nil) -> Cancellable? where T: HandyJSON {
        /// 判断是否需要注册 UUID
//        if registerDeviceIfNeeded() && target.isIgnoreUid {
        if registerDeviceIfNeeded() {
            RegisterDeviceManager.share.registterDevice()
            completion?(.failure, .statusCode(code: MMStatusCode.invalidUUID.rawValue, data: nil), .invalidUUID)
            return nil
        }

        //callbackQueue: DispatchQueue.global(
        /// 发送 Moya 请求
        return self.request(target, callbackQueue: DispatchQueue.global()) { (result) in
            let tab = "                                   "
            switch result {
            case let .success(response):
                /// 保存响应头里的Date
                if let responseHeaders = response.response?.allHeaderFields,
                   let date = responseHeaders["Date"] as? String {
                    let formatter = DateFormatter.init()
                    formatter.timeZone = TimeZone.init(identifier: "GMT")
                    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT'"
                    formatter.locale = Locale.init(identifier: "en_US")
                    
                    let time = formatter.date(from: date)
                    ResponseHeader.shared.date = time
                    print("🐝🐝🐝date = \(date), time = \(String(describing: time))")
                }
                
                /// 网络状态判断 或 url 地址不存在
                if response.statusCode == MMStatusCode.loadFail.rawValue {
                    sleep(1)
                    completion?(.failure, .statusCode(code: MMStatusCode.loadFail.rawValue, data: response.result.data), NetworkingMessage.notReachable)
                    ///log LogError("<Request：\(target.url)> \n\(tab)<Parameters: \(target.parameters?.values ?? [:])> \n\(tab)<Response: \(NetworkingMessage.notReachable.rawValue), Code: \(response.statusCode)>")
                    return
                }
                
                /// 判断服务器返回状态
                guard response.result.code == MMStatusCode.success.rawValue else {
                    /// 登录过期
                    if response.result.code == MMStatusCode.tokenInvild.rawValue {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginTokenIsExpired"),
                                                            object: nil,
                                                            userInfo: ["url": "\(response.request?.url?.absoluteString ?? "")"])
                            LogError("<Request：\(target.url)> \n\(tab)<Parameters: \(target.parameters?.values ?? [:])> \n\(tab)<Response: \(response.result.message.isEmpty == false ? response.result.message : "登录已过期"), Code: \(response.statusCode)>")
                        }
                    } else {
                        /// 其他出错情况
                        /// 500错误
                        if response.result.code == MMStatusCode.systemError.rawValue {
                            completion?(.failure, .jsonObject(data: response.result.data), NetworkingMessage(response.result.message))
                            return
                        }

                    }
                    completion?(.failure, .statusCode(code: response.result.code, data: response.result.data), NetworkingMessage(response.result.message))
                    return
                }
                                
                /// 不需要解析 Model，直接返回原数据
                if mapper == OriginDataResponse.self {
                    completion?(.success, .jsonObject(data: response.result.data), NetworkingMessage(response.result.message))
                    return
                }
                
                /// 单个对象
                if let _ = response.result.data as? [String: Any] {
                    let obj = response.mapResultObject(mapper)
                    completion?(.success, .object(model: obj), NetworkingMessage(response.result.message))
                    return
                }
                
                /// 列表
                if let _ = response.result.data as? [[String: Any]] {
                    let objs = response.mapResultObjects(mapper)
                    completion?(.success, .list(list: objs), NetworkingMessage(response.result.message))
                    return
                }
                
                
            case let .failure(error):
                /// 请求出错
                completion?(.failure, .statusCode(code: error.errorCode, data: nil), NetworkingMessage(error.errorDescription ?? error.localizedDescription))
                ///log LogError("<Request：\(target.url)> \n\(tab)<Parameters: \(target.parameters?.values ?? [:])> \n\(tab)<Response: \(error.errorDescription ?? error.localizedDescription), Code: \(error.errorCode)>")
                break
            }
        }
    }
    
    /// 带缓存的网络请求统一接口，不自动 Mapper 返回原数据
    ///
    /// - Parameters:
    ///   - target: 请求目标
    ///   - isNeedCache: 是否需要缓存
    ///   - cacheKey: 自定义缓存 key，默认将 url 做为缓存的 key
    ///   - completion: 请求完成回调
    /// - Returns: 取消能力
    @discardableResult
    public func sendCacheRequest(_ taret: Target, isNeedCache: Bool = true, cacheKey: String? = nil, completion: RequestCompletion<OriginDataResponse>? = nil) -> Cancellable? {
        sendCacheRequest(taret, mapper: OriginDataResponse.self, isNeedCache: isNeedCache, cacheKey: cacheKey, completion: completion)
    }
    
    /// 带缓存的网络请求统一接口
    ///
    /// - Parameters:
    ///   - target: 请求目标
    ///   - mapper: 映射对应类型，如无数据返回或不需要映射，则传参 'OriginResponse.self'
    ///   - isNeedCache: 是否需要缓存
    ///   - cacheKey: 自定义缓存 key，默认将 url 做为缓存的 key
    ///   - completion: 请求完成回调
    /// - Returns: 取消能力
    @discardableResult
    public func sendCacheRequest<T: HandyJSON>(_ target: Target, mapper: T.Type, isNeedCache: Bool = true, cacheKey: String? = nil, completion: RequestCompletion<T>? = nil) -> Cancellable? {

        /// 判断是否需要注册 UUID
//        if registerDeviceIfNeeded() && target.isIgnoreUid {
        if registerDeviceIfNeeded() {
            RegisterDeviceManager.share.registterDevice()
            completion?(.failure, .statusCode(code: MMStatusCode.invalidUUID.rawValue, data: nil), .invalidUUID)
            return nil
        }
        
        /// 处理缓存结果
        handleCacheResult(target, mapper: mapper, isNeedCache: isNeedCache, cacheKey: cacheKey, completion: completion)
        
        /// 发送 Moya 请求
        return self.request(target, callbackQueue: DispatchQueue.global()) { [weak self](result) in
            let tab = "                                   "
            switch result {
            case let .success(response):
                /// 网络状态判断 或 url 地址不存在
                if response.statusCode == MMStatusCode.loadFail.rawValue {
                    completion?(.failure, .statusCode(code: MMStatusCode.loadFail.rawValue, data: response.result.data), NetworkingMessage.notReachable)
                    ///log LogError("<Request：\(target.url)> \n\(tab)<Parameters: \(target.parameters?.values ?? [:])> \n\(tab)<Response: \(NetworkingMessage.notReachable.rawValue), Code: \(response.statusCode)>")
                    return
                }
                
                /// 处理服务器状态码
                guard response.result.code == MMStatusCode.success.rawValue else {
                    /// 登录过期
                    if response.result.code == MMStatusCode.tokenInvild.rawValue {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginTokenIsExpired"),
                                                            object: nil,
                                                            userInfo: ["url": "\(response.request?.url?.absoluteString ?? "")"])
                            LogError("<Request：\(target.url)> \n\(tab)<Parameters: \(target.parameters?.values ?? [:])> \n\(tab)<Response: \(response.result.message.isEmpty == false ? response.result.message : "登录已过期"), Code: \(response.statusCode)>")
                        }
                    }
                    /// 其他失败的情况优先返回缓存，如没有缓存则返回失败
                    if self?.handleCacheResult(target, mapper: mapper, isNeedCache: isNeedCache, completion: completion) == nil {
                        completion?(.failure, .statusCode(code: response.result.code, data: response.result.data), NetworkingMessage(response.result.message))
                        ///log LogError("<Request：\(target.url)> \n\(tab)<Parameters: \(target.parameters?.values ?? [:])> \n\(tab)<Response: \(response.result.message), Code: \(response.statusCode)>")
                    }
                    return
                }
                
                /// 保存缓存
                self?.saveCache(forTarget: target, isNeedCache: isNeedCache, cacheKey: cacheKey, with: response)
                
                /// 不需要解析 Model，直接返回原数据
                if mapper == OriginDataResponse.self {
                    completion?(.success, .jsonObject(data: response.result.data), NetworkingMessage(response.result.message))
                    return
                }
                
                /// 单个对象
                if let _ = response.result.data as? [String: Any] {
                    let obj = response.mapResultObject(mapper)
                    completion?(.success, .object(model: obj), NetworkingMessage(response.result.message))
                    return
                }
                
                /// 列表
                if let _ = response.result.data as? [[String: Any]] {
                    let objs = response.mapResultObjects(mapper)
                    completion?(.success, .list(list: objs), NetworkingMessage(response.result.message))
                    return
                }
            case let .failure(error):
                /// 请求出错
                completion?(.failure, .statusCode(code: error.errorCode, data: nil), NetworkingMessage(error.errorDescription ?? error.localizedDescription))
                ///log LogError("<Request：\(target.url)> \n\(tab)<Parameters: \(target.parameters?.values ?? [:])> \n\(tab)<Response: \(error.errorDescription ?? error.localizedDescription), Code: \(error.errorCode)>")
                break
            }
        }
    }

    /// 查询是否有缓存
    ///
    /// - Parameters:
    ///   - target: 当前请求
    /// - Returns: 结果
    private func fetchCacheResult(forTarget target: Target, cacheKey: String? = nil) -> Result<Response, MoyaError>? {
        /// 处理缓存
        var key = cacheKey ?? target.url.absoluteString
        key = key.isEmpty ? target.url.absoluteString : key
        if let cache = CacheManager.shareInstance.loadDiskCache(key: key) {
            if cache.type != .ignoreCache {
                if let cacheData = (cache.loadDiskCache() as? NSString)?.data(using: String.Encoding.utf8.rawValue) {
                    return Result(value: Response(statusCode: 200, data: cacheData))
                }
            }
        }
        
        return nil
    }
    
    /// 处理缓存结果
    ///
    /// - Parameters:
    ///   - target: 缓存请求
    ///   - mapper: 映射对象
    ///   - isNeedCache: 是否需要缓存
    ///   - completion: 完成回调
    @discardableResult
    private func handleCacheResult<T: HandyJSON>(_ target: Target, mapper: T.Type, isNeedCache: Bool = true, cacheKey: String? = nil, completion: RequestCompletion<T>? = nil) -> Response? {
        
        if let result = self.fetchCacheResult(forTarget: target, cacheKey: cacheKey), isNeedCache == true {
            /// 执行插件
            let processedResult = self.plugins.reduce(result) { $1.process($0, target: target) }
            switch processedResult {
            case .success(let response):
                guard response.result.code == MMStatusCode.success.rawValue else {
                    /// 登录过期
                    if response.result.code == MMStatusCode.tokenInvild.rawValue {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginTokenIsExpired"),
                                                            object: nil,
                                                            userInfo: ["url": "\(response.request?.url?.absoluteString ?? "")"])
                        }
                    }
                    completion?(.failure, .none, .fromCache)
                    return response
                }
                
                /// 不需要解析 Model，直接返回原数据
                if mapper == OriginDataResponse.self {
                    completion?(.success, .jsonObject(data: response.result.data), .fromCache)
                    break
                }
                
                /// 单个对象
                if let _ = response.result.data as? [String: Any] {
                    let obj = response.mapResultObject(mapper)
                    completion?(.success, .object(model: obj), .fromCache)
                    break
                }
                
                /// 列表
                if let _ = response.result.data as? [[String: Any]] {
                    let objs = response.mapResultObjects(mapper)
                    completion?(.success, .list(list: objs), .fromCache)
                    break
                }

            default: break
            }
        }
        
        return nil
    }

    /// 保存缓存
    ///
    /// - Parameters:
    ///   - target: 请求
    ///   - response: 返回数据
    private func saveCache(forTarget target: Target, isNeedCache: Bool = true, cacheKey: String? = nil, with response: Response) {
        /// 请求成功写缓存
        var key = cacheKey ?? target.url.absoluteString
        key = key.isEmpty ? target.url.absoluteString : key
        let cachable = MCCache().configDiskCache(cacheKey: key)
        if let cache = CacheManager.shareInstance.loadDiskCache(key: cachable.key) {
            if cache.type != .ignoreCache {
                if let responseString = NSString(data: response.data, encoding: String.Encoding.utf8.rawValue) {
                    cache.saveDiskCache(responseString)
                }
            }
        }
    }

    /// 是否需要注册 UUID
    ///
    /// - Returns: UUID
    private func registerDeviceIfNeeded() -> Bool {
        return false
    }
    
    
}
