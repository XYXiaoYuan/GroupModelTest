//
//  SectionColorFlowLayout.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/1/7.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit


private let SectionBackground = "SectionColorCollectionReusableView"

protocol SectionColorCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
}

extension SectionColorCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.clear
    }
}

private class SectionColorCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor = UIColor.white

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SectionColorCollectionViewLayoutAttributes
        copy.backgroundColor = self.backgroundColor
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SectionColorCollectionViewLayoutAttributes else {
            return false
        }
        
        if !self.backgroundColor.isEqual(rhs.backgroundColor) {
            return false
        }
        return super.isEqual(object)
    }
}

private class SectionColorCollectionReusableView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attr = layoutAttributes as? SectionColorCollectionViewLayoutAttributes else {
            return
        }
        
        self.backgroundColor = attr.backgroundColor
    }
}

class SectionColorFlowLayout: UICollectionViewFlowLayout {
    
    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = []
    
    // MARK: - Init
    override init() {
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - setup
    func setup() {
        /// 1、注册
        self.register(SectionColorCollectionReusableView.classForCoder(), forDecorationViewOfKind: SectionBackground)
    }
    
    // MARK: - prepare
    override func prepare() {
        super.prepare()
        
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? SectionColorCollectionViewDelegateFlowLayout
            else {
                return
        }
        
        self.decorationViewAttrs.removeAll()
        for section in 0..<numberOfSections {
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else {
                    continue
            }
            
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = 0
            sectionFrame.origin.y -= sectionInset.top
            
            if self.scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                sectionFrame.size.width = self.collectionView!.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            
            /// 2、定义
            let attr = SectionColorCollectionViewLayoutAttributes(forDecorationViewOfKind: SectionBackground, with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = delegate.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section)
            
            self.decorationViewAttrs.append(attr)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: self.decorationViewAttrs.filter {
            return rect.intersects($0.frame)
        })
        /// 3、返回
        return attrs
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == SectionBackground {
            return self.decorationViewAttrs[indexPath.section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
}
