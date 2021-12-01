//
//  RSShopcarProvider.swift
//  RSUIProvider
//
//  Created by 袁小荣 on 2020/7/19.
//

import Foundation
import UIKit

public protocol RSShopcarProvider: NSObjectProtocol {
    /// 购物车按钮
    var shopcarButtonFactory: UIButton { get }
}

public extension RSShopcarProvider where Self: UIView {
    var shopcarButtonFactory: UIButton {
        let button = UIButton(type: .custom)
        let image = UIImage.ff_named(named: "shopcar_icon")
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        return button
    }
}
