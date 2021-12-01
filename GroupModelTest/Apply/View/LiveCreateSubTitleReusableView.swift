//  
//  LiveCreateSubTitleReusableView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

extension LiveCreateSubTitleReusableView: LiveCreateUpdateTitle {
    public func updateTitle(_ title: String) {
        cardView.titleView.updateTitle(title)
    }
}

class LiveCreateSubTitleReusableView: UICollectionReusableView {
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
        textField.placeholder = "请输入直播副标题".localized
        return textField
    }()
}

// MARK: - Private Methods
private extension LiveCreateSubTitleReusableView {
    func setupUI() {
        [cardView].forEach { addSubview($0) }
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        [textField].forEach { bottomView.addSubview($0) }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top).offset(-6)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(33)
        }

    }
}
