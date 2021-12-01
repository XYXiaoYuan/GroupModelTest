//
//  UIImage+Extension.swift
//  RSBaseConfig
//
//  Created by 袁小荣 on 2020/7/21.
//

import Foundation

final class RSBaseConfigDummy {}

public extension UIImage{
    static func base_named(named name: String) -> UIImage? {
        let curBundle = Bundle(for: RSBaseConfigDummy.self)
        let boudleURL = curBundle.url(forResource: "RSBaseConfig", withExtension: "bundle")
        let resourceBundle = Bundle(url: boudleURL!)
        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }
}
