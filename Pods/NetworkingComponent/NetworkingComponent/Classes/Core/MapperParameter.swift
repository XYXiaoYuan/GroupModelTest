//
//  MapperParameter.swift
//  MCNetworkManager
//
//  Created by chenhuan on 2019/6/25.
//

import Foundation
import HandyJSON
import Moya

public protocol MCConvertable: HandyJSON { }
public protocol ResponseModelable: MCConvertable {
    /// 请求成功时状态码对应的值
    var code: Int { get }
    /// 状态码对应的键
    var message: String { get }
    /// 请求后的提示语对应的键
    var data: Any?  { get }
    init(code: Int, message: String, data: Any?)
}

/// 服务器返回数据特定结构
open class ResultModel: ResponseModelable {
    /// 状态码，非0为错误
    open var code: Int = 0
    /// 提示信息
    open var message: String = ""
    /// 返回数据，object 或 array
    open var data: Any?

    public required init() { }

    public required init(code: Int, message: String, data: Any?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

public enum DataResponse<T: HandyJSON>: Equatable {
    
    public static func == (lhs: DataResponse<T>, rhs: DataResponse<T>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.object, .object),
             (.list, .list),
             (.statusCode, .statusCode),
             (.jsonObject, .jsonObject):
            return true
        default:
            return false
        }
    }
    
    /// 单个对象
    case object(model: T)
    /// 对象列表
    case list(list: [T])
    /// 原数据返回
    case jsonObject(data: Any?)
    /// 出错时抛出状态码与原数据
    case statusCode(code: Int, data: Any?)
    /// 无返回
    case none
}

/// 接口无返回数据，或需要原数据时使用的类型
///
public struct OriginDataResponse: HandyJSON {
    public init() { }
}

extension Response {
    // 主要用于 catchError

    /// 创建Response
    ///
    /// - Parameters:
    ///   - dataDict: 数据字典
    ///   - statusCode: 状态码
    ///   - parameterType: ModelableParameterType
    convenience init(
        _ dataDict: [String: Any],
        statusCode: Int, request: URLRequest? = nil, response: HTTPURLResponse? = nil,
        parameter: ResponseModelable
        ) {
        defer { self.setResult(parameter) }
        let jsonData = (try? JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)) ?? Data()
       self.init(statusCode: statusCode, data: jsonData, request: request, response: response)
    }

    /// 设置数据解析参数
    ///
    /// - Parameter response: ResponseModelable
    func setResult(_ result: ResponseModelable) {
        self.result = result
    }

    private struct AssociatedKeys {
        static var responseKey = "responseModelableKey"
    }
    
    /// 返回参数统一结构
    var result: ResponseModelable {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.responseKey) as AnyObject
            guard let type = value as? ResponseModelable else {
                return ResultModel()
            }
            return type
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.responseKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


