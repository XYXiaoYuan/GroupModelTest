//  
//  MyFinancialFixCell.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - MyFinancialFixCell
class MyFinancialFixCell: UICollectionViewCell {
    // MARK: - Properties
    public var productModel: MyFinancialProductListModel? {
        didSet {
            guard let model = productModel else { return }
            
            productNameLabel.text = model.productName
            fixDurationLabel.text = model.fixDuration
            
            depositAmountLabel.text = "存入数量:" + " " + model.depositAmount
            possessProfitLabel.text = "持有收益:" + " " + model.possessProfit
            yesterdayProfitLabel.text = "昨日收益:" + " " + model.yesterdayProfit
            benefitRateLabel.text = "收益利率:" + " " + model.benefitRate
            
            dateLabel.text = "到期时间:" + " " + model.expiredData
        }
    }
    
    public func hideBottomLineView(isLast: Bool) {
        bottomLineView.isHidden = isLast
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
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
    
    private lazy var fixDurationView: GradientView = {
        let view = GradientView(starColor: 0x053AC2.uiColor, endColor: 0x2295ED.uiColor, direction: .horizontal(true))
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var fixDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.regular(12)
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

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(13)
        label.textColor = 0x333333.uiColor
        label.text = "到期时间：2021-04-27 12:12:12"
        return label
    }()

    private lazy var bottomLineView: UIView = {
        let v = UIView()
        v.backgroundColor = 0xE3E3E3.uiColor
        return v
    }()
}

// MARK: - Private Methods
private extension MyFinancialFixCell {
    func setupUI() {
        [productNameLabel, fixDurationView, fixDurationLabel, depositAmountLabel, possessProfitLabel, yesterdayProfitLabel, benefitRateLabel, dateLabel, bottomLineView].forEach { contentView.addSubview($0) }
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(22)
        }
        fixDurationView.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(22)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(productNameLabel.snp.centerY)
        }
        fixDurationView.addSubview(fixDurationLabel)
        fixDurationLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.top.equalTo(benefitRateLabel.snp.bottom).offset(6)
        }
        
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalToSuperview().offset(-22)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
