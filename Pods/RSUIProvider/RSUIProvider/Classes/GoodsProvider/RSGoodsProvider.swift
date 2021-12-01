//
//  RSGoodsProvider.swift
//  RSUIProvider_Example
//
//  Created by 袁小荣 on 2020/7/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RSBaseConfig
import RSExtension

public protocol RSGoodsProvider: RSGoodsFanliProvider,
                                RSGoodsImageProvider,
                                RSGoodsNameProvider,
                                RSRMBLabelProvider,
                                RSOtherCoinProvider,
                                RSStoreProvider,
                                RSShopcarProvider {
    
}
