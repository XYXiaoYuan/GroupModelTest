//  
//  MyFinancialCurrentCell.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - MyFinancialCurrentCell
class MyFinancialCurrentCell: UICollectionViewCell {
    // MARK: - Properties
    public var productModel: MyFinancialProductListModel? {
        didSet {
            guard let model = productModel else { return }
            
            productNameLabel.text = model.productName
            
            depositAmountLabel.text = "存入数量:" + " " + model.depositAmount
            possessProfitLabel.text = "持有收益:" + " " + model.possessProfit
            yesterdayProfitLabel.text = "昨日收益:" + " " + model.yesterdayProfit
            benefitRateLabel.text = "收益利率:" + " " + model.benefitRate
        }
    }
    
    public func hideBottomLineView(isLast: Bool) {
        bottomLineView.isHidden = isLast
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
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
    
    private lazy var depositAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(13)
        label.textColor = 0x999999.uiColor
        label.text = "存入数量:".localized
        return label
    }()

    private lazy var possessProfitLabel: UILabel = {
        let label = UILabel()
        label.text = "持有收益:".localized
        label.font = UIFont.regular(13)
        label.textColor = 0x999999.uiColor
        return label
    }()
    
    private lazy var yesterdayProfitLabel: UILabel = {
        let label = UILabel()
        label.text = "昨日收益:".localized
        label.font = UIFont.regular(13)
        label.textColor = 0x999999.uiColor
        return label
    }()

    private lazy var benefitRateLabel: UILabel = {
        let label = UILabel()
        label.text = "收益利率:".localized
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
private extension MyFinancialCurrentCell {
    func setupUI() {
        [productNameLabel, depositAmountLabel, possessProfitLabel, yesterdayProfitLabel, benefitRateLabel, bottomLineView].forEach { contentView.addSubview($0) }
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(22)
        }
        
        depositAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.top.equalTo(productNameLabel.snp.bottom).offset(8)
        }
        
        possessProfitLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(180.auto())
            make.top.equalTo(depositAmountLabel.snp.top)
        }
        
        yesterdayProfitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.top.equalTo(depositAmountLabel.snp.bottom).offset(4)
        }
        
        benefitRateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(possessProfitLabel.snp.left)
            make.top.equalTo(yesterdayProfitLabel.snp.top)
        }
        
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalToSuperview().offset(-22)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
