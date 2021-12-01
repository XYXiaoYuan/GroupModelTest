//  
//  FinancialDetailOperationItemReusableView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

protocol FinancialDetailOperationItemReusableViewDelegate: class {
    func buttonClick(with type: FinancialDetailOperationAction)
}

// MARK: - FinancialDetailOperationItemReusableView
class FinancialDetailOperationItemReusableView: UICollectionReusableView {
    /// 代理
    weak var delegate: FinancialDetailOperationItemReusableViewDelegate?

    // MARK: - Properties
    public var operationItems: [FinancialDetailOperationAction] = [] {
        didSet {
            subviews.forEach { $0.removeFromSuperview() }
            
            let margin: CGFloat = 9
            let totalWidth: CGFloat = screenWidth - 20 - CGFloat(operationItems.count - 1) * margin
            let width: CGFloat = totalWidth / CGFloat(operationItems.count)
            let y: CGFloat = 10
            let height: CGFloat = 40
            for (index, type) in operationItems.enumerated() {
                let button = GradientButton()
                button.tag = index
                button.layer.cornerRadius = 6
                button.layer.masksToBounds = true
                button.setBgGradientAll(type.gradientColor, for: [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.disabled, UIControl.State.selected])
                button.setTitle(type.title, for: .normal)
                button.setTitleColor(type.titleColor, for: .normal)
                button.titleLabel?.font = UIFont.medium(13)
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.titleLabel?.minimumScaleFactor = 0.1
                button.frame = CGRect(x: CGFloat(index) * (margin + width), y: y, width: width, height: height)
                button.addTarget(self, action: #selector(buttonCLick(_:)), for: .touchUpInside)
                addSubview(button)
            }
        }
    }
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonCLick(_ sender: UIButton) {
        let tag = sender.tag
        if !operationItems.isEmpty {
            let type = operationItems[tag]
            delegate?.buttonClick(with: type)
        }
    }
    
}
