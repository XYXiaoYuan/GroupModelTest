//  
//  LiveCreateCardView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/27.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - 直播申请卡片View
class LiveCreateCardView: UIView {
    // MARK: - Properties
    var bottomView: UIView?
    
    convenience init(frame: CGRect, bottomView: UIView) {
        self.init(frame: frame)
        self.bottomView = bottomView
        
        setupUI()
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter and Setter
    internal lazy var titleView: LiveCreateStarView = {
        let v = LiveCreateStarView()
        return v
    }()
}

// MARK: - Private Methods
private extension LiveCreateCardView {
    func setupUI() {
        [titleView].forEach { addSubview($0) }
        titleView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(49)
        }
        
        guard let bottomView = bottomView else { return }
        addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.bottom.equalToSuperview()
        }
    }
}
