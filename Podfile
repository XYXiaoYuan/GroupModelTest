platform :ios, '10.0'

source 'https://github.com/XYXiaoYuan/RSSpecs.git'

def thirdPartyPods
    pod 'SnapKit', '~> 5.0.0'
    pod 'Toast', '~> 4.0.0'
    pod 'IQKeyboardManagerSwift', '6.3.0'
    pod 'SVProgressHUD', '2.2'
    pod 'Kingfisher', '5.14.1'
    pod 'JXSegmentedView', '1.2.7'
    pod 'JXPagingView/Paging', '2.1.0'
    pod 'MJRefresh', '3.2.0'
    pod 'EmptyDataSet-Swift', '~> 5.0.0'
    pod 'SDCycleScrollView','1.82'
    pod 'LookinServer', '1.0.4', :configurations => ['Debug']
end

def rsSpecs
  pod 'RSBaseConfig', '0.0.9'
  pod 'RSExtension', '0.1.0'
  pod 'AlertViewComponent', '0.1.0'
  pod 'SwipeTransition'
  pod 'BaseViewController', '0.1.3'
  pod 'RSUIProvider', '0.0.3'
  pod 'GoodsRankMenuView', '0.0.7'
  pod 'NetworkingComponent', '1.2.2'
end


# 正式工程
target 'GroupModelTest' do
	use_frameworks!
  
  #第三方库
  thirdPartyPods
  
  #远程私有库
  rsSpecs
end

