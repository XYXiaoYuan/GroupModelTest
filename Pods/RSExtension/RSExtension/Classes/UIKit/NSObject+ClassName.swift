//
//  NSObject+ClassName.swift
//  Pods-RSExtension_Example
//
//  Created by 李强会 on 2020/7/18.
//

import UIKit

extension NSObject {
    /// Returns the current object's class name
    public var ff_className: String {
        return NSStringFromClass(type(of: self))
    }
    
    /// Returns the current class name
    public class var ff_className: String {
        return String(describing: self)
    }
}
