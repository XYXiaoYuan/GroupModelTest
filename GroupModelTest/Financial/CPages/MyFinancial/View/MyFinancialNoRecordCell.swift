//  
//  MyFinancialNoRecordCell.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - MyFinancialNoRecordCell
class MyFinancialNoRecordCell: UICollectionViewCell {
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        Asyncs.delay(0.01) { [weak self] in
            guard let `self` = self else { return }
            self.corner([.bottomLeft, .bottomRight], radii: 8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter and Setter
    private lazy var emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "financial_norecord")
        return iv
    }()

    private lazy var nodataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(13)
        label.textColor = 0xCCCCCC.uiColor
        label.text = "暂无记录".localized
        return label
    }()
}

// MARK: - Private Methods
private extension MyFinancialNoRecordCell {
    func setupUI() {
        [emptyImageView, nodataLabel].forEach { contentView.addSubview($0) }
        emptyImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(118)
            make.height.equalTo(80)
        }
        
        nodataLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emptyImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
