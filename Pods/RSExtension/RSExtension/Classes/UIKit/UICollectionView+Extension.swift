//
//  UITableView+Extension.swift
//  News
//
//  Created by chenhuan on 2018/3/6.
//  Copyright © 2018年 chenhuan. All rights reserved.
//

import Foundation
import UIKit

public protocol RegisterCollectionCellFromNib {}

public extension RegisterCollectionCellFromNib {
    
    static var identifier: String { return "\(self)" }
    
    static var nib: UINib? {
        
        let str = NSStringFromClass(self as! AnyClass)
        let curBundle = Bundle.init(for: self as! AnyClass)
        let boudleURL = curBundle.url(forResource: str.components(separatedBy: ".")[0], withExtension: "bundle")
        let resourceBundle = Bundle.init(url: boudleURL!)
        return UINib(nibName: "\(self)", bundle: resourceBundle)
    }
}

extension UICollectionView {
    /// 注册 cell 的方法
    public func as_registerCell<T: UICollectionViewCell>(cell: T.Type) where T: RegisterCollectionCellFromNib {

        if let nib = T.nib {
            register(nib, forCellWithReuseIdentifier: T.identifier)
        }else {
            register(cell, forCellWithReuseIdentifier: T.identifier)
        }
    }
    
    /// 从缓存池池出队已经存在的 cell
    public func as_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RegisterCollectionCellFromNib {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
