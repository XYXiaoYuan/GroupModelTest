//
//  FinancialProfitReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation
import RSExtension
import RSBaseConfig

class FinancialProfitReusableView: UICollectionReusableView {
    public var financialModel: FinancialResultModel? {
        didSet {
            guard let model = financialModel else { return }
            
            yesterdayView.update(numebr: model.yesterdayProfit)
            possessView.update(numebr: model.possessProfit)
            totalView.update(numebr: "\(model.totalProfit)%")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        [yesterdayView, possessView, totalView].forEach { bgImageView.addSubview($0) }
        let welfareWidth: CGFloat = 100
        totalView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(welfareWidth)
        }

        yesterdayView.snp.makeConstraints { (make) in
            let width = (screenWidth - 20 - welfareWidth) * 0.5
            make.width.equalTo(width)
            make.left.top.bottom.equalToSuperview()
        }
        possessView.snp.makeConstraints { (make) in
            make.left.equalTo(yesterdayView.snp.right)
            make.top.bottom.width.equalTo(yesterdayView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter
    private lazy var bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "origin_section_bg")
        return iv
    }()
    
    private lazy var yesterdayView: FinancialProfitCardView = {
        let v = FinancialProfitCardView(frame: .zero, name: "昨日释放".localized, number: "0")
        return v
    }()
    
    private lazy var possessView: FinancialProfitCardView = {
        let v = FinancialProfitCardView(frame: .zero, name: "持有收益".localized, number: "0")
        return v
    }()
    
    private lazy var totalView: FinancialProfitCardView = {
        let v = FinancialProfitCardView(frame: .zero, name: "累计收益".localized, number: "0.07%")
//        v.valueLabel.textColor = 0xF53831.uiColor
        v.verticalLine.isHidden = true
        return v
    }()
}

class FinancialProfitCardView: UIView {
    
    public func update(numebr: String) {
        valueLabel.text = numebr
    }
    
    convenience init(frame: CGRect, name: String, number: String, unit: String = "USDT") {
        self.init(frame: frame)
        
        backgroundColor = .clear
        
        nameLabel.text = name + "\n" + "(\(unit))"
        valueLabel.text = number
                
        [nameLabel, valueLabel, verticalLine].forEach { addSubview($0) }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(3)
            make.right.equalTo(-3)
        }
        
        verticalLine.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-18)
            make.width.equalTo(0.5)
        }
    }
    
    // MARK: - Getter
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(12)
        label.textColor = 0x999999.uiColor
        label.textAlignment = .center
        label.text = "昨日福利".localized
        label.numberOfLines = 0
        return label
    }()
    
    internal lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.1
        label.font = UIFont.medium(16)
        label.textColor = 0x333333.uiColor
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
        
    internal lazy var verticalLine = UIView().then {
        $0.backgroundColor = 0xEFEFEF.uiColor
    }
    
}
