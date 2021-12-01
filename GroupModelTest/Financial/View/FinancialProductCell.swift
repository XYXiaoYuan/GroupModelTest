//  
//  FinancialProductCell.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - FinancialProductCell
class FinancialProductCell: UICollectionViewCell {
    // MARK: - Properties
    public var productModel: FinancialProductListModel? {
        didSet {
            guard let model = productModel else { return }
            
            productNameLabel.text = model.productName
            profitOf7dayLabel.text = model.profitOf7day
            
            totalProfitLabel.text = "总累计收益: ".localized + model.totalProfit + " USDT"
            possessNumberLabel.text = model.possessNumber + "人持有".localized
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
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(14)
        label.textColor = 0x333333.uiColor
        label.text = "活期理财- 随存随取 - FIL"
        return label
    }()
    
    private lazy var profitOf7dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(13)
        label.textColor = 0xF53831.uiColor
        label.text = "12%"
        return label
    }()

    private lazy var profitOf7dayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "七日年化".localized
        label.font = UIFont.regular(13)
        label.textColor = 0x999999.uiColor
        return label
    }()

    private lazy var totalProfitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(13)
        label.textColor = 0x999999.uiColor
        return label
    }()

    private lazy var possessNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(13)
        label.textColor = 0x999999.uiColor
        return label
    }()
    
    private lazy var bottomLineView: UIView = {
        let v = UIView()
        v.backgroundColor = 0xE3E3E3.uiColor
        return v
    }()
}

// MARK: - Private Methods
private extension FinancialProductCell {
    func setupUI() {
        [productNameLabel, profitOf7dayLabel, profitOf7dayNameLabel, totalProfitLabel, possessNumberLabel, bottomLineView].forEach { contentView.addSubview($0) }
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(22)
        }
        
        profitOf7dayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.top.equalTo(productNameLabel.snp.bottom).offset(8)
        }
        profitOf7dayNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.top.equalTo(profitOf7dayLabel.snp.bottom).offset(4)
        }
        
        possessNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profitOf7dayNameLabel.snp.right).offset(45)
            make.top.equalTo(profitOf7dayNameLabel.snp.top)
        }

        totalProfitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(possessNumberLabel.snp.left)
            make.top.equalTo(profitOf7dayLabel.snp.top)
        }
        
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalToSuperview().offset(-22)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
