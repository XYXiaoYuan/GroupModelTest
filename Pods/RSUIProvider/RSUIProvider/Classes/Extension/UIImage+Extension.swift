//
//  UIImage+Extension.swift
//  RSUIProvider
//
//  Created by 袁小荣 on 2020/7/19.
//

import Foundation

final class Dummy {}

extension UIImage{
    static func ff_named(named name: String) -> UIImage? {
        let curBundle = Bundle(for: Dummy.self)
        let boudleURL = curBundle.url(forResource: "RSUIProvider", withExtension: "bundle")
        let resourceBundle = Bundle(url: boudleURL!)
        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }
}
