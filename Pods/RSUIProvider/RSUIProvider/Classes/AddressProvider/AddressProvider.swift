//
//  AddressProvider.swift
//  RSUIProvider
//
//  Created by 袁小荣 on 2020/7/19.
//

import Foundation
import UIKit
import RSBaseConfig
import RSExtension

public protocol AddressProvider {
    /// 收货人姓名Label
    var consigneeNameFactory: UILabel { get }
    /// 中间小点Label
    var middleDotLabelFactory: UILabel { get }
    /// 电话号码Label
    var phoneLabelFactory: UILabel { get }
    /// 详情地址Label
    var detailLabelFactory: UILabel { get }
}

public extension AddressProvider where Self: UIView {
    var consigneeNameFactory: UILabel {
        let label = UILabel()
        label.text = "张婷"
        label.textColor = 0x222222.uiColor
        label.font = UIFont.medium(16.auto())
        return label
    }
    
    var middleDotLabelFactory: UILabel {
        let label = UILabel()
        label.text = " · "
        label.textColor = 0xF53831.uiColor
        label.font = UIFont.medium(16.auto())
        return label
    }
    
    var phoneLabelFactory: UILabel {
        let label = UILabel()
        label.text = "138****9745"
        label.textColor = 0x222222.uiColor
        label.font = UIFont.medium(16.auto())
        return label
    }
    
    var detailLabelFactory: UILabel {
        let label = UILabel()
        label.text = "北京市东城区东交民巷阳光金小区一期127号"
        label.textColor = 0x999999.uiColor
        label.font = UIFont.systemFont(ofSize: 12.auto())
        return label
    }
}
