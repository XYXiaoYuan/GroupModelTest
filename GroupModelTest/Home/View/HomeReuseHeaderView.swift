//
//  HomeReuseHeaderView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2020/8/1.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit

class HomeReuseHeaderView: UICollectionReusableView {
    public var headerTitle: String = "" {
        didSet {
            headerTitleLabel.text = headerTitle
        }
    }
    
    public var isNeedRightButton: Bool = false {
        didSet {
            moreButton.isHidden = !isNeedRightButton
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        [headerTitleLabel, moreButton].forEach { addSubview($0) }

        headerTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc private func moreButtonClick() {
        print("点击了更多")
    }
    
    // MARK: - Getter
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(20)
        label.textColor = 0x333333.uiColor
        label.text = "搜索历史"
        return label
    }()
    
    private lazy var moreButton: EnlargeEdgeButton = {
        let button = EnlargeEdgeButton(type: .custom)
        button.isHidden = true
        button.enlargeEdge = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        button.titleLabel?.font = UIFont.regular(12)
//        button.setTitle("更多".localized, for: .normal)
        button.setTitleColor(0x999999.uiColor, for: .normal)
        button.setImage(UIImage(named: "search_rub"), for: .normal)
        button.imageDirection(.right, spacing: 3)
        button.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        return button
    }()
}
