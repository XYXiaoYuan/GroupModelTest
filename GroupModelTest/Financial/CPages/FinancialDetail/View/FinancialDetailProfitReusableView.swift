//  
//  FinancialDetailProfitReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - FinancialDetailProfitReusableView
class FinancialDetailProfitReusableView: UICollectionReusableView {
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
        label.text = "收益明细".localized
        return label
    }
}

// MARK: - Private Methods
private extension FinancialDetailProfitReusableView {
    func setupUI() {
        let topLabel = topTitleL()
        [topLabel].forEach { addSubview($0) }
        topLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(12)
        }
    }
}
