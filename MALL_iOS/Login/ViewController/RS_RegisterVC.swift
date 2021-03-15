//
//  RS_RegisterVC.swift
//  MALL_iOS
//
//  Created by 李强会 on 2020/7/15.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit

class RS_RegisterVC: RS_VCWhiteStatusBar {
    
    lazy var vv_view: RS_LoginRegisterView = {
        let vv_v = RS_LoginRegisterView(isLogin: false, frame: self.view.bounds)
        view.addSubview(vv_v)
        return vv_v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ff_hiddenNav()
        vv_view.vv_actionBlock = { (tag) in
            switch tag {
            case 0: //注册
                break
            case 1: //查看协议
                break
            case 2: // 区号弹框
                break
            default:
                break
            }
        }
    }
    
}
