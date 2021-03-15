//
//  HomeReuseFooterView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/1/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

class HomeReuseFooterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// 只是为了给footer一个高度为10的背景色
        backgroundColor = UIColor(red: 243, green: 243, blue: 243)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
