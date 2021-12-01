//  
//  FinancialTransactionDetailReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - FinancialTransactionDetailReusableView
class FinancialTransactionDetailReusableView: UICollectionReusableView {
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white

        setupUI()
        
        Asyncs.delay(0.01) { [weak self] in
            guard let `self` = self else { return }
            self.corner([.topLeft, .topRight], radii: 8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Getter and Setter
    private func topTitleL() -> UILabel {
        let label = UILabel()
        label.font = UIFont.medium(13)
        label.textColor = 0x222222.uiColor
        label.text = "交易明细".localized
        return label
    }
    
    private lazy var filterArrowButton: EnlargeEdgeButton = {
        let button = EnlargeEdgeButton(type: .custom)
        button.enlargeEdge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.titleLabel?.font = UIFont.regular(15)
        button.setTitle("时间筛选", for: .normal)
        button.setTitleColor(0x222222.uiColor, for: .normal)
        button.setImage(UIImage(named: "financial_detail_arrow"), for: .normal)
            button.imageDirection(.right, spacing: 4)
        button.addTarget(self, action: #selector(filterArrowButtonClick), for: .touchUpInside)
        return button
    }()
}

// MARK: - Private Methods
private extension FinancialTransactionDetailReusableView {
    func setupUI() {
        let topLabel = topTitleL()
        [topLabel, filterArrowButton].forEach { addSubview($0) }
        topLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(12)
        }
        
        filterArrowButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}

@objc extension FinancialTransactionDetailReusableView {
    private func filterArrowButtonClick() {
        print("点击了时间筛选")
    }
}
