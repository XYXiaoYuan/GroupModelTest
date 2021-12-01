//  
//  MyFinancialViewController.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/5.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit
import BaseViewController

// MARK: - MyFinancialViewController
class MyFinancialViewController: BaseViewController {
    // MARK: - Properties
    public var listMs: [MyFinancialGroupModel] = [] {
        didSet {
            listMs.sort(by: {
                return $0.sortIndex < $1.sortIndex
            })
            collectionView.reloadData()
        }
    }
    
    /// 组模型排序规则(可以由后台配置返回,在这里我们先给一个默认值)
    /// 需要做一个请求依赖,先请求排序接口,再请求各组的数据
    public lazy var sortModel: MyFinancialGroupSortModel = MyFinancialGroupSortModel.defaultSort

    /// 是否正在模拟空页面数据
    private var isSimulationEmptyData: Bool = false
    
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
        
        title = "我的理财".localized
        
        rightItem = BarButtonItem(title: "模拟空页面", config:  { (button) in
            button.setTitleColor(0x333333.uiColor, for: .normal)
            button.titleLabel?.font = UIFont.regular(CGFloat(16))
        }, action: { [weak self] (_) in
            self?.simulationEmptyData()
        })
    }
    
    // MARK: - Getter and Setter
    /// flowLayout
    private lazy var flowLayout: SectionColorFlowLayout = {
        let layout = SectionColorFlowLayout()
        return layout
    }()

    /// collectionView
    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navbarMaxY)
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
        collectionView.register(MyFinancialAssetReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyFinancialAssetReusableView.identifier)
        collectionView.register(FinancialProfitReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialProfitReusableView.identifier)
        collectionView.register(MyFinancialWealthReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyFinancialWealthReusableView.identifier)
        
        collectionView.register(MyFinancialWealthFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MyFinancialWealthFooterView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier)

        /// 注册cell
        collectionView.register(MyFinancialCurrentCell.self, forCellWithReuseIdentifier: MyFinancialCurrentCell.identifier)
        collectionView.register(MyFinancialFixCell.self, forCellWithReuseIdentifier: MyFinancialFixCell.identifier)
        collectionView.register(MyFinancialNoRecordCell.self, forCellWithReuseIdentifier: MyFinancialNoRecordCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
    }

    // MARK: - 间距
    private var margin: CGFloat {
        return 10
    }

}

// MARK: - Private Methods
private extension MyFinancialViewController {
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
        let assetType: MyFinancialType = MyFinancialType.asset(model: MyFinancialResultModel())
        let assetGroup = MyFinancialGroupModel(cellType: assetType, sortIndex: sortModel.assetIndex)
        assetGroup.addTo(listMs: &listMs)
        
        let profitType: MyFinancialType = MyFinancialType.profit(model: FinancialResultModel())
        let profitGroup = MyFinancialGroupModel(cellType: profitType, sortIndex: sortModel.profitIndex)
        profitGroup.addTo(listMs: &listMs)
        
        let myCurrentType: MyFinancialType = MyFinancialType.myCurrent(model: MyFinancianHeaderModel.myCurrentHeaderModel(), list: MyFinancialProductListModel.defaultCurrnetData())
        let myCurrentGroup = MyFinancialGroupModel(cellType: myCurrentType, sortIndex: sortModel.myCurrentIndex)
        myCurrentGroup.addTo(listMs: &listMs)
        
        let myFixType: MyFinancialType = MyFinancialType.myFix(model: MyFinancianHeaderModel.myFixHeaderModel(), list: MyFinancialProductListModel.defaultFixData())
        let myFixGroup = MyFinancialGroupModel(cellType: myFixType, sortIndex: sortModel.myFixIndex)
        myFixGroup.addTo(listMs: &listMs)

        collectionView.reloadData()
    }
    
    func simulationEmptyData() {
        isSimulationEmptyData = !isSimulationEmptyData
        
        if isSimulationEmptyData {
            let myCurrentType: MyFinancialType = MyFinancialType.myCurrent(model: MyFinancianHeaderModel.myCurrentHeaderModel(), list: [])
            let myCurrentGroup = MyFinancialGroupModel(cellType: myCurrentType, sortIndex: sortModel.myCurrentIndex)
            myCurrentGroup.addTo(listMs: &listMs)
            
            let myFixType: MyFinancialType = MyFinancialType.myFix(model: MyFinancianHeaderModel.myFixHeaderModel(), list: [])
            let myFixGroup = MyFinancialGroupModel(cellType: myFixType, sortIndex: sortModel.myFixIndex)
            myFixGroup.addTo(listMs: &listMs)
        } else {
            let myCurrentType: MyFinancialType = MyFinancialType.myCurrent(model: MyFinancianHeaderModel.myCurrentHeaderModel(), list: MyFinancialProductListModel.defaultCurrnetData())
            let myCurrentGroup = MyFinancialGroupModel(cellType: myCurrentType, sortIndex: sortModel.myCurrentIndex)
            myCurrentGroup.addTo(listMs: &listMs)
            
            let myFixType: MyFinancialType = MyFinancialType.myFix(model: MyFinancianHeaderModel.myFixHeaderModel(), list: MyFinancialProductListModel.defaultFixData())
            let myFixGroup = MyFinancialGroupModel(cellType: myFixType, sortIndex: sortModel.myFixIndex)
            myFixGroup.addTo(listMs: &listMs)
        }
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MyFinancialViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listMs.count
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset, .profit:
            return 0
        case let .myCurrent(_, list), let .myFix(_, list):
            if list.isEmpty {
                return 1
            }
            return list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .asset, .profit:
            return UICollectionViewCell()
        case let .myCurrent(_, list):
            if list.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFinancialNoRecordCell.identifier, for: indexPath) as! MyFinancialNoRecordCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFinancialCurrentCell.identifier, for: indexPath) as! MyFinancialCurrentCell
                cell.productModel = list[indexPath.item]
                cell.hideBottomLineView(isLast: indexPath.item == (list.count - 1))
                return cell
            }
        case let .myFix(_, list):
            if list.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFinancialNoRecordCell.identifier, for: indexPath) as! MyFinancialNoRecordCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFinancialFixCell.identifier, for: indexPath) as! MyFinancialFixCell
                cell.productModel = list[indexPath.item]
                cell.hideBottomLineView(isLast: indexPath.item == (list.count - 1))
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let groupModel = listMs[indexPath.section]
        if kind == UICollectionView.elementKindSectionHeader {
            switch groupModel.cellType {
            case let .asset(model):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyFinancialAssetReusableView.identifier, for: indexPath) as! MyFinancialAssetReusableView
                headerView.myFinancialModel = model
                return headerView
            case let .profit(model):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialProfitReusableView.identifier, for: indexPath) as! FinancialProfitReusableView
                headerView.financialModel = model
                return headerView
            case let .myCurrent(model, list), let .myFix(model, list):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyFinancialWealthReusableView.identifier, for: indexPath) as! MyFinancialWealthReusableView
                headerView.headerModel = model
                headerView.hideBottomLabels(isNeedHidden: list.isEmpty)
                return headerView
            }
        } else {
            switch groupModel.cellType {
            case let .myCurrent(_, _), let .myFix(_, _):
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MyFinancialWealthFooterView.identifier, for: indexPath) as! MyFinancialWealthFooterView
                return footer
            default:
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier, for: indexPath)
                return footer
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MyFinancialViewController: UICollectionViewDelegateFlowLayout {
    /// Cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let groupModel = listMs[indexPath.section]
        let width = screenWidth - 2 * margin
        switch groupModel.cellType {
        case .asset, .profit:
            return CGSize.zero
        case .myCurrent(_, let list):
            let height: CGFloat = list.isEmpty ? 140 : 90
            return CGSize(width: width, height: height)
        case .myFix(_, let list):
            let height: CGFloat = list.isEmpty ? 140 : 114
            return CGSize(width: width, height: height)
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
        case .myCurrent:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .myFix:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    /// Cell高度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset, .profit:
            return 0
        case .myCurrent, .myFix:
            return 0
        }
    }
    
    /// Cell宽度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset, .profit:
            return 0
        case .myCurrent, .myFix:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let groupModel = listMs[section]
        let width = screenWidth - 2 * margin
        switch groupModel.cellType {
        case .asset:
            return CGSize(width: width, height: 412)
        case .profit:
            return CGSize(width: width, height: 95)
        case .myCurrent, .myFix:
            return CGSize(width: width, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let groupModel = listMs[section]
        let width = screenWidth - 2 * margin
        switch groupModel.cellType {
        case .asset, .profit:
            return CGSize.zero
        case .myCurrent, .myFix:
            return CGSize(width: width, height: 10)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MyFinancialViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .asset, .profit:
            break
        case let .myCurrent(_, list):
            guard !list.isEmpty else {
                return
            }
            
            /// TODO: 参数model待传递
            let vc = FinancialDetailViewController(financialType: .current)
            navigationController?.pushViewController(vc, animated: true)
        case let .myFix(_, list):
            guard !list.isEmpty else {
                return
            }
            
            /// TODO: 参数model待传递
            let vc = FinancialDetailViewController(financialType: .fix)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - SectionColorCollectionViewDelegateFlowLayout
extension MyFinancialViewController: SectionColorCollectionViewDelegateFlowLayout {
    func backgroundColorForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .asset:
            return .white
        case .profit:
            return .white
        case .myCurrent:
            return .white
        case .myFix:
            return .white
        }
    }
    
    func cornerRadiusForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cornerDescriptionForSectionAt section: Int) -> (corner: UIRectCorner ,radii: CGSize) {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .myCurrent, .myFix:
            return (corner: [.bottomLeft, .bottomRight], radii: CGSize(width: 8, height: 8))
        default:
            return (corner: .allCorners, radii: CGSize(width: 8, height: 8))
        }
    }
}
