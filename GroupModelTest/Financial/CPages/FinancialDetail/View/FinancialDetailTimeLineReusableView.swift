//  
//  FinancialDetailTimeLineReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: -  FinancialDetailTimeLineReusableView
class FinancialDetailTimeLineReusableView: UICollectionReusableView {
    // MARK: - Properties
    public var timeModel: FinancialFixTimeModel? {
        didSet {
            guard let model = timeModel else { return }

            beginTimeLabel.text = "存入时间:" + " " + model.beginTime
            endTimeLabel.text = "到期时间:" + " " + model.beginTime
        }
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
    private lazy var tickImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "financial_time_tick")
        return iv
    }()

    private lazy var beginTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(12)
        label.textColor = 0x999999.uiColor
        label.text = "存入时间：2021-01-27"
        return label
    }()

    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(12)
        label.textColor = 0x999999.uiColor
        label.text = "到期时间：2021-01-27"
        return label
    }()
}

// MARK: - Private Methods
private extension FinancialDetailTimeLineReusableView {
    func setupUI() {
        [tickImageView, beginTimeLabel, endTimeLabel].forEach { addSubview($0) }
        tickImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
        }
        
        beginTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tickImageView.snp.bottom).offset(5)
            make.left.equalTo(tickImageView.snp.left)
        }
        endTimeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalTo(beginTimeLabel.snp.centerY)
        }
    }
}
