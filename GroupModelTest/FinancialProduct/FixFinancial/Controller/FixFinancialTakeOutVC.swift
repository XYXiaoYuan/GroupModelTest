//  
//  FixFinancialTakeOutVC.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit
import BaseViewController

// MARK: - FixFinancialTakeOutVC
class FixFinancialTakeOutVC: BaseViewController {
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置UI
        setupUI()
        
        /// 加载数据
        loadData()
    }

    override func setupNavi() {
        super.setupNavi()
        view.backgroundColor = 0xF9F9F9.uiColor
        navi_topView.backgroundColor = UIColor.white
        

        title = "活期取出"
    }
    
    // MARK: - Getter and Setter

}

// MARK: - Private Methods
private extension FixFinancialTakeOutVC {
    func setupUI() {
        
    }
    
    func loadData() {
        
    }
}

// MARK: - Public Methods
extension FixFinancialTakeOutVC {
    
}

// MARK: - Objc Methods
@objc extension FixFinancialTakeOutVC {
    
}

// MARK: - <#Delegates#>
extension FixFinancialTakeOutVC {
    
}
