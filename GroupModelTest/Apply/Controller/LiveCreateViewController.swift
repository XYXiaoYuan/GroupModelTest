//  
//  LiveCreateViewController.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//  主播申请直播页面

import UIKit
import BaseViewController

class LiveCreateViewController: BaseViewController {
   
    /// 组模型数据
    public var listMs: [LiveCreateGroupModel] = [] {
        didSet {
            listMs.sort(by: {
                return $0.sortIndex < $1.sortIndex
            })
            collectionView.reloadData()
        }
    }

    /// 组模型排序规则(可以由后台配置返回,在这里我们先给一个默认值)
    /// 需要做一个请求依赖,先请求排序接口,再请求各组的数据
    public lazy var sortModel: LiveCreateGroupSortModel = LiveCreateGroupSortModel.defaultSort

    /// 一些视图
    private var titleView: LiveCreateTitleReusableView?
    private var subTitleView: LiveCreateSubTitleReusableView?
    private var categoryView: LiveCreateCategoryReusableView?
    private var coverView: LiveCreateCoverReusableView?
    private var hotCoverView: LiveCreateHotCoverReusableView?
    private var typeView: LiveCreateTypeReusableView?
    private var commerceView: LiveCreateCommerceReusableView?
    private var bottomView: LiveCreateBottomButtonReusableView?
    
    /// 私域密码
    private var password: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置UI
        setupUI()
        
        /// 加载数据
        loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupNavi() {
        super.setupNavi()
        view.backgroundColor = 0xF3F4F8.uiColor
        navi_topView.backgroundColor = UIColor.white
        
        title = "XX直播".localized
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func registerCells(with collectionView: UICollectionView) {
        /// 注册reusableVie
        collectionView.register(LiveCreateTitleReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateTitleReusableView.identifier)
        collectionView.register(LiveCreateSubTitleReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateSubTitleReusableView.identifier)
        collectionView.register(LiveCreateCategoryReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateCategoryReusableView.identifier)
        collectionView.register(LiveCreateCoverReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateCoverReusableView.identifier)
        collectionView.register(LiveCreateHotCoverReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateHotCoverReusableView.identifier)
        collectionView.register(LiveCreateTypeReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateTypeReusableView.identifier)
        collectionView.register(LiveCreateCommerceReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateCommerceReusableView.identifier)
        collectionView.register(LiveCreateBottomButtonReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateBottomButtonReusableView.identifier)

        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier)
    }

    // MARK: - Getting and Setting
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navbarMaxY - tabbarH), collectionViewLayout: flowLayout)
        collectionView.contentInset.top = margin
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        registerCells(with: collectionView)
        return collectionView
    }()

    private lazy var flowLayout: SectionColorFlowLayout = {
        let layout = SectionColorFlowLayout()
        return layout
    }()
    
    private var margin: CGFloat {
        return 10
    }
    
    private var cardWidth: CGFloat {
        return screenWidth - 2 * margin
    }
}

// MARK: - Private Methods
private extension LiveCreateViewController {
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navi_topView.snp.bottom)
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview()
        }
    }
    
    func loadData() {
        let liveTitleGroupModel = LiveCreateGroupModel(cellType: .liveTitle(title: "直播标题".localized), sortIndex: sortModel.liveTitleIndex)
        liveTitleGroupModel.addTo(listMs: &self.listMs)
        
        let liveSubTitleGroupModel = LiveCreateGroupModel(cellType: .liveSubTitle(title: "直播副标题".localized), sortIndex: sortModel.liveSubTitleIndex)
        liveSubTitleGroupModel.addTo(listMs: &self.listMs)
        
        let liveCategoryGroupModel = LiveCreateGroupModel(cellType: .liveCategory(title: "直播分类".localized), sortIndex: sortModel.liveCategoryIndex)
        liveCategoryGroupModel.addTo(listMs: &self.listMs)
        
        let liveCoverGroupModel = LiveCreateGroupModel(cellType: .liveCover(title: "直播封面".localized), sortIndex: sortModel.liveCoverIndex)
        liveCoverGroupModel.addTo(listMs: &self.listMs)
        
        let liveHotCoverGroupModel = LiveCreateGroupModel(cellType: .liveHotCover(title: "直播热门封面".localized), sortIndex: sortModel.liveHotCoverIndex)
        liveHotCoverGroupModel.addTo(listMs: &self.listMs)
        
        let liveTypeGroupModel = LiveCreateGroupModel(cellType: .liveType(title: "直播类型".localized), sortIndex: sortModel.liveTypeIndex)
        liveTypeGroupModel.addTo(listMs: &self.listMs)
        
        let goodsTypeGroupModel = LiveCreateGroupModel(cellType: .liveCommerce(goodsType: .no), sortIndex: sortModel.liveCommerceIndex)
        goodsTypeGroupModel.addTo(listMs: &self.listMs)
        
        let bottomButtonGroupModel = LiveCreateGroupModel(cellType: .bottomButton, sortIndex: sortModel.bottomButtonIndex)
        bottomButtonGroupModel.addTo(listMs: &self.listMs)
    }
}

extension LiveCreateViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listMs.count
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.identifier, for: indexPath)
            return footer
        }
        
        let groupModel = listMs[indexPath.section]
        switch groupModel.cellType {
        case .liveTitle(let title):
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateTitleReusableView.identifier, for: indexPath) as! LiveCreateTitleReusableView
            headerView.updateTitle(title)
            titleView = headerView
            return headerView
        case .liveSubTitle(let title):
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateSubTitleReusableView.identifier, for: indexPath) as! LiveCreateSubTitleReusableView
            headerView.updateTitle(title)
            subTitleView = headerView
            return headerView
        case .liveCategory(let title):
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateCategoryReusableView.identifier, for: indexPath) as! LiveCreateCategoryReusableView
//            headerView.updateTitle(title)
//            headerView.delegate = self
            categoryView = headerView
            return headerView
        case .liveCover(let title):
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateCoverReusableView.identifier, for: indexPath) as! LiveCreateCoverReusableView
            headerView.updateTitle(title)
            coverView = headerView
            return headerView
        case .liveHotCover(let title):
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateHotCoverReusableView.identifier, for: indexPath) as! LiveCreateHotCoverReusableView
            headerView.updateTitle(title)
            hotCoverView = headerView
            return headerView
        case .liveCommerce:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateCommerceReusableView.identifier, for: indexPath) as! LiveCreateCommerceReusableView
            headerView.studioDeliveryTypeCallback = { [weak self] (goodsType: StudioDeliveryType) in
                guard let `self` = self else { return }
                let groupModel = LiveCreateGroupModel(cellType: .liveCommerce(goodsType: goodsType), sortIndex: self.sortModel.liveCommerceIndex)
                groupModel.addTo(listMs: &self.listMs)
            }
            headerView.productChooseCallback = { [weak self] (type: StudioProductType) in
//                self?.chooseProduct(type: type)
            }
            commerceView = headerView
            return headerView
        case .liveType(let title):
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateTypeReusableView.identifier, for: indexPath) as! LiveCreateTypeReusableView
            headerView.updateTitle(title)
            headerView.studioLiveTypeCallback = { [weak self] (liveType: StudioLiveType) in
                guard let `self` = self else { return }
                switch liveType {
                case .common:
                    print("选中了普通直播,正经小伙")
                case .secret:
                    break
                }
            }
            typeView = headerView
            return headerView
        case .bottomButton:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LiveCreateBottomButtonReusableView.identifier, for: indexPath) as! LiveCreateBottomButtonReusableView
//            headerView.delegate = self
            bottomView = headerView
            return headerView
        }
    }
}

extension LiveCreateViewController: UICollectionViewDelegateFlowLayout {
    /// Cell大小
    public func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
    
    /// Cell高度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .liveHotCover:
            return 15
        default:
            return margin
        }
    }
    
    /// Cell宽度间隔
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .liveTitle:
            return CGSize(width: cardWidth, height: 118)
        case .liveSubTitle:
            return CGSize(width: cardWidth, height: 82)
        case .liveCategory:
            return CGSize(width: cardWidth, height: 104)
        case .liveCover:
            return CGSize(width: cardWidth, height: 155)
        case .liveHotCover:
            return CGSize(width: cardWidth, height: 180)
        case .liveType:
            return CGSize(width: cardWidth, height: 50)
        case .liveCommerce(let goodsType):
            return CGSize(width: cardWidth, height: goodsType.height)
        case .bottomButton:
            return CGSize(width: cardWidth, height: 81)
        }
    }
}

extension LiveCreateViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

