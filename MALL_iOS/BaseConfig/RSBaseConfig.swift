
//
//  RSBaseConfig.swift
//  MCBaseConfig
//
//  Created by yxr on 2018/5/25.
//

import Foundation
import UIKit

/// 屏幕宽度
public let screenWidth = UIScreen.main.bounds.width
public let screenHeight = UIScreen.main.bounds.height

/// 是否为异性全面屏
public let isFullScreen = (statusBarHeight > 20)
/// 状态栏高度
public let statusBarH = (CGFloat)(isFullScreen ? statusBarHeight : 20.0)
/// 导航栏最大的Y值
public let navbarMaxY = (CGFloat)(isFullScreen ? 44.0 + statusBarHeight : 64.0)
/// tabBar标签栏的高度
public let tabbarH = (CGFloat)(isFullScreen ? 49.0 + 34.0 : 49.0)
/// tabBar的安全底部间距
public let tabbarSafeMargin = (CGFloat)(isFullScreen ? 34.0 : 0.0)

/// 状态栏高度(包括刘海屏)
private let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height

/// 设计图是根据 375 * 812 来做的
public extension UIScreen {
    /// 宽度等比例适配,一般不用, 直接用AutoInch(10.auto()), AutoInch内部是根据宽度来适配的
    static func pWidth(_ width: CGFloat) -> CGFloat {
        return screenWidth / 375.0 * width
    }
    
    /// 高度等比例适配
    static func pHeight(_ height: CGFloat) -> CGFloat {
        return screenHeight / 812.0 * height
    }
}

/// 全局打印,发布时不触发
///
/// - Parameters:
///   - msg: 需要打印的信息
///   - file: 所在的 "swift文件"
///   - line: 打印操作发生在哪一行
///   - fn: 所在文件的"方法名"
public func print<T>(_ msg: T,
              file: NSString = #file,
              line: Int = #line,
              fn: String = #function) {
    #if DEBUG
    let prefix = "🗂_\(file.lastPathComponent)_🏷_\(line)_🧩_\(fn):"
    print(prefix, msg)
    #endif
}


