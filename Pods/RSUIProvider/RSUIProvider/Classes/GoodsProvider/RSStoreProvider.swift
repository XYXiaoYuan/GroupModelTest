//
//  RSStoreProvider.swift
//  RSUIProvider
//
//  Created by 袁小荣 on 2020/7/19.
//

import Foundation
import UIKit
import RSBaseConfig
import RSExtension


public protocol RSStoreProvider {
    /// 店铺名称Label
    var storeNameLabelFactory: UILabel { get }
    /// 店铺向右箭头
    var storeArrowFactory: UIImageView { get }
}

public extension RSStoreProvider where Self: UIView {
    var storeNameLabelFactory: UILabel {
        let label = UILabel()
        label.text = "Apple自营专卖店"
        label.textColor = 0x999999.uiColor
        label.font = UIFont.systemFont(ofSize: 11.auto())
        return label
    }
    
    var storeArrowFactory: UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage.ff_named(named: "store_arrow_right")
        return imageView
    }
}
