//
//  RegisterDeviceManager.swift
//  NetworkingComponent
//
//  Created by chenhuan on 2019/6/28.
//

import Foundation
import Moya

enum RegisterDeviceApi {
    case registerDevice
}

extension RegisterDeviceApi: SugarTargetType {
    public var route: RequestMethod {
        switch self {
        case .registerDevice: return .post("member/register")
        }
    }

    var isIgnoreUid: Bool {
        return false
    }

    public var parameters: Parameters? {
        switch self {
        case .registerDevice:
            return Parameters(values: ["deviceToken": UserDefaults.standard.string(forKey: "token") ?? ""])
        }
    }
}

typealias RegisterDeviceNetworking = NetworkingManager<RegisterDeviceApi>

/// 底层注册设备 API
public class RegisterDeviceManager {

    let networking: RegisterDeviceNetworking
    /// 当前请求是否在注册
    var isRegister: Bool = false

    public static let share = RegisterDeviceManager(RegisterDeviceNetworking(plugins: []))

    fileprivate init(_ networking: RegisterDeviceNetworking) {
        self.networking = networking
    }
    
    public func registterDevice(closure: ((RequestResult) -> Void)? = nil) {
        objc_sync_enter(self)
        if !self.isRegister {
            self.isRegister = true
            self.networking.sendRequest(.registerDevice) { (state, response, message) in
                if state == .success {
                    switch response {
                    case .jsonObject(let data):
                        if let datt = data as? [String : String] {
                            SessionConfigure.shared.uuid = datt["uid"] ?? ""
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registDeviceSuccess"), object: nil, userInfo: nil)
                        }
                        break
                    default: break
                    }
                    closure?(.success)
                } else {
                    closure?(.failure)
                }
                self.isRegister = false
            }
        }
        objc_sync_exit(self)

    }

}
