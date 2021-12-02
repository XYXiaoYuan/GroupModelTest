//  
//  FinanciaViewController.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit
import BaseViewController

// MARK: -  FinanciaViewController
class FinanciaViewController: BaseViewController {
    // MARK: - Properties
    public var listMs: [FinancialHomeGroupModel] = [] {
        didSet {
            listMs.sort(by: {
                return $0.sortIndex < $1.sortIndex
            })
            collectionView.reloadData()
        }
    }
    
    /// 组模型排序规则(可以由后台配置返回,在这里我们先给一个默认值)
    /// 需要做一个请求依赖,先请求排序接口,再请求各组的数据
    public lazy var sortModel: FinancialHomeGroupSortModel = FinancialHomeGroupSortModel.defaultSort

    /// 当前理财方式
    private var type: FinancialType = .current {
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
        view.backgroundColor = 0xF3F4F8.uiColor
        navi_topView.backgroundColor = UIColor.white
        
        smartTitleView?.barType = .staticDisplay
        
        rightItem = BarButtonItem(title: "我的理财".localized, config: { (barButton) in
            barButton.enlargeEdge = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 10)
            barButton.setTitleColor(0x333333.uiColor, for: .normal)
            barButton.titleLabel?.font = UIFont.regular(15)
            barButton.titleEdgeInsets.right = -16
        }) { [ weak self] (_) in
            guard let `self` = self else { return }
            let vc = MyFinancialViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let iv = UIImageView(image: UIImage(named: "origin_logo"))
        let titleL = UILabel.ff_label(ff_text: "理财产品".localized, ff_color: 0x222222.uiColor, ff_align: .center, ff_font: UIFont.medium(16))
        [titleL, iv].forEach { navi_topView.addSubview($0) }
        /// 设置中间的View
        titleL.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(statusBarH)
            make.left.right.bottom.equalToSuperview()
        }
        iv.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleL)
            make.left.equalToSuperview().offset(16)
        }
    }

    
    // MARK: - Getter and Setter
    /// flowLayout
    private lazy var flowLayout: SectionColorFlowLayout = {
        let layout = SectionColorFlowLayout()
        return layout
    }()

    /// collectionView
    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navbarMaxY - tabbarH)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
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
        collectionView.register(FinancialAssetReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialAssetReusableView.identifier)
        collectionView.register(FinancialProfitReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialProfitReusableView.identifier)
        collectionView.register(FinancialProductHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialProductHeaderView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier)

        /// 注册cell
        collectionView.register(FinancialProductCell.self, forCellWithReuseIdentifier: FinancialProductCell.identifier)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
    }

    // MARK: - 间距
    private var margin: CGFloat {
        return 10
    }
}

// MARK: - Private Methods
private extension FinanciaViewController {
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
        let assetType: FinancialHomeType = FinancialHomeType.asset(model: FinancialResultModel())
        let assetGroup = FinancialHomeGroupModel(cellType: assetType, sortIndex: sortModel.assetIndex)
        assetGroup.addTo(listMs: &listMs)
        
        let profitType: FinancialHomeType = FinancialHomeType.profit(model: FinancialResultModel())
        let profitGroup = FinancialHomeGroupModel(cellType: profitType, sortIndex: sortModel.profitIndex)
        profitGroup.addTo(listMs: &listMs)
        
        let productType: FinancialHomeType = FinancialHomeType.product(currentList: FinancialProductListModel.defaultCurrnetData(), fixList: FinancialProductListModel.defaultFixData())
        let productGroup = FinancialHomeGroupModel(cellType: productType, sortIndex: sortModel.productIndex)
        productGroup.addTo(listMs: &listMs)
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension FinanciaViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listMs.count
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset, .profit:
            return 0
        case .product(let currentList, let fixList):
            return getProductList(currentList: currentList, fixList: fixList).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .asset, .profit:
            return UICollectionViewCell()
        case .product(let currentList, let fixList):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialProductCell.identifier, for: indexPath) as! FinancialProductCell
            let list = getProductList(currentList: currentList, fixList: fixList)
            cell.productModel = list[indexPath.item]
            cell.hideBottomLineView(isLast: indexPath.item == (list.count - 1))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let groupModel = listMs[indexPath.section]
            switch groupModel.cellType {
            case let .asset(model):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialAssetReusableView.identifier, for: indexPath) as! FinancialAssetReusableView
                headerView.financialModel = model
                return headerView
            case let .profit(model):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialProfitReusableView.identifier, for: indexPath) as! FinancialProfitReusableView
                headerView.financialModel = model
                return headerView
            case .product:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialProductHeaderView.identifier, for: indexPath) as! FinancialProductHeaderView
                headerView.switchFinancianType = { [weak self] (type) in
                    self?.type = type
                }
                return headerView
            }
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier, for: indexPath)
        return footer
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FinanciaViewController: UICollectionViewDelegateFlowLayout {
    /// Cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let groupModel = listMs[indexPath.section]
        let width = screenWidth - 2 * margin
        switch groupModel.cellType {
        case .asset, .profit:
            return CGSize.zero
        case .product:
            return CGSize(width: width, height: 90)
        }
    }
    
    /// 每组的UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset:
            return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        case .profit:
            return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        case .product:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    /// Cell高度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset, .profit:
            return 0
        case .product:
            return 0
        }
    }
    
    /// Cell宽度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset, .profit:
            return 0
        case .product:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let groupModel = listMs[section]
        let width = screenWidth - 2 * margin
        switch groupModel.cellType {
        case .asset:
            return CGSize(width: width, height: 166)
        case .profit:
            return CGSize(width: width, height: 95)
        case .product:
            return CGSize(width: width, height: 69)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FinanciaViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .asset, .profit:
            break
        case .product(let currentList, let fixList):
            let list = getProductList(currentList: currentList, fixList: fixList)
            /// TODO: 参数model待传递
            
            let item = list[indexPath.item]
            switch item.productType {
            case .current:
                let vc = CurrentFinancialViewController()
                navigationController?.pushViewController(vc, animated: true)
            case .fix:
                let vc = FixFinancialViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func getProductList(currentList: [FinancialProductListModel], fixList: [FinancialProductListModel]) -> [FinancialProductListModel] {
        let list: [FinancialProductListModel]
        switch type {
        case .current:
            list = currentList
        case .fix:
            list = fixList
        }
        return list
    }
}

// MARK: - SectionColorCollectionViewDelegateFlowLayout
extension FinanciaViewController: SectionColorCollectionViewDelegateFlowLayout {
    func backgroundColorForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset:
            return .white
        case .profit:
            return .white
        case .product:
            return .white
        }
    }
    
    func cornerRadiusForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cornerDescriptionForSectionAt section: Int) -> (corner: UIRectCorner ,radii: CGSize) {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .product:
            return (corner: [.bottomLeft, .bottomRight], radii: CGSize(width: 8, height: 8))
        default:
            return (corner: .allCorners, radii: CGSize(width: 8, height: 8))
        }
    }
}
