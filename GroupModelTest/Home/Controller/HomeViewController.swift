//
//  HomeViewController.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/1/7.
//  Copyright © 2020 cfans. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    /// 组模型数据
    private var listMs: [HomeGroupModel] = [] {
        didSet {
            listMs.sort(by: {
                return $0.sortIndex < $1.sortIndex
            })
            collectionView.reloadData()
        }
    }
    
    /// 组模型排序规则(可以由后台配置返回,在这里我们先给一个默认值)
    /// 需要做一个请求依赖,先请求排序接口,再请求各组的数据
    private lazy var sortModel: HomeGroupSortModel = HomeGroupSortModel.defaultSort
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "组模型写法示例"
        
        setupUI()
        loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    // MARK: - Methods
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(navbarMaxY)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func loadData() {
        let historyType: HomeGroupCellType = HomeGroupCellType.historySearch(list: HistorySearchModel.historySearchDefaultData())
        let historyGroup = HomeGroupModel(cellType: historyType, sortIndex: sortModel.historySearchIndex, headerTitle: "搜索历史", needRightButton: true)
        historyGroup.addTo(listMs: &listMs)
        
        let recommendType: HomeGroupCellType = HomeGroupCellType.recommendSearch(list: HistorySearchModel.recommendSearchDefaultData())
        let recommendGroup = HomeGroupModel(cellType: recommendType, sortIndex: sortModel.recommendSearchIndex, headerTitle: "搜索推荐")
        recommendGroup.addTo(listMs: &listMs)
        
        let todayHotType: HomeGroupCellType = HomeGroupCellType.todayHotSearch(list: HistorySearchModel.todayHotSearchDefaultData())
        let todayHotGroup = HomeGroupModel(cellType: todayHotType, sortIndex: sortModel.todayHotSearchIndex, headerTitle: "今日热搜")
        todayHotGroup.addTo(listMs: &listMs)
        
        collectionView.reloadData()
    }
    
    private func registerCells(with collectionView: UICollectionView) {
        /// 注册头部
        collectionView.register(HomeReuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeReuseHeaderView.identifier)
        collectionView.register(HomeReuseFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeReuseFooterView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UICollectionReusableView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier)
        
        
        /// 注册cell
        collectionView.register(HistorySearchCell.self, forCellWithReuseIdentifier: HistorySearchCell.identifier)
        collectionView.register(RecommendSearchCell.self, forCellWithReuseIdentifier: RecommendSearchCell.identifier)
        collectionView.register(TodayHotSearchCell.self, forCellWithReuseIdentifier: TodayHotSearchCell.identifier)
    }
    
    // MARK: - Getter
    /// collectionView
    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navbarMaxY)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor(red: 243, green: 243, blue: 243)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.isScrollEnabled = true
        //        collectionView.uHead = URefreshHeader { [weak self] in self?.loadData(true) }
        registerCells(with: collectionView)
        return collectionView
    }()
    
    private lazy var flowLayout: SectionColorFlowLayout = {
        let layout = SectionColorFlowLayout()
        return layout
    }()
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listMs.count
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .historySearch(let list):
            return list.count
        case .recommendSearch(let list):
            return list.count
        case .todayHotSearch(let list):
            return list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .historySearch(let list):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistorySearchCell.identifier, for: indexPath) as! HistorySearchCell
            cell.historyModel = list[indexPath.item]
            return cell
        case .recommendSearch(let list):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendSearchCell.identifier, for: indexPath) as! RecommendSearchCell
            cell.historyModel = list[indexPath.item]
            return cell
        case .todayHotSearch(let list):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayHotSearchCell.identifier, for: indexPath) as! TodayHotSearchCell
            cell.historyModel = list[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let groupModel = listMs[indexPath.section]
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeReuseHeaderView.identifier, for: indexPath) as! HomeReuseHeaderView
            headerView.headerTitle = groupModel.headerTitle
            headerView.isNeedRightButton = groupModel.needRightButton
            return headerView
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeReuseFooterView.identifier, for: indexPath)
        return footer
    }
}

// MARK: - SectionColorCollectionViewDelegateFlowLayout
extension HomeViewController: SectionColorCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
//        let groupModel = listMs[section]
//        switch groupModel.cellType {
//        case .historySearch:
//            return .red
//        case .recommendSearch:
//            return .green
//        case .todayHotSearch:
//            return .blue
//        }
    }
    
    func cornerRadiusForSection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, cornerDescriptionForSectionAt section: Int) -> (corner: UIRectCorner ,radii: CGSize) {
        return (corner: .allCorners, radii: CGSize(width: 8, height: 8))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    /// Cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .historySearch(let list):
            let value = list[indexPath.item].name
            let valueWidth = value.ttBoundingRect(with: CGSize(width: screenWidth * 0.5, height: 40), font: UIFont.medium(12)).width
            return CGSize(width: 30 + valueWidth + 2 * 20, height: 40)
        case .recommendSearch(let list):
            let value = list[indexPath.item].name
            let valueWidth = value.ttBoundingRect(with: CGSize(width: screenWidth * 0.5, height: 40), font: UIFont.medium(12)).width
            return CGSize(width: valueWidth + 2 * 20, height: 40)
        case .todayHotSearch:
            return CGSize(width: screenWidth * 0.5, height: 30)
        }
    }
    
    /// 每组的UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .historySearch:
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        case .recommendSearch:
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        case .todayHotSearch:
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
    }
    
    /// Cell高度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .historySearch:
            return 15
        case .recommendSearch:
            return 15
        case .todayHotSearch:
            return 10
        }
    }
    
    /// Cell宽度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .historySearch:
            return 15
        case .recommendSearch:
            return 15
        case .todayHotSearch:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 78)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 10)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .historySearch:
            break
        case .recommendSearch:
            break
        case .todayHotSearch:
            break
        }
    }
}
