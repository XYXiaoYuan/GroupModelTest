//  
//  MyFinancialWealthReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - MyFinancialWealthReusableView
class MyFinancialWealthReusableView: UICollectionReusableView {
    // MARK: - Properties
    public var headerModel: MyFinancianHeaderModel? {
        didSet {
            guard let model = headerModel else { return }

            nameLabel.text = model.name
            detailLabel.text = model.detail
            bottomLeftLabel.text = model.bottomLeft
            bottomRightLabel.text = model.bottomRight
        }
    }
    
    public func hideBottomLabels(isNeedHidden: Bool) {
        bottomLeftLabel.isHidden = isNeedHidden
        bottomRightLabel.isHidden = isNeedHidden
    }
    
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
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(14)
        label.textColor = 0x333333.uiColor
        label.text = "我的活期理财"
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(13)
        label.textColor = 0x999999.uiColor
        label.text = "昨日收益/持有收益（折合USDT）"
        return label
    }()

    private lazy var bottomLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "名称/存入数量/昨日收益".localized
        label.font = UIFont.regular(12)
        label.textColor = 0x666666.uiColor
        return label
    }()
    
    private lazy var bottomRightLabel: UILabel = {
        let label = UILabel()
        label.text = "持有收益/收益利率".localized
        label.font = UIFont.regular(12)
        label.textColor = 0x666666.uiColor
        return label
    }()
}

// MARK: - Private Methods
private extension MyFinancialWealthReusableView {
    func setupUI() {
        [nameLabel, detailLabel, bottomLeftLabel, bottomRightLabel].forEach { addSubview($0) }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
        }

        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(2)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        bottomLeftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        bottomRightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomLeftLabel.snp.right).offset(18)
            make.centerY.equalTo(bottomLeftLabel.snp.centerY)
            make.right.lessThanOrEqualToSuperview().offset(-10)
        }
    }
}
