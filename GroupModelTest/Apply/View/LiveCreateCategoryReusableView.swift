//  
//  LiveCreateCategoryReusableView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

//extension LiveCreateCategoryReusableView: LiveCreateUpdateTitle {
//    public func updateTitle(_ title: String) {
//        cardView.titleView.updateTitle(title)
//    }
//}
//
//protocol LiveCreateCategoryReusableViewDelegate: NSObjectProtocol {
//    func firstCategoryChoose(current: LiveCategoryModel?)
//    func secondCategoryChoose(current: LiveCategoryModel?)
//}

class LiveCreateCategoryReusableView: UICollectionReusableView {
    // MARK: - Properties
    
    /// 选中的一级分类
//    public var firstCategory: LiveCategoryModel? {
//        didSet {
//            guard let model = firstCategory else { return }
//            firstCategoryButton.setTitle(model.name, for: .normal)
//        }
//    }
//    /// 选中的二级分类
//    public var secondCategory: LiveCategoryModel? {
//        didSet {
//            guard let model = secondCategory else { return }
//            secondCategoryButton.setTitle(model.name, for: .normal)
//        }
//    }
    /// 代理
//    public weak var delegate: LiveCreateCategoryReusableViewDelegate?
    
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

    private lazy var firstCategoryButton: UIButton = {
        let button = createRoundCornerButton(title: "一级分类".localized, selector: #selector(firstCategoryButtonClick))
        return button
    }()
    
    private lazy var secondCategoryButton: UIButton = {
        let button = createRoundCornerButton(title: "二级分类".localized, selector: #selector(secondCategoryButtonClick))
        return button
    }()
}

// MARK: - 快速创建一些控件
extension LiveCreateCategoryReusableView {
    private func createRoundCornerButton(title: String, selector: Selector) -> LiveCreateCategoryButton {
        let button = LiveCreateCategoryButton(frame: .zero)
        button.layer.borderWidth = 1
        button.layer.borderColor = 0xDFDFDF.cgColor
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.regular(14)
        button.setTitle(title, for: .normal)
        button.setTitleColor(0x333333.uiColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}

class LiveCreateCategoryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let arrowIv = UIImageView(image: UIImage(named: "live_category_arrowdown"))
        addSubview(arrowIv)
        arrowIv.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(12)
            make.height.equalTo(7)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension LiveCreateCategoryReusableView {
    func setupUI() {
        [cardView].forEach { addSubview($0) }
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let middleMargin: CGFloat = 10
        let categoryButtonWidth: CGFloat = (screenWidth - 2 * 26 - middleMargin) * 0.5
        let categoryButtonHeight: CGFloat = 40
        [firstCategoryButton, secondCategoryButton].forEach { bottomView.addSubview($0) }
        firstCategoryButton.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top)
            make.left.equalToSuperview()
            make.width.equalTo(categoryButtonWidth)
            make.height.equalTo(categoryButtonHeight)
        }
        
        secondCategoryButton.snp.makeConstraints { (make) in
            make.top.equalTo(firstCategoryButton.snp.top)
            make.left.equalTo(firstCategoryButton.snp.right).offset(middleMargin)
            make.width.equalTo(categoryButtonWidth)
            make.height.equalTo(categoryButtonHeight)
        }
    }
    
    @objc func firstCategoryButtonClick() {
//        delegate?.firstCategoryChoose(current: firstCategory)
    }
    
    @objc func secondCategoryButtonClick() {
//        delegate?.secondCategoryChoose(current: secondCategory)
    }
}
