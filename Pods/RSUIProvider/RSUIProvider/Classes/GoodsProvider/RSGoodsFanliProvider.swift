//
//  RSGoodsFanliProvider.swift
//  RSUIProvider
//
//  Created by 袁小荣 on 2020/7/19.
//

import Foundation
import UIKit

public protocol RSGoodsFanliProvider {
    /// 全额返利图片imageView
    var fanliImageViewFactory: UIImageView { get }
    /// 返利label
    var fanliLabelFactory: UILabel { get }
}

public extension RSGoodsFanliProvider where Self: UIView {
    var fanliImageViewFactory: UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage.ff_named(named: "fanli_icon")
        return imageView
    }
    
    var fanliLabelFactory: UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "100%福利"
        label.textColor = UIColor.white
        label.font = UIFont.medium(8)
        return label
    }
}
