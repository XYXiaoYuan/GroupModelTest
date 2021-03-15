//  
//  TodayHotSearchCell.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/1/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - TodayHotSearchCell
class TodayHotSearchCell: UICollectionViewCell {
    // MARK: - Properties
    public var historyModel: HistorySearchModel? {
        didSet {
            guard let model = historyModel else { return }

            nameLabel.text = model.name
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        [nameLabel].forEach { contentView.addSubview($0) }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(12)
        label.textColor = 0x666666.uiColor
        label.text = "手机"
        label.textAlignment = .left
        return label
    }()
}
