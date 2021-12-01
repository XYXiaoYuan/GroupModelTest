//
//  LiveCreateTypeReusableView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/4/13.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

extension LiveCreateTypeReusableView: LiveCreateUpdateTitle {
    public func updateTitle(_ title: String) {
        titleView.updateTitle(title)
    }
}

class LiveCreateTypeReusableView: UICollectionReusableView {
    // MARK: - Properties
    /// 切换是否带货的单选按钮触发的回调
    public var studioLiveTypeCallback: ((_ liveType: StudioLiveType) -> Void)?
    
    /// 普通直播/私密直播
    public private(set) var liveType: StudioLiveType = .common
        
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
    
    // MARK: - Getter
    private lazy var containerView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var titleView: LiveCreateStarView = {
        let v = LiveCreateStarView()
        v.updateTitle("直播类型".localized)
        return v
    }()
    
    private lazy var commonRadioButton: LiveCreateRadioButton = {
        let button = LiveCreateRadioButton()
        button.isSelected = true
        button.setTitle("普通直播".localized, for: .normal)
        button.addTarget(self, action: #selector(commonRadioButtonClick), for: .touchUpInside)
        return button
    }()
    
    public private(set) lazy var secretRadioButton: LiveCreateRadioButton = {
        let button = LiveCreateRadioButton()
        button.setTitle("私域直播".localized, for: .normal)
        button.addTarget(self, action: #selector(secretRadioButtonClick), for: .touchUpInside)
        return button
    }()
}

// MARK: - 事件处理
extension LiveCreateTypeReusableView {
    @objc private func commonRadioButtonClick() {
        if liveType == .common {
            return
        }
        liveType = .common
        
        commonRadioButton.isSelected = true
        secretRadioButton.isSelected = false
        studioLiveTypeCallback?(.common)
    }
    
    @objc private func secretRadioButtonClick() {
        if liveType == .secret {
            return
        }
        liveType = .secret
        
        commonRadioButton.isSelected = false
        secretRadioButton.isSelected = true
        studioLiveTypeCallback?(.secret)
    }
}

// MARK: - 设置UI
extension LiveCreateTypeReusableView {
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        [titleView, commonRadioButton, secretRadioButton].forEach { containerView.addSubview($0) }
        titleView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(66)
        }
        
        commonRadioButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.centerY.equalToSuperview()
        }
        secretRadioButton.snp.makeConstraints { (make) in
            make.left.equalTo(commonRadioButton.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
    }
}
