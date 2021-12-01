//  
//  FinancialDetailProfitCell.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - FinancialDetailProfitCell
class FinancialDetailProfitCell: UICollectionViewCell {
    // MARK: - Properties
    public var detailModel: FinancialDetailProfitDetailModel? {
        didSet {
            guard let model = detailModel else { return }

            timeLabel.text = model.time
            productNameLabel.text = model.productName
            profitLabel.text = model.profit + " " + "USDT"
        }
    }
    
    public func hideBottomLineView(isLast: Bool) {
        bottomLineView.isHidden = isLast
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter and Setter
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(15)
        label.textColor = 0x333333.uiColor
        label.text = "2021-01-28"
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "定期理财收益".localized
        label.font = UIFont.regular(13)
        label.textColor = 0x999999.uiColor
        return label
    }()

    private lazy var profitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(16)
        label.textColor = 0x222222.uiColor
        label.text = "0.25"
        return label
    }()

    private lazy var bottomLineView: UIView = {
        let v = UIView()
        v.backgroundColor = 0xE3E3E3.uiColor
        return v
    }()
}

// MARK: - Private Methods
private extension FinancialDetailProfitCell {
    func setupUI() {
        [timeLabel, productNameLabel, profitLabel, bottomLineView].forEach { contentView.addSubview($0) }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(10)
        }
        
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.left)
            make.top.equalTo(timeLabel.snp.bottom).offset(6)
        }
        
        profitLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.left)
            make.right.equalTo(profitLabel.snp.right)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}

