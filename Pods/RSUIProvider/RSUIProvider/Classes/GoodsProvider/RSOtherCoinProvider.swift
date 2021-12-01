//
//  RSOtherCoinProvider.swift
//  RSUIProvider
//
//  Created by 袁小荣 on 2020/7/19.
//

import Foundation

public protocol RSOtherCoinProvider {
    /// 其它货币(USDT)符号Label
    var otherCoinLabelFactory: UILabel { get }
}

public extension RSOtherCoinProvider where Self: UIView {
    var otherCoinLabelFactory: UILabel {
        let label = UILabel()
        label.text = "≈UT763.90"
        label.textColor = 0x999999.uiColor
        label.font = UIFont.systemFont(ofSize: 13.auto())
//        do {
//            let l = UILabel()
//            l.text = "≈"
//            l.textColor = label.textColor
//            l.font = label.font
//            l.frame = CGRect(x: 0, y: 0, width: 10, height: 18)
//            label.addSubview(l)
//        }
//        label.x = 10
        label.sizeToFit()
        return label
    }
}
