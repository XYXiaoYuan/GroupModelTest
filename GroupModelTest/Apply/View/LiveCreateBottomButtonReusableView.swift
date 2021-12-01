//  
//  LiveCreateBottomButtonReusableView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

protocol LiveCreateBottomButtonReusableViewDelegate: NSObjectProtocol {
    func liveCreateButtonClickEvent()
    func liveProtocolButtonClickEvent()
}

class LiveCreateBottomButtonReusableView: UICollectionReusableView {
    // MARK: - Properties
    public var agreeButtonCallback: ((_ isSelected: Bool) -> Void)?
    
    public weak var delegate: LiveCreateBottomButtonReusableViewDelegate?
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Getter and Setter
    public private(set) lazy var agreeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isSelected = false
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.regular(12)
        button.setTitleColor(0x666666.uiColor, for: .normal)
        button.setTitle("我同意".localized, for: .normal)
        button.setImage(UIImage(named: "live_radio_normal"), for: .normal)
        button.setImage(UIImage(named: "live_radio_selected"), for: .selected)
        button.imageDirection(.left, spacing: 4)
        button.addTarget(self, action: #selector(agreeButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var protocolButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.regular(12)
        button.setTitle("《XXXX直播协议》".localized, for: .normal)
        button.setTitleColor(0xEA354B.uiColor, for: .normal)
        button.addTarget(self, action: #selector(protocolButtonClick), for: .touchUpInside)
        return button
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.backgroundColor = 0xEA354B.uiColor
        button.titleLabel?.font = UIFont.regular(15)
        button.setTitle("立即开通".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return button
    }()
}

// MARK: - Private Methods
private extension LiveCreateBottomButtonReusableView {
    func setupUI() {
        [agreeButton, protocolButton, submitButton].forEach { addSubview($0) }
        agreeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(6)
        }
        
        protocolButton.snp.makeConstraints { (make) in
            make.left.equalTo(agreeButton.snp.right).offset(4)
            make.centerY.equalTo(agreeButton.snp.centerY)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.top.equalTo(agreeButton.snp.bottom).offset(10)
            make.left.equalTo(agreeButton.snp.left)
            make.right.equalToSuperview().offset(-6)
            make.height.equalTo(44)
        }
    }
    
    @objc func agreeButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agreeButtonCallback?(sender.isSelected)
    }
    
    @objc func protocolButtonClick() {
        delegate?.liveProtocolButtonClickEvent()
    }
    
    @objc func submitButtonClick() {
        delegate?.liveCreateButtonClickEvent()
    }
}
