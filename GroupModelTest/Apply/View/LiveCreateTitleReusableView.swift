//  
//  LiveCreateTitleReusableView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

extension LiveCreateTitleReusableView: LiveCreateUpdateTitle {
    public func updateTitle(_ title: String) {
        cardView.titleView.updateTitle(title)
    }
}

class LiveCreateTitleReusableView: UICollectionReusableView {
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
    private lazy var cardView: LiveCreateCardView = {
        let v = LiveCreateCardView(frame: .zero, bottomView: bottomView)
        return v
    }()
    
    private lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.medium(15)
        textField.textColor = 0x222222.uiColor
        textField.placeholder = "请输入直播标题".localized
        return textField
    }()
    
    private lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = 0xEBEBEB.uiColor
        return v
    }()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.regular(12)
        label.textColor = 0x999999.uiColor
        label.text = "直播标题七个字以内".localized
        return label
    }()
}

// MARK: - Private Methods
private extension LiveCreateTitleReusableView {
    func setupUI() {
        [cardView].forEach { addSubview($0) }
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        [textField, lineView, tipLabel].forEach { bottomView.addSubview($0) }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top).offset(-6)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(33)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom)
            make.left.equalTo(textField.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(0.5)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(textField.snp.left)
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}
