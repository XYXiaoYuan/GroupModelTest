//  
//  MyFinancialAssetReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - MyFinancialAssetReusableView
class MyFinancialAssetReusableView: UICollectionReusableView {
    // MARK: - Properties
    public var myFinancialModel: MyFinancialResultModel? {
        didSet {
            guard let model = myFinancialModel else { return }
            
            currentWealthView.udpate(name: "活期理财资产".localized, abount: model.currentWealth, items: model.currentItems)
            fixWealthView.udpate(name: "定期理财资产".localized, abount: model.fixWealth, items: model.fixItems)
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
    
    private lazy var currentWealthView: MyFinancialAssetWealthView = {
        let v = MyFinancialAssetWealthView()
        return v
    }()
    
    private lazy var middleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = 0xEDEDED.uiColor
        return view
    }()
    
    private lazy var fixWealthView: MyFinancialAssetWealthView = {
        let v = MyFinancialAssetWealthView()
        return v
    }()
}

// MARK: - Private Methods
private extension MyFinancialAssetReusableView {
    func setupUI() {
        let topTitleLabel = topTitleL()
        [topTitleLabel, currentWealthView, middleLineView, fixWealthView].forEach { addSubview($0) }
        topTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        
        currentWealthView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(174)
        }
        
        middleLineView.snp.makeConstraints { (make) in
            make.top.equalTo(currentWealthView.snp.bottom)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(0.5)
        }
        
        fixWealthView.snp.makeConstraints { (make) in
            make.top.equalTo(middleLineView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

class MyFinancialAssetWealthView: UIView {
    
    public func udpate(name:String, abount: String, items: [MyFinancialItemModel]) {
        topLabel.text = name
        aboutLabel.text = "≈ " + abount + " USDT"
        
        let totalRow: Int = 2
        for (index, item) in items.enumerated() {
            let row = index / totalRow
            let col = index % totalRow
            let x: CGFloat = 18 + CGFloat(col) * (itemWidth + 15)
            let y: CGFloat = 10 + CGFloat(row) * (itemHeight + 15)
            let frame: CGRect = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            
            let view = MyFinancialAssetWealthItemView(frame: frame)
            view.itemModel = item
            bottomView.addSubview(view)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [topLabel, aboutLabel, bottomView].forEach { addSubview($0) }
        topLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        aboutLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.left.right.bottom.equalToSuperview()
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
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var itemWidth: CGFloat {
        return (screenWidth - 2 * 28) * 0.5
    }
    
    private var itemHeight: CGFloat {
        return 40
    }
}

class MyFinancialAssetWealthItemView: UIView {
    public var itemModel: MyFinancialItemModel? {
        didSet {
            guard let model = itemModel else { return }

//            imageView.kf.setImage(with: URL(string: model.icon), placeholder: UIImage(named: "default_coin"))

            nameLabel.text = model.iconName
            aboutLabel.text = "≈" + model.aboutProfits + " " + model.iconName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [imageView, nameLabel, aboutLabel].forEach { addSubview($0) }
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(6)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        
        aboutLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.left)
            make.top.equalTo(imageView.snp.bottom).offset(6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter and Setter
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .random
        iv.layer.cornerRadius = 9
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(15)
        label.textColor = 0x333333.uiColor
        label.text = "USDT"
        return label
    }()
    
    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular(15)
        label.textColor = 0x999999.uiColor
        label.text = "≈32684.20 USDT"
        return label
    }()
}
