//
//  DataResponse+Parse.swift
//  NetworkingComponent
//
//  Created by 袁小荣 on 2021/5/14.
//  解析一些基础的json

import Foundation
import HandyJSON

extension DataResponse {
    
    /// 解析JSON对象数组, 返回结果为 [GlobalAdModel]
    /// - Parameters:
    ///   - state: 响应状态
    ///   - response: 响应返回的对象
    ///   - message: 响应的消息
    ///   - closure: 回调
    public func parseList<T>(state: RequestResult, response: DataResponse<T>, message: NetworkingMessage, closure: @escaping (_ state: RequestResult, _ message: String, _ data: [T]) -> Void) where T: HandyJSON {
        DispatchQueue.main.async {
            if state == .success {
                switch response {
                case .list(let items):
                    closure(.success, message.rawValue, items)
                default: break
                }
            } else {
                closure(.failure, message.rawValue, [])
            }
        }
    }
    
    /// 解析JSON对象, 返回结果为 GlobalAdModel
    /// - Parameters:
    ///   - state: 响应状态
    ///   - response: 响应返回的对象
    ///   - message: 响应的消息
    ///   - closure: 回调
    public func parseObject<T>(state: RequestResult, response: DataResponse<T>, message: NetworkingMessage, closure: @escaping (_ state: RequestResult, _ message: String, _ data: T?) -> Void) where T: HandyJSON {
        DispatchQueue.main.async {
            if state == .success {
                guard case .object(let model) = response else {
                    closure(state, message.rawValue, nil)
                    return
                }
                closure(state, message.rawValue, model)
            } else {
                closure(.failure, message.rawValue, nil)
            }
            return
        }
    }
    
    /// 解析JSON对象中, 当data当只有一个字段时,如String, Bool, Int
    /// - Parameters:
    ///   - state: 响应状态
    ///   - response: 响应返回的对象
    ///   - message: 响应的消息
    ///   - closure: 回调
    public func parseSingleField<T, V>(state: RequestResult, response: DataResponse<T>, message: NetworkingMessage, dataType: V.Type, closure: @escaping (_ state: RequestResult, _ message: String, _ data: V?) -> Void) {
        DispatchQueue.main.async {
            switch response {
            case .jsonObject(let data):
                guard state == .success else {
                    closure(.failure, message.rawValue, data as? V)
                    return
                }
                guard let address = data as? V else {
                    closure(.failure, "数据格式有误", nil)
                    return
                }
                closure(state, message.rawValue, address)
                return
            default: break
            }
            closure(.failure, message.rawValue, nil)
            return
        }
    }
}
