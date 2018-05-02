//
//  UITableView+Simplify.h
//  JDCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//
//
// 1)、数据源使用
// 1、先给self.itemsArray赋值 （如果你不想定制cell，想用系统的cell，那么不用再看2、3、4步骤）
// 2、设置tableViewCellClass，设置cell类
// 3、建立cell类，需要继承JDBaseTableViewCell
// 4、重写JDTableViewCell的dataInfo的set方法 ，传递过去的数据源可以用于渲染视图
// 5、也可自己实现其他delegate事件，比如点击行

// 以上是基本使用步骤

// 设置多种cell步骤
// 1、先给self.itemsArray赋值
// 2、建立cell类，需要继承JDBaseTableViewCell
// 3、设置self.tableViewCellArray 数组可以是Class 也可以是UInib类
// 4、实现 - (NSUInteger)tableView:(UITableView *)tableView typeForRowAtIndexPath:(NSIndexPath *)indexPath; 返回值是self.tableViewCellArray的索引
// 5、实现 - (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath;
//  可设置cell的AccessoryType
//

// 通过设置self.sectionIndexTitles 可定制右侧索引
//
// 如果你想自定义行 完全可以按照系统默认的写法 ，注意使用self.itemsArray当做数据源即可
// 具体的一些设置参数可以查看下面的头文件中变量的定义

// 其他步骤于上面一样
// 注意如果是数组里面不是NSArray类（比如是NSDictionary ，则我们将NSDictionary中的items字段取出来作为第二级数据）这个key也可以自定义 参看keyOfItemArray的注释

//2)、 下拉刷新\上拉加载
// 开启下拉刷新 参照<JDTableViewRefreshDelegate> 协议
// self.refreshHeaderable = YES; 实现headerRereshing即可
// 开启上拉加载
// self.refreshFooterable = YES; 实现footerRereshing即可
// 刷新完调用  [super didLoaded:JDRefreshTableViewHeader];
//

// 3)、查询功能
// self.searchable = YES;即可开启查询
// 可通过设置searchTableViewCellClass来定制查询界面的cell 步奏同 1）
// 不设置则默认和tableViewCellClass一样
//
// 4)、编辑删除功能
// 多行编辑 self.multiLineDeleteAction = ^(NSArray *indexPaths){}
// 单行编辑 self.singleLineDeleteAction = ^(NSIndexPath *indexPath){}:



#import <UIKit/UIKit.h>
#import "JDSectionModelDataSource.h"

// 可以将block放入到cell的数据源中 支持下面3种数据的任意组合
// void(^OnSelectedRowBlock)(NSIndexPath *indexPath,id data,UITableView *tableView);

//header type
typedef NSInteger (^JDHeaderTypeBlock)(NSUInteger section, id sectionInfo) ;
// 计算行高
typedef CGFloat (^JDCellHeightBlock)(NSIndexPath *indexPath, id dataInfo) ;
// cellForRowAtIndexPath  方法会调用该block
typedef void (^JDTableViewCellLoadBlock)(UITableViewCell *cell,NSIndexPath *indexPath, id dataInfo) ;

@class JDViewModel;

@interface UITableView (Simplify)

// cel的类名或xib'名称组成的数组
@property (nonatomic, strong) NSArray  *jd_tableViewCellArray;

@property (nonatomic, strong) NSArray  *jd_tableViewHeaderViewArray;

// 不传cell类型时，可通过设置cell的style来初始化cell
@property (nonatomic, assign) UITableViewCellStyle jd_tableViewCellStyle;

//数据源
@property (nonatomic, strong) JDViewModel *jd_viewModel;

#pragma mark --------------- 对应事件 ---------------

// didSelectRowAtIndexPath
@property (nonatomic, copy) JDDidSelectCellBlock jd_didSelectCellBlock;

// 计算行高
@property (nonatomic, copy) JDCellHeightBlock jd_cellHeightBlock;

// 数据源对应的header索引
@property (nonatomic, copy) JDHeaderTypeBlock jd_headerTypeBlock;

// 数据源对应的cell索引
@property (nonatomic, copy) JDCellTypeBlock jd_cellTypeBlock;

// cellForRowAtIndexPath  方法会调用该block
@property (nonatomic, copy) JDTableViewCellLoadBlock jd_didLoadCellBlock;

@property (nonatomic, copy) JDTableViewCellLoadBlock jd_willLoadCellBlock;

#pragma mark --------------- 其他功能 ---------------
//是否支持高度缓存，在高度计算复杂、频繁等条件下 建议开启
@property (nonatomic, assign) BOOL jd_supportHeightCache;

// 延迟一会取消选中状态
@property (nonatomic, assign) BOOL jd_clearsSelectionDelay;

@end

#pragma mark ----------编辑功能---------------

// 单选行删除 block
typedef void(^JDSingleLineDeleteAction) (NSIndexPath *indexPath);
// 多选行删除 block
typedef void(^JDMultiLineDeleteAction) (NSArray *indexPaths);
// 是否能删除 block
typedef BOOL(^JDCanEditable) (NSIndexPath *indexPath);

@interface UITableView (Editable)

//是否处于编辑状态
@property (nonatomic, assign, readonly) BOOL jd_editable;

//是否能编辑 block
@property (nonatomic, assign) JDCanEditable jd_canEditable;

//删除按钮的标题
@property (nonatomic, strong) NSString *jd_deleteConfirmationButtonTitle;

// 开启多行删除block
@property(nonatomic, copy) JDMultiLineDeleteAction jd_multiLineDeleteAction;

// 开启单行删除block
@property(nonatomic, copy) JDSingleLineDeleteAction jd_singleLineDeleteAction;

- (void)jd_setMultiLineEditing:(BOOL)editing animated:(BOOL)animated;

@end

