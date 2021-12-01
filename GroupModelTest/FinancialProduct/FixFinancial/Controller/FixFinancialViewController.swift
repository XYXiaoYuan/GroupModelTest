//  
//  FixFinancialViewController.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit
import RSBaseConfig
import RSExtension
import BaseViewController

// MARK: - <# Module Description #>
class FixFinancialViewController: BaseViewController {
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置UI
        setupUI()
        
        /// 加载数据
        loadData()
    }

    override func setupNavi() {
        super.setupNavi()
        view.backgroundColor = 0xF9F9F9.uiColor
        navi_topView.backgroundColor = UIColor.white
        
        title = "产品详情".localized
        rightItem = BarButtonItem(title: "我的理财".localized, config: { (barButton) in
            barButton.setTitleColor(0x222222.uiColor, for: .normal)
            barButton.titleLabel?.font = UIFont.regular(16)
        }) { [weak self] (_) in
            guard let `self` = self else { return }
            let vc = MyFinancialViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Getter and Setter
    
    internal lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
    
//    /// 头部View
//    private lazy var headerView: CurrentFinancialHeaderCardView = {
//        let headerView = CurrentFinancialHeaderCardView(frame: .zero, titleText:"定期理财- 稳定高收益 - FIL".localized, detailText:"“闲钱理财利器，专家团队全市场严选理财，力争提供更优的收益体验。严格风控，在此基础上适当提高优质收益比例，增厚组合收益”。".localized)
//        return headerView
//    }()
//    
//    /// 简介View
//    private lazy var introductionView: FixFinancialSummaryCardView = {
//        let introductionView = FixFinancialSummaryCardView(frame: .zero, tsevenDayValueText: "60%～120%", productPeriodValueText: "30天/90天/180天/365天", totalValueText: "39829389 USDT", peopleHoldValueText: "239832")
//        return introductionView
//    }()
//    
//    /// 产品亮点View
//    private lazy var productHighlightsView: FixFinancalProductHighlightsCardView = {
//        let productHighlightsView = FixFinancalProductHighlightsCardView(frame: .zero)
//        return productHighlightsView
//    }()
//    
//    /// 交易规则View
//    private lazy var tradingRulesView: TradingRulesCardView = {
//        let tradingRulesView = TradingRulesCardView(frame: .zero)
//        tradingRulesView.ruleInfoList = ["存入".localized, "次日凌晨开始计算收益".localized, "随存随取".localized]
//        return tradingRulesView
//    }()
    
    /// 立即购买
    private lazy var buyNowButton: GradientButton = {
        let button = GradientButton(type: .custom)
        button.isSelected = true
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setBgGradientAll()
        button.titleLabel?.font = UIFont.regular(15)
        button.setTitle("立即购买".localized, for: .normal)
        button.addTarget(self, action: #selector(buyNowButtonClick), for: .touchUpInside)
        return button
    }()
    
}

// MARK: - Private Methods
private extension FixFinancialViewController {
    func setupUI() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navbarMaxY)
            make.left.right.bottom.equalToSuperview()
        }
        
        let height: CGFloat = 900
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height))
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize.init(width: screenWidth, height: height)
        
//        [headerView, introductionView, productHighlightsView, tradingRulesView, buyNowButton].forEach { contentView.addSubview($0) }
//        headerView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(10)
//            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
//            make.height.equalTo(106)
//        }
//
//        introductionView.snp.makeConstraints { (make) in
//            make.top.equalTo(headerView.snp.bottom).offset(10)
//            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
//            make.height.equalTo(163)
//        }
//
//        productHighlightsView.snp.makeConstraints { (make) in
//            make.top.equalTo(introductionView.snp.bottom).offset(10)
//            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
//            make.height.equalTo(350)
//        }
//
//        tradingRulesView.snp.makeConstraints { (make) in
//            make.top.equalTo(productHighlightsView.snp.bottom).offset(10)
//            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
//            make.height.equalTo(130)
//        }
//
//        buyNowButton.snp.makeConstraints { (make) in
//            make.top.equalTo(tradingRulesView.snp.bottom).offset(20)
//            make.left.equalToSuperview().offset(15)
//            make.right.equalToSuperview().offset(-15)
//            make.height.equalTo(44)
//        }
    }
    
    func loadData() {
        
    }
}

// MARK: - Public Methods
extension FixFinancialViewController {
    
}

// MARK: - Objc Methods
@objc extension FixFinancialViewController {
    @objc private func buyNowButtonClick() {
//        let vc = BuyInFinancialVC()
//        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - <#Delegates#>
extension FixFinancialViewController {
    
}

