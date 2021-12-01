//
//  CommonAlertView.swift
//  AlertViewComponent
//
//  Created by 袁小荣 on 2020/7/19.
//  弹出在中间的的基类弹窗视图

import UIKit
import SnapKit
import RSBaseConfig
import RSExtension

public class CommonAlertView: UIView {
    public typealias AlertAction = (() -> Void)
    private var desc: String?
    private var leftTitle: String?
    private var rightTitle: String?
    private var leftClickAction: AlertAction?
    private var rightClickAction: AlertAction?
    
    /// 便利初始化构造器
    public convenience init(frame: CGRect = .zero, desc: String?, leftTitle: String? = "取消", rightTitle: String? = "确定", leftAction: AlertAction? = nil, rightAction: AlertAction? = nil) {
        self.init(frame: frame)
                
        self.desc = desc
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.leftClickAction = leftAction
        self.rightClickAction = rightAction
        
        /// 设置UI
        if let desc = desc {
            setupUI(desc: desc)
        } else {
            setupUI(desc: "-----------------------------------")
        }
    }
    
    /// 设置描述文字对齐方式
    public func setupDescTextAlignment(_ textAlignment: NSTextAlignment) {
        descLabel.textAlignment = textAlignment
    }
    
    /// 设置描述文字大小
    public func setupDescTextFont(_ font: UIFont) {
        descLabel.font = font
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    private func setupUI(desc: String) {
        [topView, horizontalLine, verticalLine].forEach { addSubview($0) }
        
        let maxWidth: CGFloat = alertWidth - 2 * 10
        let size = desc.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: descLabel.font], context: nil).size
                
        let topAndBottomHeight: CGFloat = 35 * 2
        let topViewHeight = size.height + topAndBottomHeight
        [topView].forEach { addSubview($0) }
        topView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(radius)
            make.right.equalToSuperview().offset(-radius)
            make.top.equalToSuperview()
            make.height.equalTo(topViewHeight)
        }
        
        alertHeight = topViewHeight + 48

        horizontalLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(0.5)
        }
        
        verticalLine.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalLine.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(0.5)
        }
        
        topView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerX.centerY.equalToSuperview()
        }
                
        [leftButton, rightButton].forEach { addSubview($0) }
        leftButton.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(horizontalLine.snp.bottom)
            make.right.equalTo(verticalLine.snp.left)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(leftButton.snp.top)
            make.left.equalTo(verticalLine.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Getter
    private lazy var topView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private lazy var descLabel = UILabel().then {
        $0.textColor = 0x14191F.uiColor
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.text = desc
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var horizontalLine = UIView().then {
        $0.backgroundColor = 0xEFEFEF.uiColor
    }
    
    private lazy var verticalLine = UIView().then {
        $0.backgroundColor = 0xEFEFEF.uiColor
    }
    
    private lazy var leftButton = UIButton(type: .custom).then {
        $0.setTitle(leftTitle, for: .normal)
        $0.setTitleColor(0x929AA4.uiColor, for: .normal)
        $0.setTitleColor(0x929AA4.uiColor, for: .highlighted)
        $0.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
    }
    
    private lazy var rightButton = UIButton(type: .custom).then {
        $0.setTitle(rightTitle, for: .normal)
        $0.setTitleColor(0x0091FF.uiColor, for: .normal)
        $0.setTitleColor(0x0091FF.uiColor, for: .highlighted)
        $0.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
    }
    
    private var radius: CGFloat {
        return 6.0
    }
    
    /// 弹框宽度
    private var alertWidth: CGFloat {
        return screenWidth - 2 * 42
    }
    
    /// 弹框高度
    private lazy var alertHeight: CGFloat = 149
}


private extension CommonAlertView {
    @objc func leftButtonClick() {
        leftClickAction?()
    }
    
    @objc func rightButtonClick() {
        rightClickAction?()
    }
}

extension CommonAlertView: CustomAlertView {
    public func customAlertSize(at rect: CGRect) -> CGSize {
        return CGSize(width: alertWidth, height: alertHeight)
    }
}
