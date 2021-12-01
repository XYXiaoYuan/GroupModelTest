//
//  ReusableView+Reusable.swift
//  MCExtension
//
//  Created by sessionCh on 2019/8/17.
//

import UIKit

/// 可复用协议
public protocol Reusable: class {
    /// 复用的id
    static var identifier: String { get }
}

extension Reusable where Self: UIView {
    public static var identifier: String {
        return NSStringFromClass(self)
    }
}

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
extension UICollectionReusableView: Reusable {}

// 这个前提是 Storyboard 中设置的 Storyboard ID 与类名相同, 否则会 crash
extension UIViewController: Reusable {
    public static var identifier: String {
        let className = NSStringFromClass(self) as NSString
        return className.components(separatedBy: ".").last!
    }
}
