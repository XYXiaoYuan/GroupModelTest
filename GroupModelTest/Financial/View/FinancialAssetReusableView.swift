//  
//  FinancialAssetReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - FinancialAssetReusableView
class FinancialAssetReusableView: UICollectionReusableView {
    // MARK: - Properties
    public var financialModel: FinancialResultModel? {
        didSet {
            guard let model = financialModel else { return }
            
            currentWealthView.udpate(name: "活期理财资产".localized, abount: model.currentWealth)
            fixWealthView.udpate(name: "定期理财资产".localized, abount: model.fixWealth)
        }
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter and Setter
    private func topTitleL() -> UILabel {
        let label = UILabel()
        label.font = UIFont.medium(13)
        label.textColor = 0x222222.uiColor
        label.text = "理财资产".localized
        return label
    }
    
    private lazy var currentWealthView: FinancialAssetWealthView = {
        let v = FinancialAssetWealthView()
        return v
    }()
    
    private lazy var fixWealthView: FinancialAssetWealthView = {
        let v = FinancialAssetWealthView()
        return v
    }()
}

// MARK: - Private Methods
private extension FinancialAssetReusableView {
    func setupUI() {
        let topTitleLabel = topTitleL()
        [topTitleLabel, currentWealthView, fixWealthView].forEach { addSubview($0) }
        topTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        
        currentWealthView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        fixWealthView.snp.makeConstraints { (make) in
            make.top.equalTo(currentWealthView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

class FinancialAssetWealthView: UIView {
    
    public func udpate(name:String, abount: String) {
        topLabel.text = name
        aboutLabel.text = "≈ " + abount + " USDT"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [topLabel, aboutLabel].forEach { addSubview($0) }
        topLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        aboutLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter and Setter
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(14)
        label.textColor = 0x043FD6.uiColor
        label.text = "活期理财资产".localized
        return label
    }()
    
    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(17)
        label.textColor = 0x222222.uiColor
        label.text = "≈ 268426456839.20 USDT"
        return label
    }()
}
