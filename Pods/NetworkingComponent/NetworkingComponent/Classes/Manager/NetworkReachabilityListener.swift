//
//  DataManager.swift
//  RemindData
//
//  Created by gg on 04/12/2017.
//  Copyright © 2017 ganyi. All rights reserved.
//

import Foundation
import Alamofire

/// 网络状态监听
public final class NetworkReachabilityListener {
    //MARK:- class init *****************************************************************************************************
    public static let shared = NetworkReachabilityListener()

    public let reachability = NetworkReachabilityManager()
    
    //MARK:- 监测网络是否可用
    public func isNetworkEnable() -> Bool{
        guard let reachability = reachability else{
            debugPrint("<Reachability> 生成网络监测失败")
            return false
        }

        //判断连接类型
        if reachability.isReachableOnEthernetOrWiFi {
            debugPrint("<reachability> type: WiFi")
        } else if reachability.isReachableOnCellular {
            debugPrint("<reachability> type: 移动网络")
        } else {
            debugPrint("<reachability> type: 没有网络连接")
        }
        
        //判断连接状态
        if reachability.isReachable {
            debugPrint("<reachability> state: 网络可用")
            return true
        } else {
            debugPrint("<reachability> state: 网络不可用")
            return false
        }
    }
    
}
