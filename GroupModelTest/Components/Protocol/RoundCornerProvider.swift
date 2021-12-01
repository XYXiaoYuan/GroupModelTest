//
//  RoundCornerProvider.swift
//  RSWallet_Example
//
//  Created by 袁小荣 on 2020/7/23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RSBaseConfig
import RSExtension

public protocol RoundCornerProvider {
    /// 圆角Label
    var roundCornerViewFactory: UIView { get }
    
    var cornerRadius: CGFloat { get }
}

public extension RoundCornerProvider where Self: UIView {
    var cornerRadius: CGFloat {
        return 8
    }
    
    var roundCornerViewFactory: UIView {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = cornerRadius
        v.layer.masksToBounds = true
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 5)
        v.layer.shadowColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1).cgColor
        
        return v
    }
}
