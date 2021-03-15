//
//  HomeNavigationCell.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2020/8/1.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit

class HistorySearchCell: UICollectionViewCell {
    public var historyModel: HistorySearchModel? {
        didSet {
            guard let model = historyModel else { return }

            itemButton.setTitle(model.name, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        contentView.backgroundColor = UIColor(red: 244, green: 246, blue: 246)
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true

        [itemButton].forEach { contentView.addSubview($0) }
        itemButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter
    private lazy var itemButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.regular(15)
        button.setTitleColor(0x66666.uiColor, for: .normal)
        button.setImage(UIImage(named: "goodsdetail_collect"), for: .normal)
            button.imageDirection(.left, spacing: 2)
        button.isEnabled = false
        button.adjustsImageWhenDisabled = false
        return button
    }()
    
}
