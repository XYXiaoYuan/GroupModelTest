//  
//  FinancialDetailViewController.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import UIKit
import BaseViewController

fileprivate extension FinancialType {
    var navTitle: String {
        switch self {
        case .current:
            return "活期详情".localized
        case .fix:
            return "定期详情".localized
        }
    }
    
    var operationItems: [FinancialDetailOperationAction] {
        switch self {
        case .current:
            return [.transactionDetail, .deposit, .currentTakeOut]
        case .fix:
            return [.investAgain, .fixTakeOut]
        }
    }
}

// MARK: - FinancialDetailViewController
class FinancialDetailViewController: BaseViewController {
    // MARK: - Properties
    /// 理财类型
    private var financialType: FinancialType = .current
    
    public var listMs: [FinancialDetailGroupModel] = [] {
        didSet {
            listMs.sort(by: {
                return $0.sortIndex < $1.sortIndex
            })
            collectionView.reloadData()
        }
    }
    
    /// 组模型排序规则(可以由后台配置返回,在这里我们先给一个默认值)
    /// 需要做一个请求依赖,先请求排序接口,再请求各组的数据
    public lazy var sortModel: FinancialDetailGroupSortModel = FinancialDetailGroupSortModel.defaultSort

    /// 初始化构造器
    convenience init(financialType: FinancialType) {
        self.init()
        self.financialType = financialType
        title = financialType.navTitle
        
        /// 加载数据
        loadData()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置UI
        setupUI()
    }

    override func setupNavi() {
        super.setupNavi()
        view.backgroundColor = 0xF9F9F9.uiColor
        navi_topView.backgroundColor = UIColor.white
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
        collectionView.register(FinancialDetailHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialDetailHeaderReusableView.identifier)
        collectionView.register(FinancialDetailOperationItemReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialDetailOperationItemReusableView.identifier)
        collectionView.register(FinancialDetailTimeLineReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialDetailTimeLineReusableView.identifier)
        collectionView.register(FinancialDetailProfitReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialDetailProfitReusableView.identifier)

        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier)

        /// 注册cell
        collectionView.register(FinancialDetailProfitCell.self, forCellWithReuseIdentifier: FinancialDetailProfitCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
    }

    // MARK: - 间距
    private var margin: CGFloat {
        return 10
    }
}

// MARK: - Private Methods
private extension FinancialDetailViewController {
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
        let financialCardType: FinancialDetailType = FinancialDetailType.financialCard(model: FinancialResultModel())
        let financialCardGroup = FinancialDetailGroupModel(cellType: financialCardType, sortIndex: sortModel.financialCardIndex)
        financialCardGroup.addTo(listMs: &listMs)
        
        let operationItemType: FinancialDetailType = FinancialDetailType.operationItem(list: financialType.operationItems)
        let operationItemGroup = FinancialDetailGroupModel(cellType: operationItemType, sortIndex: sortModel.operationItemIndex)
        operationItemGroup.addTo(listMs: &listMs)
        
        if financialType == .fix {
            let fixTimelineType: FinancialDetailType = FinancialDetailType.fixTimeline(model: FinancialFixTimeModel.defaultModel())
            let fixTimelineGroup = FinancialDetailGroupModel(cellType: fixTimelineType, sortIndex: sortModel.fixTimelineIndex)
            fixTimelineGroup.addTo(listMs: &listMs)
        }
        
        let profitDetailList = financialType == .current ? FinancialDetailProfitDetailModel.currentProfitDetail() : FinancialDetailProfitDetailModel.fixProfitDetail()
        let profitDetailType: FinancialDetailType = FinancialDetailType.profitDetail(list: profitDetailList)
        let profitDetailGroup = FinancialDetailGroupModel(cellType: profitDetailType, sortIndex: sortModel.profitDetailIndex)
        profitDetailGroup.addTo(listMs: &listMs)

        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension FinancialDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listMs.count
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .financialCard, .operationItem, .fixTimeline:
            return 0
        case let .profitDetail(list):
            return list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .financialCard, .operationItem, .fixTimeline:
            return UICollectionViewCell()
        case let .profitDetail(list):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialDetailProfitCell.identifier, for: indexPath) as! FinancialDetailProfitCell
            cell.detailModel = list[indexPath.item]
            cell.hideBottomLineView(isLast: indexPath.item == (list.count - 1))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let groupModel = listMs[indexPath.section]
        if kind == UICollectionView.elementKindSectionHeader {
            switch groupModel.cellType {
            case let .financialCard(model):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialDetailHeaderReusableView.identifier, for: indexPath) as! FinancialDetailHeaderReusableView
                headerView.financialDetail = model
                headerView.detailArrowButtonCallback = { [weak self] in
                    guard let `self` = self else { return }
                    switch self.financialType {
                    case .current:
                        let vc = CurrentFinancialViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .fix:
                        let vc = FixFinancialViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                return headerView
            case let .operationItem(list):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialDetailOperationItemReusableView.identifier, for: indexPath) as! FinancialDetailOperationItemReusableView
                headerView.operationItems = list
                headerView.delegate = self
                return headerView
            case let .fixTimeline(model):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialDetailTimeLineReusableView.identifier, for: indexPath) as! FinancialDetailTimeLineReusableView
                headerView.timeModel = model
                return headerView
            case .profitDetail(_):
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FinancialDetailProfitReusableView.identifier, for: indexPath) as! FinancialDetailProfitReusableView
                return headerView
            }
        }
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier, for: indexPath)
        return footer
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FinancialDetailViewController: UICollectionViewDelegateFlowLayout {
    /// Cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let groupModel = listMs[indexPath.section]
        let width = screenWidth - 2 * margin
        switch groupModel.cellType {
        case .financialCard, .operationItem, .fixTimeline:
            return CGSize.zero
        case .profitDetail:
            return CGSize(width: width, height: 63)
        }
    }
    
    /// 每组的UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .financialCard:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .operationItem:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .fixTimeline:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .profitDetail:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    /// Cell高度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .financialCard, .operationItem, .fixTimeline, .profitDetail:
            return 0
        }
    }
    
    /// Cell宽度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .financialCard, .operationItem, .fixTimeline, .profitDetail:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let groupModel = listMs[section]
        let width = screenWidth - 2 * margin
        switch groupModel.cellType {
        case .financialCard:
            return CGSize(width: width, height: 236)
        case .operationItem:
            return CGSize(width: width, height: 60)
        case .fixTimeline:
            return CGSize(width: width, height: 55)
        case .profitDetail:
            return CGSize(width: width, height: 40)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FinancialDetailViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .financialCard, .operationItem, .fixTimeline:
            break
        case let .profitDetail(list):
            guard !list.isEmpty else {
                return
            }
            
            /// TODO: 参数model待传递
            let vc = FinancialDetailViewController(financialType: .current)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - SectionColorCollectionViewDelegateFlowLayout
extension FinancialDetailViewController: SectionColorCollectionViewDelegateFlowLayout {
    func backgroundColorForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .financialCard:
            return .white
        case .operationItem:
            return .clear
        case .fixTimeline:
            return .clear
        case .profitDetail:
            return .white
        }
    }
    
    func cornerRadiusForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cornerDescriptionForSectionAt section: Int) -> (corner: UIRectCorner ,radii: CGSize) {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .operationItem, .fixTimeline:
            return (corner: [], radii: CGSize.zero)
        default:
            return (corner: .allCorners, radii: CGSize(width: 8, height: 8))
        }
    }
}

// MARK: - FinancialDetailOperationItemReusableViewDelegate
extension FinancialDetailViewController: FinancialDetailOperationItemReusableViewDelegate {
    func buttonClick(with type: FinancialDetailOperationAction) {
        switch type {
        case .transactionDetail:
            let vc = FinancialTransactionDetailVC()
            navigationController?.pushViewController(vc, animated: true)
        case .deposit:
            print(type.title)
        case .currentTakeOut:
            break
//            let vc = CurrentFinancialCheckOutVC()
//            navigationController?.pushViewController(vc, animated: true)
        case .investAgain:
            let vc = FixFinancialViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .fixTakeOut:
            let vc = FixFinancialTakeOutVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
