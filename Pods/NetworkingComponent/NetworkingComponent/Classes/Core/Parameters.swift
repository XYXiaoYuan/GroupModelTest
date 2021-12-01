//
//  Parameters.swift
//  MCNetworkManager
//
//  Created by chenhuan on 2019/6/25.
//

import Foundation
import Moya
import UIKit
import CoreTelephony

/// 网络请求统一参数包
public struct Parameters {
    /// 超时时间
    public static let defaultTimeout : TimeInterval = 20
    /// 参数编码格式，默认 JSONEncoding
    public var encoding: ParameterEncoding = JSONEncoding()
    /// 最终的请求参数
    public var values: [String: Any]
    
    /// 初始化参数
    ///
    /// - Parameters:
    ///   - encoding: 参数编码格式，默认 JSONEncoding
    ///   - values: 请求参数
    public init(encoding: ParameterEncoding = JSONEncoding(), values: [String: Any?]) {
        self.encoding = encoding
        let filt = filterNil(values)
        self.values = Parameters.getCommonPara(privateParmer: filt)
    }

    public init(encoding: ParameterEncoding = JSONEncoding(), customValues: [String: Any]) {
        self.encoding = encoding
        self.values = customValues
    }

    /// 公共参数
    public static func getCommonPara(privateParmer: [String:Any] = [:]) -> [String:Any] {
        let tempParam: [String:Any] = privateParmer
//        if tempParam["token"] == nil {
//            tempParam["token"] = SessionConfigure.shared.userToken
//        }
//
//        tempParam["uid"] = SessionConfigure.shared.uuid
//        tempParam["platformType"] = "1"/// 平台类型 1米橙  2米橙浏览器
//        tempParam["system"] = "2"/// 系统类型 1安卓  2苹果
//        tempParam["device"] = "3"/// 0其它、1华为、2小米、3苹果
//        tempParam["model"] = UIDevice.current.modelName ///设备型号
//        tempParam["idfa"] = SessionConfigure.shared.idfa // idfa
//        tempParam["operator"] = self.getCarriName()
        
//        if let reachablity = NetworkReachabilityListener.shared.reachability {
//            if reachablity.isReachableOnEthernetOrWiFi {
//                tempParam["network"] = 0 //wifi
//            }else if reachablity.isReachableOnWWAN {
//                // 移动网络
//                tempParam["network"] = 1
//            }
//        }
//
//        tempParam["network"] = 0
//        tempParam["version"] = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "").replacingOccurrences(of: "\n", with: "")
//        tempParam["osversion"] = UIDevice.current.systemVersion
        return tempParam
    }
    
    public static func getCarriName() -> Int {
        let info = CTTelephonyNetworkInfo()
        var tempInt = 0
        if let carrier = info.subscriberCellularProvider {
            if let name = carrier.carrierName {
                if name == "中国联通" {
                    tempInt = 1
                }else if name == "中国移动" {
                    tempInt = 2
                }else if name == "中国电信" {
                    tempInt = 0
                }
            }
        }
        return tempInt
    }
}

extension UIDevice {
    //获取设备具体详细的型号
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

infix operator =>

public func => (encoding: ParameterEncoding, values: [String: Any?]) -> Parameters {
    return Parameters(encoding: encoding, values: values)
}

/// Returns a new dictinoary by filtering out nil values.
private func filterNil(_ dictionary: [String: Any?]) -> [String: Any] {
    var newDictionary: [String: Any] = [:]
    for (key, value) in dictionary {
        guard let value = value else { continue }
        newDictionary[key] = value
    }
    return newDictionary
}
