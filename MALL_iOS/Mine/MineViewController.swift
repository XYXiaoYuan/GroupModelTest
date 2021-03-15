//
//  MineViewController.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2020/7/19.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit
import BaseViewController
import RSBaseConfig
import RSExtension

class MineViewController: BaseViewController {
    
    private lazy var loginButton = UIButton(type: .custom).then {
        $0.setTitle("点我去登录", for: .normal)
        $0.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        title = "我的"
        
        /// 左边
        leftItem = BarButtonItem(title: "订单") { [weak self] (_) in
            guard let `self` = self else { return  }
            self.orderButtonClick()
        }
        
        /// 右边
        rightItem = BarButtonItem(title: "登录") { [weak self] (_) in
            guard let `self` = self else { return  }
            self.loginButtonClick()
        }
    }
}

// MARK: - 私有方法
private extension MineViewController {
    @objc func loginButtonClick() {
        let loginVc = LoginViewController()
        loginVc.modalPresentationStyle = .fullScreen
        present(loginVc, animated: true, completion: nil)
    }
    
    @objc func orderButtonClick() {
        let orderVc = OrderTabSegmentVC()
        navigationController?.pushViewController(orderVc, animated: true)
    }
}
