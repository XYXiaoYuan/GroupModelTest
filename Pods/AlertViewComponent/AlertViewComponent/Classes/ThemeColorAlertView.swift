//
//  ThemeColorAlertView.swift
//  AlertViewComponent
//
//  Created by 袁小荣 on 2020/7/27.
//

import Foundation

import UIKit
import SnapKit
import RSBaseConfig
import RSExtension

public enum AlertTheme: Int {
    case blue = 0
    case orange = 1
    
    var leftButtonBgColor: UIColor {
        switch self {
        case .blue:
            return HexAColor(hex: 0x0091FF, alpha: 0.1).uiColor
        case .orange:
            return HexAColor(hex: 0xF97C00, alpha: 0.1).uiColor
        }
    }
    
    var rightButtonBgColor: UIColor {
        switch self {
        case .blue:
            return 0x0091FF.uiColor
        case .orange:
            return 0xF97C00.uiColor
        }
    }
}

public class ThemeColorAlertView: UIView {
    public typealias AlertAction = (() -> Void)
    private var desc: String?
    private var leftTitle: String?
    private var rightTitle: String?
    private var theme: AlertTheme = .blue
    private var leftClickAction: AlertAction?
    private var rightClickAction: AlertAction?
    
    /// 便利初始化构造器
    public convenience init(frame: CGRect = .zero, desc: String?, leftTitle: String? = "取消", rightTitle: String? = "确定", theme: AlertTheme = .blue, leftAction: AlertAction? = nil, rightAction: AlertAction? = nil) {
        self.init(frame: frame)
                
        self.desc = desc
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        self.theme = theme
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
                
        topView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerX.centerY.equalToSuperview()
        }
                
        [leftButton, rightButton].forEach { addSubview($0) }
        leftButton.snp.makeConstraints { (make) in
            let buttonHeight: CGFloat = 38
            let buttonMargin: CGFloat = 10
            let buttonWidth: CGFloat = (alertWidth - 2 * 18 - buttonMargin) * 0.5
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.bottom.width.height.equalTo(leftButton)
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
        
    private lazy var leftButton = UIButton(type: .custom).then {
        $0.layer.cornerRadius = radius
        $0.layer.masksToBounds = true
        $0.backgroundColor = theme.leftButtonBgColor
        $0.titleLabel?.font = UIFont.medium(13)
        $0.setTitle(leftTitle, for: .normal)
        $0.setTitleColor(theme.rightButtonBgColor, for: .normal)
        $0.setTitleColor(theme.rightButtonBgColor, for: .highlighted)
        $0.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
    }
    
    private lazy var rightButton = UIButton(type: .custom).then {
        $0.layer.cornerRadius = radius
        $0.layer.masksToBounds = true
        $0.backgroundColor = theme.rightButtonBgColor
        $0.titleLabel?.font = UIFont.medium(13)
        $0.setTitle(rightTitle, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
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


private extension ThemeColorAlertView {
    @objc func leftButtonClick() {
        leftClickAction?()
    }
    
    @objc func rightButtonClick() {
        rightClickAction?()
    }
}

extension ThemeColorAlertView: CustomAlertView {
    public func customAlertSize(at rect: CGRect) -> CGSize {
        return CGSize(width: alertWidth, height: alertHeight)
    }
}
