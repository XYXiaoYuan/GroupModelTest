//
//  GoodsRankMenuView.swift
//  GoodsRankMenuView
//
//  Created by 袁小荣 on 2020/7/20.
//

import UIKit
import RSExtension
import RSBaseConfig

public protocol GoodsRankMenuViewDelegate: NSObjectProtocol {
    /// 普通选按钮点击的处理事件
    func menuViewButtonClick(_ menuView: GoodsRankMenuView, model: RankMenuModel, button: BottomLineButton)
    /// 筛选/分类按钮点击的处理事件
    func menuViewFilterButtonClick(_ menuView: GoodsRankMenuView, filterButton: BottomLineButton)
}

public class GoodsRankMenuView: UIView {
    
    public weak var delegate: GoodsRankMenuViewDelegate?
    
    public var menuMs: [RankMenuModel]? {
        didSet {
            guard let menuMs = menuMs else { return }
            
            for i in 0..<menuMs.count {
                let model = menuMs[i]
                
                let button = BottomLineButton(type: .custom)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.setTitleColor(normalTitleColor, for: .normal)
                button.setTitleColor(selectedTitleColor, for: .selected)
                button.isSelected = (0 == i)
                
                button.tag = i
                
                // 设置文字
                button.setTitle(model.title, for: .normal)
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.titleLabel?.minimumScaleFactor = 0.1
                if model.hasImage {
                    button.setImage(model.normalImage, for: .normal)
                    if let selectedImage = model.selectedImage {
                        button.setImage(selectedImage, for: .selected)
                    }
                }
                
                // 添加button为子view
                addSubview(button)
                
                // 添加事件响应
                button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            }
        }
    }
    
    public convenience init(normalTitleColor: UIColor, selectedTitleColor: UIColor, delegate: GoodsRankMenuViewDelegate) {
        self.init()
        self.normalTitleColor = normalTitleColor
        self.selectedTitleColor = selectedTitleColor
        self.delegate = delegate
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let menuMs = menuMs else { return }

        // 1.拿到按钮的高度
        let h = frame.size.height
        let w = frame.size.width / CGFloat(menuMs.count)
        let y: CGFloat = 0
        
        // 2.0.遍历创建按钮,并给按钮设置对应的frame值
        for i in 0..<menuMs.count {
            let x: CGFloat = CGFloat(i) * w
            
            // 2.1.拿到第 i 个按钮
            let subview = subviews[i]
            // 2.2.设置第 i 个的按钮的frame的值
            subview.frame = CGRect(x: x, y: y, width: w, height: h)
            
            // 2.3.设置左文字右图片
            if let button = subview as? BottomLineButton, let image = button.imageView?.image, let titleLabel = button.titleLabel {
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -image.size.width - 5.auto(), bottom: 0, right: image.size.width)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleLabel.bounds.size.width, bottom: 0, right: -titleLabel.bounds.size.width)
            }
        }
    }
    
    // MARK: - Getter
    private var previousButton: BottomLineButton?
    private var previousTag: Int = 0
    private var normalTitleColor: UIColor = 0x333333.uiColor
    private var selectedTitleColor: UIColor = 0x333333.uiColor
}

extension GoodsRankMenuView {
    @objc private func buttonClick(_ sender: BottomLineButton) {
        // 1.拿到按钮的tag
        let tag = sender.tag;
        
        guard var menuMs = menuMs, let button = subviews[tag] as? BottomLineButton else { return }

        // 如果不是筛选按钮/分类按钮,修改按钮的选中状态
        let isFilter = menuMs[tag].type == .filter && tag == (menuMs.count - 1)
        let isCategory = menuMs[tag].type == .cate && tag == (menuMs.count - 1)
        if (isFilter || isCategory) {// 筛选和分类特殊处理
            // 筛选按钮代理传值出去
            delegate?.menuViewFilterButtonClick(self, filterButton: button)
            return ;
        }
        
        if let lastButton = subviews[previousTag] as? BottomLineButton {
            lastButton.isSelected = false;
            button.isSelected = true;
        }

        // 2.1.还原上一个点击过的 有图片 按钮的 图片
        if previousTag != tag {
            previousButton?.setImage(menuMs[previousTag].normalImage, for: .normal)
            menuMs[previousTag].setIsAsend(false)
            menuMs[previousTag].setIsDescend(true)
        }

        // 2.2.根据tag模型拿到view所对应的模型,再修改模型数据
        var model = menuMs[tag];
        // 3.修改模型数据.如果有图片的情况
        if (model.hasImage) {
           // 如果是升序,就变成降序;如果是降序,就变成升序
           if (model.isAsend) {
                model.setIsAsend(false)
                model.setIsDescend(true)
                model.setByString("DESC")
                button.setImage(model.descendImage, for: .normal)
           } else {
                model.setIsAsend(true)
                model.setIsDescend(false)
                model.setByString("ASC")
                button.setImage(model.asendImage, for: .normal)
           }
            self.menuMs?[tag] = model
        }
        
        // 保存上一次点击过的按钮和tag值
        previousButton = button;
        previousTag = tag;

        // 其它按钮代理传值出去
        delegate?.menuViewButtonClick(self, model: model, button: button)
    }
}

public class BottomLineButton: UIButton {
    public override var isSelected: Bool {
        didSet {
            lineView.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let width: CGFloat = 20
        let height: CGFloat = 3
        let y = bounds.height - height
        let x = (bounds.width - width) * 0.5
        lineView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    /// Getters
    private lazy var lineView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 3
        v.layer.masksToBounds = true
        v.backgroundColor = 0x00D9A2.uiColor
        return v
    }()
}
