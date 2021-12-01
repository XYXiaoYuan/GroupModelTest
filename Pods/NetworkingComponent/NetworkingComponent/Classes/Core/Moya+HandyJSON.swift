//
//  Moya+HandyJSON.swift
//  NetworkingComponent
//
//  Created by tofu on 2019/6/26.
//

import UIKit
import Moya
import HandyJSON

public extension Response {
    
    /// 整个 Data Model
    func mapObject<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) -> T? {
        
        guard let dataString = String(data: self.data, encoding: .utf8),
            let object = JSONDeserializer<T>.deserializeFrom(json: dataString, designatedPath: designatedPath) else {
                return nil
        }
        
        return object
    }
    
    /// Data 对应的 [Model]
    func mapArray<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) -> [T?]? {
        
        guard let dataString = String(data: self.data, encoding: .utf8),
            let object = JSONDeserializer<T>.deserializeModelArrayFrom(json: dataString, designatedPath: designatedPath)
            else {
                return nil
        }
        return object
    }
    
    
    
    /// 映射业务层需要的 Model
    ///
    /// - Parameters:
    ///   - type: 模型类型
    /// - Returns: 模型，如是转换失败则返回 nil
    func mapResultObject<T: HandyJSON>(_ type: T.Type) -> T {
        guard let jsonObject = self.result.data as? [String: Any],
            let object = JSONDeserializer<T>.deserializeFrom(dict: jsonObject)
            else {
                return T.init()
        }
        
        return object
    }
    
    
    // 映射业务层需要的 Model 数组
    ///
    /// - Parameters:
    ///   - type: 模型类型
    /// - Returns: 模型，如是转换失败则返回 nil
    func mapResultObjects<T: HandyJSON>(_ type: T.Type) -> [T] {
        guard let jsonObjects = self.result.data as? [[String: Any]],
            let objects = JSONDeserializer<T>.deserializeModelArrayFrom(array: jsonObjects)
            else {
                return []
        }
        
        var temp: [T] = []
        for object in objects {
            if let model = object {
                temp.append(model)
            }
        }
        
        return temp
    }
    
}

