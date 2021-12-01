//  
//  FinancialDetailHeaderReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - FinancialDetailHeaderReusableView
class FinancialDetailHeaderReusableView: UICollectionReusableView {
    public var detailArrowButtonCallback: (() -> Void)?
    
    // MARK: - Properties
    public var financialDetail: FinancialResultModel? {
        didSet {
            guard let model = financialDetail else { return }

            productNameLabel.text = model.productName
            totalLabel.text = model.totalProfit
            
            yesterdayView.update(numebr: model.yesterdayProfit)
            possessView.update(numebr: model.possessProfit)
            totalView.update(numebr: "\(model.totalProfit)%")
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
    private lazy var topView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(13)
        label.textColor = 0x222222.uiColor
        label.text = "定期理财- 稳健收益 - BTC"
        return label
    }()
    
    private lazy var detailArrowButton: EnlargeEdgeButton = {
        let button = EnlargeEdgeButton(type: .custom)
        button.enlargeEdge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.titleLabel?.font = UIFont.regular(15)
        button.setTitle("详情", for: .normal)
        button.setTitleColor(0x222222.uiColor, for: .normal)
        button.setImage(UIImage(named: "financial_detail_arrow"), for: .normal)
            button.imageDirection(.right, spacing: 4)
        button.addTarget(self, action: #selector(detailArrowButtonClick), for: .touchUpInside)
        return button
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = 0xEDEDED.uiColor
        return view
    }()

    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.medium(34)
        label.textColor = 0xF53831.uiColor
        label.text = "2548215588.25"
        return label
    }()
    
    private lazy var detailNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(15)
        label.textColor = 0x999999.uiColor
        label.text = "活期资产（BTC）"
        return label
    }()
    
    private lazy var yesterdayView: FinancialDetailCardView = {
       let v = FinancialDetailCardView(frame: .zero, name: "昨日释放".localized, number: "0")
       return v
   }()

   private lazy var possessView: FinancialDetailCardView = {
       let v = FinancialDetailCardView(frame: .zero, name: "持有收益".localized, number: "0")
       return v
   }()

   private lazy var totalView: FinancialDetailCardView = {
       let v = FinancialDetailCardView(frame: .zero, name: "累计收益".localized, number: "0.07%")
   //        v.valueLabel.textColor = 0xF53831.uiColor
       v.verticalLine.isHidden = true
       return v
   }()
}

@objc extension FinancialDetailHeaderReusableView {
    private func detailArrowButtonClick() {
        detailArrowButtonCallback?()
    }
}

// MARK: - Private Methods
private extension FinancialDetailHeaderReusableView {
    func setupUI() {
        [topView, totalLabel, detailNameLabel, totalView, yesterdayView, possessView].forEach { addSubview($0) }
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        
        detailNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(totalLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        let bottomWidth: CGFloat = (screenWidth - 20) / 3
        totalView.snp.makeConstraints { (make) in
            make.top.equalTo(detailNameLabel.snp.bottom).offset(15)
            make.right.equalToSuperview()
            make.width.equalTo(bottomWidth)
            make.height.equalTo(120)
        }

        yesterdayView.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(totalView)
            make.left.equalToSuperview()
        }
        possessView.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(totalView)
            make.centerX.equalToSuperview()
        }
        
        [productNameLabel, detailArrowButton, lineView].forEach { topView.addSubview($0) }
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        detailArrowButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel.snp.left)
            make.right.equalTo(detailArrowButton.snp.right)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}


class FinancialDetailCardView: UIView {
    
    public func update(numebr: String) {
        valueLabel.text =  "+" + numebr
    }
    
    convenience init(frame: CGRect, name: String, number: String, unit: String = "USDT") {
        self.init(frame: frame)
        
        backgroundColor = .clear
        
        nameLabel.text = name + "\n" + "(\(unit))"
        valueLabel.text = number
        
        [nameLabel, valueLabel, verticalLine].forEach { addSubview($0) }
        
        valueLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(valueLabel.snp.bottom).offset(4)
        }
        
        verticalLine.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-18)
            make.width.equalTo(0.5)
        }
    }
    
    // MARK: - Getter
    internal lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.1
        label.font = UIFont.medium(16)
        label.textColor = 0x333333.uiColor
        label.textAlignment = .center
        label.text = "0"
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(12)
        label.textColor = 0x999999.uiColor
        label.textAlignment = .center
        label.text = "昨日福利".localized
        label.numberOfLines = 0
        return label
    }()
    
    internal lazy var verticalLine = UIView().then {
        $0.backgroundColor = 0xEFEFEF.uiColor
    }
}
