//
//  RSRMBLabelProvider.swift
//  RSUIProvider_Example
//
//  Created by 袁小荣 on 2020/7/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RSBaseConfig
import RSExtension

public protocol RSRMBLabelProvider {
    /// 人民币符号Label
    var rmbLabelFactory: UILabel { get }
    /// 人民币价格Label
    var rmbPriceLabelFactory: UILabel { get }
}

public extension RSRMBLabelProvider where Self: UIView {
    var rmbLabelFactory: UILabel {
        let label = UILabel()
        label.text = "￥"
        label.textColor = 0xF53831.uiColor
        label.font = UIFont.systemFont(ofSize: 13.auto())
        return label
    }
    
    var rmbPriceLabelFactory: UILabel {
        let label = UILabel()
        label.text = "256.0"
        label.textColor = 0xF53831.uiColor
        label.font = UIFont.systemFont(ofSize: 18.auto())
        return label
    }
}
