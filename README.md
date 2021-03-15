一般说,iOS界面的一些长列表,比如首页,活动页,长的会比较长,那么写起来总感觉没有那么优雅,那么如何才能做到优雅呢?
我在实践工作利用swift枚举的关联值和自定义组模型方法来实现了

- 下面是gif图效果
<img src="https://media.giphy.com/media/AYjXxGRE9USUXbA3N5/giphy.gif"  width = "414" alt="show" align=center />

- 下面是图片效果

<img src="https://upload-images.jianshu.io/upload_images/967836-7db882aab82cd1f5.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width = "414" alt="第一张" align=center />

<img src="https://upload-images.jianshu.io/upload_images/967836-ed24b86e6600c0fb.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width = "414" alt="第二张" align=center />

<img src="https://upload-images.jianshu.io/upload_images/967836-0a7c21751877332e.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width = "414" alt="第三张" align=center />

<img src="https://upload-images.jianshu.io/upload_images/967836-e101cdbbc01510af.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width = "414" alt="第四张" align=center />

可以看到,有些组是杂乱无章的排列着,而且运营那边要求,他们可以在后台自定义这些组的顺序
这可怎么办!🥺
下面看我的实现方式

# 定义一个组模型枚举,包含可能的定义,每个枚举关联当时组需要显示的数据模型,有可能是一个对象数组,也有可能是一个对象
``` swift
/// 新版首页组cell的类型
enum OriginGroupCellType {
    case marquee(list: [MarqueeModel]) // 跑马灯
    case beltAndRoad(list: [GlobalAdModel]) // 一带一路广告位
    case shoppingCarnival(list: [GlobalAdModel]) // 购物狂欢节
    case walletCard(smallWelfare: WelfareSmallResutlModel) // 钱包卡片
    case wallet(list: [HomeNavigationModel]) // 钱包cell
    case otc(list: [GlobalAdModel]) // OTC
    case hxPrefecture(list: [GlobalAdModel]) // HX商品专区
    case middleNav(list: [HomeNavigationModel]) // 中部导航
    case bottomNav(list: [HomeNavigationModel]) // 底部导航
//    case otherMall(list: [OriginOtherMallModel]) // 其它商家cell
//    case otherService(list: [OriginServiceModel]) // 其它服务cell
    case broadcast(topSale: HomeNavigationModel, hot: OriginBroadcastModel, choiceness: OriginBroadcastModel) // 直播cell
    case middleAd(list: [GlobalAdModel]) // 中间广告cell
    case localService(list: [LocalServiceModel]) // 本地服务cell
    case bottomFloat(headerList: [OriginBottomFloatHeaderModel]) // 底部悬停cell
}
```
- 考虑到要下拉刷新等问题,可以这些枚举都得遵守`Equatable`协议

``` swift
  extension OriginGroupCellType: Equatable {
    public static func == (lhs: OriginGroupCellType, rhs: OriginGroupCellType) -> Bool {
        switch (lhs, rhs) {
        case (.marquee, .marquee): return true
        case (.beltAndRoad, .beltAndRoad): return true
        case (.shoppingCarnival, .shoppingCarnival): return true
        case (.walletCard, .walletCard): return true
        case (.wallet, .wallet): return true
        case (.otc, .otc): return true
        case (.hxPrefecture, .hxPrefecture): return true
        case (.middleNav, .middleNav): return true
        case (.bottomNav, .bottomNav): return true
//        case (.otherMall, .otherMall): return true
//        case (.otherService, .otherService): return true
        case (.broadcast, .broadcast): return true
        case (.middleAd, .middleAd): return true
        case (.localService, .localService): return true
        case (.bottomFloat, .bottomFloat): return true
        default:
            return false
        }
    }
}
```
# 接下来就是组模型的定义,同时我抽取一个协议`GroupProvider`,方便利用
- GroupProvider
``` swift
protocol GroupProvider {
    /// 占位
    associatedtype GroupModel where GroupModel: Equatable
    
    /// 是否需要往组模型列表中添加当前组模型
    func isNeedAppend(with current: GroupModel, listMs: [GroupModel]) -> Bool
    /// 获取当前组模型在组模型列表的下标
    func index(with current: GroupModel, listMs: [GroupModel]) -> Int
}

extension GroupProvider {
    func isNeedAppend(with current: GroupModel, listMs: [GroupModel]) -> Bool {
        return !listMs.contains(current)
    }
    
    func index(with current: GroupModel, listMs: [GroupModel]) -> Int {
        return listMs.firstIndex(of: current) ?? 0
    }
}

```
- OriginGroupModel,同样也遵守`Equatable`协议,防止重复添加
```swift
func addTo(listMs: inout [OriginGroupModel]) 
```
- 这个方法是方便于下拉刷新时,替换最新数据所用

``` swift 
public struct OriginGroupModel: GroupProvider {
    typealias GroupModel = OriginGroupModel
    
    /// 组模型的类型
    var cellType: OriginGroupCellType
    /// 排序
    var sortIndex: Int

    /// 把groupModel添加或替换到listMs中
    func addTo(listMs: inout [OriginGroupModel]) {
        if isNeedAppend(with: self, listMs: listMs) {
            listMs.append(self)
        } else {
            let index = self.index(with: self, listMs: listMs)
            listMs[index] = self
        }
    }
}

extension OriginGroupModel: Equatable {
    public static func == (lhs: OriginGroupModel, rhs: OriginGroupModel) -> Bool {
        return lhs.cellType == rhs.cellType
    }
}
```
- 考虑要自定义顺序,所以需要定义一个排序的实体
``` swift
// MARK: - 新版首页组模型的排序规则模型
struct OriginGroupSortModel {
    /// 搜索历史的排序
    var marqueeIndex: Int
    var beltAndRoadIndex: Int
    var shoppingCarnivalIndex: Int
    var walletCardIndex: Int
    var walletIndex: Int
    var otcIndex: Int
    var hxPrefectureIndex: Int
    var middleNavIndex: Int
    var bottomNavIndex: Int
    var otherMallIndex: Int
    var otherServiceIndex: Int
    var broadcastIndex: Int
    var middleAdIndex: Int
    var localServiceIndex: Int
    var bottomFloatIndex: Int

    static var defaultSort: OriginGroupSortModel {
        return OriginGroupSortModel(
            marqueeIndex: 0,
            beltAndRoadIndex: 1,
            shoppingCarnivalIndex: 2,
            walletCardIndex: 3,
            walletIndex: 4,
            otcIndex: 5,
            hxPrefectureIndex: 6,
            middleNavIndex: 7,
            bottomNavIndex: 8,
            otherMallIndex: 9,
            otherServiceIndex: 10,
            broadcastIndex: 11,
            middleAdIndex: 12,
            localServiceIndex: 13,
            bottomFloatIndex: 99)
    }
}
```
# 控制器里定义一个 组模型数组, 这里有关键代码是 
``` swift 
listMs.sort(by: { return $0.sortIndex < $1.sortIndex }) 
```
- 所有的数据加载完毕后,会根据我们的自定义排序规则去排序

``` swift
/// 组模型数据
    public var listMs: [OriginGroupModel] = [] {
        didSet {
            listMs.sort(by: {
                return $0.sortIndex < $1.sortIndex
            })
            collectionView.reloadData()
        }
    }
    
    /// 组模型排序规则(可以由后台配置返回,在这里我们先给一个默认值)
    /// 需要做一个请求依赖,先请求排序接口,再请求各组的数据
    public lazy var sortModel: OriginGroupSortModel = OriginGroupSortModel.defaultSort
```

# 网络请求代码
``` swift 
func loadData(_ update: Bool = false, _ isUHead: Bool = false) {
        // 定义队列组
        let queue = DispatchQueue.init(label: "getOriginData")
        let group = DispatchGroup()
        
        // MARK: - 文字跑马灯
        group.enter()
        queue.async(group: group, execute: {
            HomeNetworkService.shared.getMarqueeList { [weak self] (state, message, data) in
                guard let `self` = self else { return }
                self.collectionView.uHead.endRefreshing()
                
                defer { group.leave() }
                let groupModel = OriginGroupModel(cellType: .marquee(list: data), sortIndex: self.sortModel.marqueeIndex)
                guard !data.isEmpty else { return }
                
                /// 把groupModel添加到listMs中
                groupModel.addTo(listMs: &self.listMs)
            }
        })
        
        /// .... 此处省略其它多个请求

        group.notify(queue: queue) {
            // 队列中线程全部结束,刷新UI
            DispatchQueue.main.sync { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
```
# 这时在控制里的一些collectionView的代理方法里,你就可以这样了,精准定准某块区域,例如
```swift
func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listMs.count
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let groupModel = listMs[section]
        switch groupModel.cellType {
        case .marquee, .beltAndRoad, .walletCard, .wallet, .otc, .hxPrefecture, .shoppingCarnival, .middleAd:
            return 1
        case .middleNav(let list):
            return list.count
        case .bottomNav(let list):
            return list.count
        case .broadcast:
            return 1
        case .localService(let list):
            return list.count
        case .bottomFloat:
            return 1
        }
    }
```
- 同理,collectionView的代理方法中,都是先拿到 cellType 来判断,达到精准定位, 举个`栗子`
``` swift
/// Cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let groupModel = listMs[indexPath.section]
        let width = screenWidth - 2 * margin
        switch groupModel.cellType {
        case .marquee:
            return CGSize(width: screenWidth, height: 32)
        case .beltAndRoad:
            return CGSize(width: width, height: 46)
        case .walletCard:
            return CGSize(width: width, height: 85)
        case .wallet:
            return CGSize(width: width, height: OriginWalletCell.eachHeight * 2 + 10)
        case .otc, .hxPrefecture:
            return CGSize(width: width, height: 60)
        case .middleNav:
            let row: CGFloat = 5
            let totalWidth: CGFloat = 13 * (row - 1) + 2 * margin
            return CGSize(width: (screenWidth - totalWidth) / row, height: CGFloat(98.zh(80).vi(108)))
        case .bottomNav:
            let isFirstRow: Bool = indexPath.item < 2
            let row: CGFloat = isFirstRow ? 2 : 3
            let totalWidth: CGFloat = 4 * (row - 1) + 2 * margin
            let width = (screenWidth - totalWidth) / row
            return CGSize(width: floor(Double(width)), height: 70)
        case .shoppingCarnival:
            return CGSize(width: width, height: 150)
        case .broadcast:
            return CGSize(width: screenWidth - 20, height: 114)
        case .middleAd:
            return CGSize(width: width, height: 114)
        case .localService:
            let width = (82 * screenWidth) / 375
            return CGSize(width: width, height: 110)
        case .bottomFloat:
            let h = bottomCellHeight > OriginBottomH ? bottomCellHeight : OriginBottomH
            return CGSize(width: screenWidth, height: h)
        }
    }
```
# 总结一下这种写法的优势
+ 方便修改组和组之前的顺序问题,甚至可以由服务器下发顺序

+ 方便删减组,只要把数据的添加组注释掉

+ 用枚举的方式,定义每个组,更清晰,加上swift的关联值优势,可以不用在控制器里定义多个数组

+ 考虑到要下拉刷新,所以抽取了一个协议 GroupProvider,里面提供两个默认的实现方法
方法一:获取当前cellType在listMs中的下标,方法二:是否要添加到listMs中

+ 界面长什么样,全部由数据来驱动,这组没有数据,界面就对应的不显示,有数据就按预先设计好的显示

# 源码地址
https://github.com/XYXiaoYuan/GroupModelTest