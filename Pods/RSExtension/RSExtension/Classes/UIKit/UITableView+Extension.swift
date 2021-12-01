//
//  UITableView+Extension.swift
//  News
//
//  Created by chenhuan on 2018/3/6.
//  Copyright © 2018年 chenhuan. All rights reserved.
//

import Foundation
import UIKit

public protocol RegisterCellFromNib {}

public extension RegisterCellFromNib {
    
    static var identifier: String { return "\(self)" }
    
    static var nib: UINib? {
        
        let str = NSStringFromClass(self as! AnyClass)
        let curBundle = Bundle.init(for: self as! AnyClass)
        let boudleURL = curBundle.url(forResource: str.components(separatedBy: ".")[0], withExtension: "bundle")
        let resourceBundle = Bundle.init(url: boudleURL!)
        return UINib(nibName: "\(self)", bundle: resourceBundle)
    }
}

extension UITableView {
    /// 注册 cell 的方法
    public func as_registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellFromNib {

        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.identifier)
        }else {
            register(cell, forCellReuseIdentifier: T.identifier)
        }
    }
    
    /// 从缓存池池出队已经存在的 cell
    public func as_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

public protocol TableViewNoMoreFootProtocol {

    /// 获取没有更多内容试图
    ///
    /// - Returns: 通用的没有更多试图
    func getNoMoreFootView() -> UIView
}

extension TableViewNoMoreFootProtocol {

    public func getNoMoreFootView() -> UIView {
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 53))
        let label = UILabel.init(frame: CGRect(x: 0, y: 18, width: 0, height: 13))
        label.text = "没有更多内容了"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = 0x999999.uiColor
        label.sizeToFit()
        label.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - label.width/2, y: 18, width: label.width, height: 13)
        footView.addSubview(label)
        let lineView = UIView.init(frame: CGRect(x: label.x - 75, y: 24.5, width: 65, height: 1 / UIScreen.main.scale))
        lineView.backgroundColor = 0xd3d3d3.uiColor
        footView.addSubview(lineView)
        let lineView2 = UIView.init(frame: CGRect(x: label.x + label.width + 10, y: 24.5, width: 65, height: 1 / UIScreen.main.scale))
        lineView2.backgroundColor = 0xd3d3d3.uiColor
        footView.addSubview(lineView2)
        return footView
    }

}
