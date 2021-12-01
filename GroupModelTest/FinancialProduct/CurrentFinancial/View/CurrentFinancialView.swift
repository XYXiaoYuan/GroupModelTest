//  
//  CurrentFinancialView.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

// MARK: - <# Module Description #>
class CurrentFinancialView: UIView {
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter and Setter
//    private lazy var <#labelname#>: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.<#font#>
//        label.textColor = 0x<#hex#>.uiColor
//        label.text = "<#name#>"
//        return label
//    }()
    
//    private lazy var <#imageViewName#>: UIImageView = {
//        let iv = UIImageView()
//        return iv
//    }()
    
//    private lazy var <#buttonName#>: UIButton = {
//        let button = UIButton(type: .custom)
////        let button = EnlargeEdgeButton(type: .custom)
//        //        button.enlargeEdge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        button.backgroundColor = <#backgroundColor#>
//        button.titleLabel?.font = UIFont.regular(15)
//        button.setTitle("<#buttonTitle#>", for: .normal)
//        button.setTitleColor(0x<#hex#>.uiColor, for: .normal)
//        button.setImage(UIImage(named: <#imageName#>), for: .normal)
//        //    button.imageDirection(.right, spacing: 4)
//        button.addTarget(self, action: #selector(<#buttonAction#>), for: .touchUpInside)
//        return button
//    }()
}

// MARK: - Private Methods
private extension CurrentFinancialView {
    func setupUI() {
        [].forEach { addSubview($0) }

    }
}

// MARK: - Public Methods
extension CurrentFinancialView {
    
}

// MARK: - Objc Methods
@objc extension CurrentFinancialView {
    
}

// MARK: - <#Delegates#>
extension CurrentFinancialView {
    
}
