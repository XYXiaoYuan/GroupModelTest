//
//  RSGoodsNameProvider.swift
//  RSUIProvider_Example
//
//  Created by 袁小荣 on 2020/7/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RSBaseConfig
import RSExtension

public protocol RSGoodsNameProvider {
    /// 商品名字Label
    var goodsNameLabelFactory: UILabel { get }
}

public extension RSGoodsNameProvider where Self: UIView {
    var goodsNameLabelFactory: UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.text = "Huawei/华为 Mate 9 麒麟960芯片 徕卡双镜头"
        label.textColor = 0x333333.uiColor
        label.font = UIFont.systemFont(ofSize: 14.auto())
        return label
    }
}
