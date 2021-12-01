//  
//  LiveCreateCommerceReusableView.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit

extension StudioDeliveryType {
    var height: CGFloat {
        switch self {
        case .no:
            return 50
        case .yes:
            return 140
        }
    }
}

extension StudioProductType {
    var title: String {
        switch self {
        case .goods, .none:
            return "选择商品".localized
        case .shop:
            return "选择店铺".localized
        }
    }
}

class LiveCreateCommerceReusableView: UICollectionReusableView {
    // MARK: - Properties
    /// 切换是否带货的单选按钮触发的回调
    public var studioDeliveryTypeCallback: ((_ goodsType: StudioDeliveryType) -> Void)?
    /// 选择商品/选择店铺回调
    public var productChooseCallback: ((_ type: StudioProductType) -> Void)?
    
    /// 不带货OR带货
    public var goodsType: StudioDeliveryType = .no
    
    /// 选择带货的商品
//    public var selectedGoods: [LiveGoodsListModel] = []
    /// 选择带货的店铺
//    public var selectedShop: LiveShopListModel?
    
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
    private lazy var goodsView: StudioDeliveryTypeView = {
        let v = StudioDeliveryTypeView()
        v.radioButtonCallback = { [weak self] (type: StudioDeliveryType) in
            guard let `self` = self else { return }
            self.goodsType = type
            switch type {
            case .no:
                self.typeView.isHidden = true
                self.studioDeliveryTypeCallback?(.no)
            case .yes:
                self.typeView.isHidden = false
                self.studioDeliveryTypeCallback?(.yes)
            }
        }
        return v
    }()
    
    public private(set) lazy var typeView: StudioProductTypeView = {
        let v = StudioProductTypeView()
        v.isHidden = true
        v.commerceProductChooseCallback = { [weak self] (type: StudioProductType) in
            self?.productChooseCallback?(type)
        }
        return v
    }()
}

// MARK: - Public Methods
extension LiveCreateCommerceReusableView {
//    public func updateProductButtonTitle(selectedGoods: [LiveGoodsListModel], selectedShop: LiveShopListModel?) {
//        let type = typeView.type
//        switch type {
//        case .none:
//            typeView.chooseProductButton.setTitle(type.title, for: .normal)
//        case .goods:
//            guard !selectedGoods.isEmpty else {
//                typeView.chooseProductButton.setTitle(type.title, for: .normal)
//                return
//            }
//            
//            let title = StudioProductType.goods.title + " " + "\(selectedGoods.count)"
//            typeView.chooseProductButton.setTitle(title, for: .normal)
//        case .shop:
//            guard let shopModel = selectedShop else {
//                typeView.chooseProductButton.setTitle(type.title, for: .normal)
//                return
//            }
//            typeView.chooseProductButton.setTitle(shopModel.name, for: .normal)
//        }
//        
//        typeView.chooseProductButton.imageDirection(.right, spacing: 6)
//    }
}

// MARK: - Private Methods
private extension LiveCreateCommerceReusableView {
    func setupUI() {
        [goodsView, typeView].forEach { addSubview($0) }
        goodsView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        typeView.snp.makeConstraints { (make) in
            make.top.equalTo(goodsView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
    }
}

class LiveCreateRadioButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        titleLabel?.font = UIFont.regular(12)
        setTitleColor(0x222222.uiColor, for: .normal)
        setImage(UIImage(named: "live_radio_normal"), for: .normal)
        setImage(UIImage(named: "live_radio_selected"), for: .selected)
        imageDirection(.left, spacing: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
class StudioDeliveryTypeView: UIView {
    public var goodsType: StudioDeliveryType = .no
    
    /// 单选按钮的回调
    public var radioButtonCallback: ((_ goodType: StudioDeliveryType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        [titleView, noGoodsRadioButton, goodsRadioButton, lineView].forEach { containerView.addSubview($0) }
        titleView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(66)
        }
        
        noGoodsRadioButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.centerY.equalToSuperview()
        }
        goodsRadioButton.snp.makeConstraints { (make) in
            make.left.equalTo(noGoodsRadioButton.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(titleView.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 方法
    @objc private func noGoodsRadioButtonClick() {
        if goodsType == .no {
            return
        }
        goodsType = .no
        
        noGoodsRadioButton.isSelected = true
        goodsRadioButton.isSelected = false
        lineView.isHidden = true
        radioButtonCallback?(.no)
    }
    
    @objc private func goodsRadioButtonClick() {
        if goodsType == .yes {
            return
        }
        goodsType = .yes
        
        noGoodsRadioButton.isSelected = false
        goodsRadioButton.isSelected = true
        lineView.isHidden = false
        radioButtonCallback?(.yes)
    }
    
    // MARK: - Getter
    private lazy var containerView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var titleView: LiveCreateStarView = {
        let v = LiveCreateStarView()
        v.updateTitle("是否带货".localized)
        return v
    }()
    
    private lazy var noGoodsRadioButton: LiveCreateRadioButton = {
        let button = LiveCreateRadioButton()
        button.isSelected = true
        button.setTitle("不带货".localized, for: .normal)
        button.addTarget(self, action: #selector(noGoodsRadioButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var goodsRadioButton: LiveCreateRadioButton = {
        let button = LiveCreateRadioButton()
        button.setTitle("带货".localized, for: .normal)
        button.addTarget(self, action: #selector(goodsRadioButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = 0xEBEBEB.uiColor
        return v
    }()
}

class StudioProductTypeView: UIView {
    /// 带货类型
    public private(set) var type: StudioProductType = .goods
    /// 选择商品/选择店铺回调
    public var commerceProductChooseCallback: ((_ type: StudioProductType) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [containerView, chooseProductButton].forEach { addSubview($0) }
        containerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        chooseProductButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(containerView.snp.bottom).offset(2)
        }
        
        [titleView, goodsRadioButton, shopRadioButton].forEach { containerView.addSubview($0) }
        titleView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(66)
        }
        
        goodsRadioButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.centerY.equalToSuperview()
        }
        shopRadioButton.snp.makeConstraints { (make) in
            make.left.equalTo(goodsRadioButton.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 方法
    @objc private func goodsRadioButtonClick() {
        if type == .goods {
            return
        }
        type = .goods
        chooseProductButton.setTitle(type.title, for: .normal)

        goodsRadioButton.isSelected = true
        shopRadioButton.isSelected = false
    }
    
    @objc private func shopRadioButtonClick() {
        if type == .shop {
            return
        }
        type = .shop
        chooseProductButton.setTitle(type.title, for: .normal)

        goodsRadioButton.isSelected = false
        shopRadioButton.isSelected = true
    }
    
    @objc private func chooseProductButtonClick() {
        commerceProductChooseCallback?(type)
    }
    
    // MARK: - Getter
    private lazy var containerView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var titleView: LiveCreateStarView = {
        let v = LiveCreateStarView()
        v.updateTitle("带货类型".localized)
        return v
    }()
    
    private lazy var goodsRadioButton: LiveCreateRadioButton = {
        let button = LiveCreateRadioButton()
        button.isSelected = true
        button.setTitle("商品".localized, for: .normal)
        button.addTarget(self, action: #selector(goodsRadioButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var shopRadioButton: LiveCreateRadioButton = {
        let button = LiveCreateRadioButton()
        button.setTitle("店铺".localized, for: .normal)
        button.addTarget(self, action: #selector(shopRadioButtonClick), for: .touchUpInside)
        return button
    }()

    public private(set) lazy var chooseProductButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.regular(14)
        button.setTitle(type.title, for: .normal)
        button.setTitleColor(0x272828.uiColor, for: .normal)
        button.setImage(UIImage(named: "goods_arrow_right"), for: .normal)
        button.imageDirection(.right, spacing: 6)
        button.addTarget(self, action: #selector(chooseProductButtonClick), for: .touchUpInside)
        return button
    }()
}
