//
//  MyFinancialWealthFooterView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

class MyFinancialWealthFooterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// 只是为了给footer一个高度为10的背景色
        backgroundColor = 0xF3F4F8.uiColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
