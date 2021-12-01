//  
//  LiveCreateStarView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

protocol LiveCreateUpdateTitle {
    func updateTitle(_ title: String)
}

extension LiveCreateStarView {
    public func updateTitle(_ title: String) {
        leftLabel.text = title
    }
}

// MARK: - 主播申请开播 必填项处理
class LiveCreateStarView: UIView {
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter and Setter
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(14)
        label.textColor = 0x333333.uiColor
        label.text = "直播标题".localized
        return label
    }()
    
    private lazy var starLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(14)
        label.textColor = 0xFB5650.uiColor
        label.text = "*"
        return label
    }()
}

// MARK: - Private Methods
private extension LiveCreateStarView {
    func setupUI() {
        [leftLabel, starLabel].forEach { addSubview($0) }
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(16)
        }
        
        starLabel.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.top).offset(-2)
            make.left.equalTo(leftLabel.snp.right).offset(2)
        }
    }
}
