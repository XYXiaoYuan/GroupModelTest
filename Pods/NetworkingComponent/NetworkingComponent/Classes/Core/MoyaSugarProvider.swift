//
//  MoyaSugarProvider.swift
//  MCNetworkManager
//
//  Created by chenhuan on 2019/6/25.
//

import Foundation
import Moya
import Result

fileprivate struct MoyaSugarSetting {
    static var targetTimeout: TimeInterval = Parameters.defaultTimeout
}

/// `MoyaSugarProvider` overrides `parameterEncoding` and `httpHeaderFields` of the
/// `endpointClosure` with `SugarTargetType`. `MoyaSugarProvider` can be used only with
/// `SugarTargetType`.
open class MoyaSugarProvider<Target: SugarTargetType>: MoyaProvider<Target> {

    override public init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false
        ) {

        var requestTimeoutClosure = requestClosure

        // modify request timeout
        requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaSugarProvider.RequestResultClosure) in

            guard var request = try? endpoint.urlRequest() else { return }
            request.timeoutInterval = MoyaSugarSetting.targetTimeout
            done(.success(request))
            //done(.failure(error))
        }

        func sugarEndpointClosure(target: Target) -> Endpoint {
            let endpoint = endpointClosure(target)
            MoyaSugarSetting.targetTimeout = target.timeout
            
            return endpoint.adding(newHTTPHeaderFields: target.headers ?? [:])
        }
        
        super.init(
            endpointClosure: sugarEndpointClosure,
            requestClosure: requestTimeoutClosure, // origin: requestClosure
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
}
