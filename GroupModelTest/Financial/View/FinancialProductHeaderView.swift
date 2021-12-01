//  
//  FinancialProductHeaderView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - FinancialProductHeaderView
class FinancialProductHeaderView: UICollectionReusableView {
    /// 切换回调
    public var switchFinancianType: ((_ type: FinancialType) -> Void)?
    
    /// 当前理财方式
    private var type: FinancialType = .current

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
    private lazy var currentButton: FinancialGradientButton = {
        let button = FinancialGradientButton(type: .custom)
        button.isSelected = true
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.setBgGradientAll()
        button.titleLabel?.font = UIFont.regular(15)
        button.setTitle("活期理财".localized, for: .normal)
        button.addTarget(self, action: #selector(currentButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var fixButton: FinancialGradientButton = {
        let button = FinancialGradientButton(type: .custom)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        let gradient: GradientProvide = Gradient(starColor: 0xECF2F7.uiColor, endColor: 0xECF2F7.uiColor, direction: .horizontal(false))
        let allStates = [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.disabled, UIControl.State.selected]
        button.setBgGradientAll(gradient, for: allStates)
        button.titleLabel?.font = UIFont.regular(15)
        button.setTitle("定期理财".localized, for: .normal)
        button.addTarget(self, action: #selector(fixButtonClick), for: .touchUpInside)
        return button
    }()
}

// MARK: - Private Methods
private extension FinancialProductHeaderView {
    func setupUI() {
        [currentButton, fixButton].forEach { addSubview($0) }
        let width: CGFloat = 120.auto()
        let margins: CGFloat = 20.auto()
        let offset = (width + margins) * 0.5
        currentButton.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(36)
            make.top.equalToSuperview().offset(22)
            make.centerX.equalToSuperview().offset(-offset)
        }
        
        fixButton.snp.makeConstraints { (make) in
            make.width.height.top.equalTo(currentButton)
            make.centerX.equalToSuperview().offset(offset)
        }
    }
}

// MARK: - Objc Methods
@objc extension FinancialProductHeaderView {
    @objc private func currentButtonClick() {
        type = .current
        
        switchFinancianType?(type)

        if !currentButton.isSelected {
            setButtonState()
        }
    }
    
    @objc private func fixButtonClick() {
        type = .fix
        
        switchFinancianType?(type)
        
        if !fixButton.isSelected {
            setButtonState()
        }
    }
    
    private func setButtonState() {
        currentButton.isSelected = !currentButton.isSelected
        fixButton.isSelected = !fixButton.isSelected
    }
}

fileprivate class FinancialGradientButton: GradientButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setBgGradientAll()
            } else {
                let gradient: GradientProvide = Gradient(starColor: 0xECF2F7.uiColor, endColor: 0xECF2F7.uiColor, direction: .horizontal(false))
                let allStates = [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.disabled, UIControl.State.selected]
                setBgGradientAll(gradient, for: allStates)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .selected)
        setTitleColor(0x333333.uiColor, for: .normal)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
