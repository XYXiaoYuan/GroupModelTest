//
//  MoyaMapperPlugin.swift
//  MCNetworkManager
//
//  Created by chenhuan on 2019/6/25.
//

import Moya
import HandyJSON
import Result

public enum MMStatusCode: Int {
    case success = 0
    case cache = 230
    case systemError = 500
    /// 登录过期
    case tokenInvild = 401
    /// 无网络或路径不存在
    case loadFail = 404
    /// 无效的 UUID
    case invalidUUID = 100010
}

/// Moya 对象映射插件
public struct MoyaMapperPlugin<T: ResponseModelable>: PluginType {
    var parameter: T.Type
    
    public init(resultMapper: T.Type) {
        parameter = resultMapper
    }
    
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var processRequest = request
        /// 关闭 URL encode
        if let urlString = request.url?.absoluteString.removingPercentEncoding {
            processRequest.url = URL(string: urlString)
        }
        
        return processRequest
    }


    public func process(
        _ result: Result<Response, MoyaError>,
        target: TargetType
        ) -> Result<Response, MoyaError> {

        switch result {
        case .success(let response):
            do {
                // 捕捉其它问题，如 400
                let resp = try response.filterSuccessfulStatusAndRedirectCodes()
                /// 解析返回数据结构
                guard let newResult = response.mapObject(parameter) else {
                    return Result(value: failResponse(
                        statusCode: response.statusCode,
                        errorMsg: NetworkingMessage.invalidData.rawValue,
                        request: response.request,
                        response: response.response
                    ))
                }
                /// 记录解析结果
                resp.setResult(newResult)
                return Result(value: resp)
            } catch MoyaError.statusCode(let response) {
                /// 请求错误
                return Result(value: failResponse(
                    statusCode: response.statusCode,
                    errorMsg: result.error?.localizedDescription ?? "\(response.statusCode)",
                    request: response.request,
                    response: response.response
                ))
            } catch {
                /// 其他错误
                return Result(value: failResponse(
                    statusCode: response.statusCode,
                    errorMsg: result.error?.localizedDescription ?? "\(response.statusCode)",
                    request: response.request,
                    response: response.response
                ))
            }
            
        case .failure(let error):
            // 捕捉设备问题，如 网络不可达
            let response = failResponse(
                statusCode: MMStatusCode.loadFail.rawValue,
                errorMsg: error.localizedDescription
            )
            return Result(value: response)
        }
    }

    fileprivate func failResponse(
        statusCode: Int,
        errorMsg: String,
        request: URLRequest? = nil,
        response: HTTPURLResponse? = nil
        ) -> Response {
        let errorPar =  parameter.init(code: statusCode, message: errorMsg, data: nil)
        return Response.init([:], statusCode: statusCode, request: request, response: response, parameter: errorPar)
    }
}
