//
//  BaseViewController.swift
//  BaseViewController
//
//  Created by 袁小荣 on 2020/7/18.
//

import UIKit
import RSBaseConfig
import RSExtension

open class BaseViewController: NaviBarViewController {
    
    /// 子类实现
    override open func setupNavi() {
        let size = navi_topView.contentSize
        let titleView = NaviTitleView.init(frame: CGRect(origin: .zero, size: CGSize(width: size.width, height: 44)))
        titleView.title = title
        navi_topView.contentSubView = titleView
    }
    
    /// 子类实现的
    override open func naviBarFrame() -> CGRect {
        return .init(origin: .zero, size: .init(width: screenWidth, height: navbarMaxY))
    }
    
    override public var title: String? {
        didSet {
            smartTitleView?.title = title
        }
    }
        
    public func createScrollTitleView(title: String? = nil) -> ScrollTitleView {
        let h = naviBarViewSmartContentHeight(navi_topView)
        let rect = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: h))
        return ScrollTitleView(frame: rect, title: title)
    }
    
    public func createScrollFaceView(title: String? = nil, subTitle: String? = nil, iconImageSize: CGSize = .zero) -> ScrollTitleView {
        let h = naviBarViewSmartContentHeight(navi_topView)
        let rect = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: h))
        return ScrollTitleView(frame: rect, title: title, iconImageSize: iconImageSize)
    }

}

extension BaseViewController {
    
    public class ScrollTitleView: UIView {
        public  lazy var iconImageView: UIImageView = {
            let imgV = UIImageView()
            addSubview(imgV)
            return imgV
        }()
        
        public var iconImageSize: CGSize = .zero
        
        public lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = UIColor.black
            label.adjustLabel()
            label.frame = CGRect.init(x: 20.0, y: 21.0, width: self.width - 40.0, height: label.font.lineHeight)
            addSubview(label)
            return label
        }()
        
        public lazy var subTitleLabel: UILabel = {
            let label = UILabel()
            label.textColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: 12)
            addSubview(label)
            return label
        }()
                
        public func updateSubViewFrame() {
            var x: CGFloat = 20
            let hasIcon = iconImageSize.width > 0
            if hasIcon {
                iconImageView.bounds = CGRect(origin: .zero, size: iconImageSize)
                iconImageView.center = CGPoint(x: x + iconImageSize.width * 0.5, y: bounds.midY)
                x = iconImageSize.width + 20 + 17
            }
            subTitleLabel.sizeToFit()
            titleLabel.sizeToFit()
            let subTitleSize = subTitleLabel.bounds.size
            
            if subTitleSize.height > 0 {
                let margin: CGFloat = 6.5
                titleLabel.frame = CGRect.init(x: x, y: hasIcon ? iconImageView.centerY - titleLabel.height : 14.5, width: self.width - 20 - x, height: titleLabel.height)
                let subY: CGFloat = titleLabel.maxY + margin
                 subTitleLabel.frame = CGRect(origin: CGPoint(x: x, y: subY), size: subTitleSize)
            } else {
                titleLabel.frame = CGRect(origin: CGPoint(x: x, y: (bounds.height - titleLabel.height) * 0.5), size: CGSize.init(width: self.width - 40.0, height: titleLabel.height))
            }
        }
        
        convenience public init(frame: CGRect, title: String?, subTitle: String? = nil) {
            self.init(frame: frame)
            set(title: title, subTitle: subTitle)
        }
        
        convenience public init(frame: CGRect, title: String?, subTitle: String? = nil, iconImageSize: CGSize = .zero) {
            self.init(frame: frame)
            set(title: title, subTitle: subTitle, iconImageSize: iconImageSize)
        }
        
        public func set(title: String?, subTitle: String? = nil) {
            titleLabel.text = title
            subTitleLabel.text = subTitle
            updateSubViewFrame()
        }
        
        public func set(title: String?, subTitle: NSAttributedString? = nil) {
            titleLabel.text = title
            subTitleLabel.attributedText = subTitle
            updateSubViewFrame()
        }
        
        public func set(title: String?, subTitle: String? = nil, iconImageSize: CGSize = .zero) {
            titleLabel.text = title
            subTitleLabel.text = subTitle
            self.iconImageSize = iconImageSize
            updateSubViewFrame()
        }

    }
}

fileprivate extension UILabel {
    func adjustLabel() {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.1
    }
}

