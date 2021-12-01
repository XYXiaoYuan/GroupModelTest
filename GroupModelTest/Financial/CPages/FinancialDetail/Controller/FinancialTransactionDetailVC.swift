//  
//  FinancialTransactionDetailVC.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit
import BaseViewController

// MARK: -  FinancialTransactionDetailVC
class FinancialTransactionDetailVC: BaseViewController {
    // MARK: - Properties
    private var listMs: [FinancialDetailProfitDetailModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置UI
        setupUI()
        
        /// 加载数据
        loadData()
    }

    override func setupNavi() {
        super.setupNavi()
        view.backgroundColor = 0xF9F9F9.uiColor
        navi_topView.backgroundColor = UIColor.white
        
        title = "交易明细"
    }
    
    // MARK: - Getter and Setter
    private lazy var flowLayout: SectionColorFlowLayout = {
        let layout = SectionColorFlowLayout()
        return layout
    }()

    /// collectionView
    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navbarMaxY)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.isScrollEnabled = true
        registerCells(with: collectionView)
//        collectionView.uHead = URefreshHeader { [weak self] in self?.loadData(true, true) }
//        collectionView.uFoot = URefreshFooter { [weak self] in self?.getBottomData() }
//        collectionView.uFoot.isHidden = true
        
        return collectionView
    }()

    private func registerCells(with collectionView: UICollectionView) {
        /// 注册头部
        collectionView.register(FinancialTransactionDetailReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialTransactionDetailReusableView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier)

        /// 注册cell
        collectionView.register(FinancialTransactionDetailCell.self, forCellWithReuseIdentifier: FinancialTransactionDetailCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
    }

    // MARK: - 间距
    private var margin: CGFloat {
        return 10
    }

}

// MARK: - Private Methods
private extension FinancialTransactionDetailVC {
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navbarMaxY)
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview()
        }
    }
    
    func loadData() {
        listMs = FinancialDetailProfitDetailModel.currentProfitDetail()
    }
}

// MARK: - UICollectionViewDataSource
extension FinancialTransactionDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialTransactionDetailCell.identifier, for: indexPath) as! FinancialTransactionDetailCell
        cell.detailModel = listMs[indexPath.item]
        cell.hideBottomLineView(isLast: indexPath.item == (listMs.count - 1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialTransactionDetailReusableView.identifier, for: indexPath) as! FinancialTransactionDetailReusableView
            return headerView
        }
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier, for: indexPath)
        return footer
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FinancialTransactionDetailVC: UICollectionViewDelegateFlowLayout {
    /// Cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = screenWidth - 2 * margin
        return CGSize(width: width, height: 63)
    }
    
    /// 每组的UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    /// Cell高度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /// Cell宽度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = screenWidth - 2 * margin
        return CGSize(width: width, height: 40)
    }
}

// MARK: - UICollectionViewDelegate
extension FinancialTransactionDetailVC: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = listMs[indexPath.item]
    }
}

// MARK: - SectionColorCollectionViewDelegateFlowLayout
extension FinancialTransactionDetailVC: SectionColorCollectionViewDelegateFlowLayout {
    func backgroundColorForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
            return .white
    }
    
    func cornerRadiusForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cornerDescriptionForSectionAt section: Int) -> (corner: UIRectCorner ,radii: CGSize) {
        return (corner: .allCorners, radii: CGSize(width: 8, height: 8))
    }
}
