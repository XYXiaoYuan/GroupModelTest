//
//  LiveCreateGroupModel.swift
//  MALL_iOS
//
//  Created by 袁小荣 on 2021/3/26.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

// 直播间是否带货
public enum StudioDeliveryType: Int, HandyJSONEnum {
    case no = 0
    case yes = 1
}

// 直播间产品类型
public enum StudioProductType: Int, HandyJSONEnum {
    case none  = 0 // 无
    case goods = 1 // 商品
    case shop = 2  // 店铺
}

// 直播间直播类型,普通直播/私密直播
public enum StudioLiveType: Int, HandyJSONEnum {
    case common = 0 // 普通直播
    case secret = 1 // 私密直播
}

/// 新版首页组cell的类型
enum LiveCreateGroupCellType {
    case liveTitle(title: String) // 直播标题
    case liveSubTitle(title: String) // 直播副标题
    case liveCategory(title: String) // 直播分类
    case liveCover(title: String) // 直播封面
    case liveHotCover(title: String) // 直播热门封面
    case liveType(title: String) // 直播类型
    case liveCommerce(goodsType: StudioDeliveryType) // 是否带货
    case bottomButton
}

extension LiveCreateGroupCellType: Equatable {
    public static func == (lhs: LiveCreateGroupCellType, rhs: LiveCreateGroupCellType) -> Bool {
        switch (lhs, rhs) {
        case (.liveTitle, .liveTitle): return true
        case (.liveSubTitle, .liveSubTitle): return true
        case (.liveCategory, .liveCategory): return true
        case (.liveCover, .liveCover): return true
        case (.liveHotCover, .liveHotCover): return true
        case (.liveType, .liveType): return true
        case (.liveCommerce, .liveCommerce): return true
        case (.bottomButton, .bottomButton): return true
        default:
            return false
        }
    }
}

public struct LiveCreateGroupModel: GroupProvider {
    typealias GroupModel = LiveCreateGroupModel
    
    /// 组模型的类型
    var cellType: LiveCreateGroupCellType
    /// 排序
    var sortIndex: Int

    /// 把groupModel添加或替换到listMs中
    func addTo(listMs: inout [LiveCreateGroupModel]) {
        if isNeedAppend(with: self, listMs: listMs) {
            listMs.append(self)
        } else {
            let index = self.index(with: self, listMs: listMs)
            listMs[index] = self
        }
    }
}

extension LiveCreateGroupModel: Equatable {
    public static func == (lhs: LiveCreateGroupModel, rhs: LiveCreateGroupModel) -> Bool {
        return lhs.cellType == rhs.cellType
    }
}

// MARK: - 新版首页组模型的排序规则模型
struct LiveCreateGroupSortModel {
    /// 搜索历史的排序
    var liveTitleIndex: Int
    var liveSubTitleIndex: Int
    var liveCategoryIndex: Int
    var liveCoverIndex: Int
    var liveHotCoverIndex: Int
    var liveTypeIndex: Int
    var liveCommerceIndex: Int
    var bottomButtonIndex: Int
    
    static var defaultSort: LiveCreateGroupSortModel {
        return LiveCreateGroupSortModel(
            liveTitleIndex: 0,
            liveSubTitleIndex: 1,
            liveCategoryIndex: 2,
            liveCoverIndex: 3,
            liveHotCoverIndex: 4,
            liveTypeIndex: 5,
            liveCommerceIndex: 6,
            bottomButtonIndex: 7)
    }
}
