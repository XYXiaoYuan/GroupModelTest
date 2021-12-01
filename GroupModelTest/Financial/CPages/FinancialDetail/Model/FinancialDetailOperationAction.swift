//
//  FinancialDetailOperationAction.swift
//  Pandamine_iOS
//
//  Created by 袁小荣 on 2021/2/6.
//  Copyright © 2021 cfans. All rights reserved.
//

import Foundation

enum FinancialDetailOperationAction: CaseIterable, Equatable {
    case transactionDetail      /// 活期-交易明细
    case deposit                /// 活期-存入
    case currentTakeOut         /// 活期-取出
    case investAgain            /// 定期-再投资一笔
    case fixTakeOut             /// 定期-取出
}

/// TODO:定期取出按钮的状态,要传入一个时间来判断,文字颜色和背景颜色
extension FinancialDetailOperationAction {
    var title: String {
        switch self {
        case .transactionDetail:
            return "交易明细".localized
        case .deposit:
            return "存入".localized
        case .currentTakeOut:
            return "取出".localized
        case .investAgain:
            return "再投资一笔".localized
        case .fixTakeOut:
            return "取出"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .fixTakeOut:
            return UIColor.white.withAlphaComponent(0.5)
        default:
            return .white
        }
    }
    
    /// 渐变色背景色
    var gradientColor: GradientProvide {
        switch self {
        case .fixTakeOut:
            return Gradient(starColor: HexAColor(hex: 0x053AC2, alpha: 0.5).uiColor, endColor: HexAColor(hex: 0x2295ED, alpha: 0.5).uiColor, direction: .horizontal(true))
        default:
            return Gradient(starColor: 0x053AC2.uiColor, endColor: 0x2295ED.uiColor, direction: .horizontal(true))
        }
    }
}
