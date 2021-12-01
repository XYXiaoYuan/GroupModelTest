//
//  LEYYCacheManager.swift
//  MCCache
//
//  Created by hw on 2019/6/12.
//

import UIKit
import YYCache

/// UserDefaults 缓存更新记录key
public let kUDKeyCacheUpdateTime = "CacheUpdateTime"

let kDefaultExpirationDate: TimeInterval = 3600 * 24 * 30
let kDefaultUpdateTimeInterval: TimeInterval = 3600

public let kTimeIntervalRightNow: TimeInterval = 5
public let kTimeIntervalHalfDay: TimeInterval = 3600 * 12
public let kTimeIntervalOneDay: TimeInterval = 3600 * 24
public let kTimeIntervalThreeDay: TimeInterval = 3600 * 24 * 3
public let kTimeIntervalOneWeek: TimeInterval = 3600 * 24 * 7
public let kTimeIntervalOneMonth: TimeInterval = 3600 * 24 * 30
public let kTimeIntervalThreeMonth: TimeInterval = 3600 * 24 * 90
public let kTimeIntervalOneYear: TimeInterval = 3600 * 24 * 365
public let kTimeIntervalHalfYear: TimeInterval = 3600 * 24 * 180

/// 缓存加载方式
public enum LoadCacheType: Int {
    /// 不加载缓存  default
    case ignoreCache = 0,
    
    /// 加载缓存
    loadFromCache,
    
    /// 先读缓存再请求
    loadCacheFirst,
    
    /// 有缓存只用缓存不请求，否则发请求重新获取数据
    loadCacheOnly,
    
    /// 只请求接口并刷新缓存
    refreshCache
}

///// 缓存数据的页面类型
//public enum CacheDataPageType: Int {
//    /// 计步
//    case step = 1,
//    other
//}

public class CacheManager: NSObject {
    let cache = YYCache(name: "RSCache")
    
    //MARK: - Life Cycle
    public static let shareInstance = CacheManager()
    
    public override init() {
        super.init()
        cache?.diskCache.countLimit = 100
        cache?.memoryCache.countLimit = 50
        cache?.diskCache.ageLimit = kDefaultExpirationDate
        cache?.diskCache.errorLogsEnabled = true
    }
    
    //MARK: - Public Methods
    @discardableResult
    public func configDiskCache(cacheKey: String,
                                updateTimeInterval _: TimeInterval = 3600,
                                loadCacheType: LoadCacheType = .loadFromCache,
                                expirationDate _: TimeInterval = 3600 * 24 * 30,
                                path _: String? = "ApiCache") -> MCCache {
        let cacheObject = MCCache()
        cacheObject.key = cacheKey
        cacheObject.type = loadCacheType
        if let oldObj = CacheManager.shareInstance.loadDiskCache(key: cacheKey) {
            cacheObject.conent = oldObj.conent
        }
        
        cache?.setObject(cacheObject as NSCoding, forKey: cacheKey
            , with: {})
        
        return cacheObject
    }
    
    /// 向磁盘写缓存
    ///
    /// - Parameter cacheObj: 缓存对象
    public func saveDiskCache<T: NSCoding>(_ cacheObj: T, key: String) {
        cache?.setObject(cacheObj, forKey: key
            , with: {})
    }
    
    /// 加载缓存
    ///
    /// - Returns: 缓存对象<T: NSCoding>
    public func loadDiskCache(key: String) -> MCCache? {
        let object = cache?.object(forKey: key)
        return object as? MCCache
    }
    
    /// 删除缓存
    public func deleteDiskCache(withCacheKey key: String) {
        cache?.removeObject(forKey: key, with: { _ in
            
        })
    }
    
    /// 清理缓存（数据缓存暂不清理）
    public func clearCache() {
        cache?.removeAllObjects({})
    }
    
    /// 删除失效缓存
//    public func deleteDiskCache(withType type: CacheDataPageType) {
//        switch type {
//        case .step:
//            break
//        default:
//            break
//        }
//    }
}

/// 缓存
public class MCCache: NSObject, NSCoding {
    //MARK: - Properties
    /// 缓存key
    public var key = ""
    /// 缓存加载方式
    public var type = LoadCacheType.loadFromCache
    /// 缓存
    public var conent = ""
    
    //MARK: - Life Cycle
    public override init() {
        super.init()
    }
    
    //MARK: - Public Methods
    @discardableResult
    public func configDiskCache(cacheKey: String,
                                updateTimeInterval: TimeInterval = 3600,
                                loadCacheType: LoadCacheType = .loadFromCache,
                                expirationDate: TimeInterval = 3600 * 24 * 30,
                                path: String? = "ApiCache") -> MCCache {
        return CacheManager.shareInstance.configDiskCache(cacheKey: cacheKey,
                                                            updateTimeInterval: updateTimeInterval,
                                                            loadCacheType:
            loadCacheType,
                                                            expirationDate: expirationDate,
                                                            path: path)
    }
    
    /// 加载缓存
    ///
    /// - Returns: 缓存对象<T: NSCoding>
    public func loadDiskCache() -> Any? {
        let cacheObj = CacheManager.shareInstance.loadDiskCache(key: self.key)
        return cacheObj?.conent
    }
    
    /// 向磁盘写缓存
    ///
    /// - Parameter cacheObj: 缓存对象
    public func saveDiskCache<T: NSCoding>(_ conent: T) {
        guard let cacheObj = CacheManager.shareInstance.loadDiskCache(key: self.key) else {
            return
        }
        cacheObj.conent = conent as! String
        CacheManager.shareInstance.saveDiskCache(cacheObj, key: self.key)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(conent, forKey: "conent")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.key = aDecoder.decodeObject(forKey: "key") as! String
        let typeRawValue = aDecoder.decodeInteger(forKey: "type")
        self.type = LoadCacheType(rawValue: typeRawValue) ?? .loadFromCache
        self.conent = aDecoder.decodeObject(forKey: "conent") as! String
        super.init()
    }
}
