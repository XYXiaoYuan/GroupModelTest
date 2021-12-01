//
//  RSGoodsImageProvider.swift
//  RSUIProvider_Example
//
//  Created by 袁小荣 on 2020/7/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RSBaseConfig
import RSExtension

public protocol RSGoodsImageProvider {
    /// 商品图片imageView
    var goodsImageViewFactory: UIImageView { get }
}

public extension RSGoodsImageProvider where Self: UIView {
    var goodsImageViewFactory: UIImageView {
        let imageView = UIImageView()
        return imageView
    }
}
