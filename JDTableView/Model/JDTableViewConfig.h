//
//  JDTableViewConfig.h
//  JDAutoLayout
//
//  Created by JD on 2018/5/4.
//

#import <Foundation/Foundation.h>
#import "JDSectionModelDataSource.h"

// 可以将block放入到cell的数据源中 支持下面3种数据的任意组合
// void(^OnSelectedRowBlock)(NSIndexPath *indexPath,id data,UITableView *tableView);

NS_ASSUME_NONNULL_BEGIN

/**
 header type

 @param section 块数
 @param sectionInfo 块数据
 @return 数据对应的cell数组索引
 */
typedef NSInteger (^JDHeaderTypeBlock)(NSUInteger section, id sectionInfo) ;

/**
 计算行高

 @param indexPath 行数信息
 @param dataInfo 行数据
 @return 行高
 */
typedef CGFloat (^JDCellHeightBlock)(NSIndexPath *indexPath, id dataInfo) ;

/**
 cellForRowAtIndexPath  方法会调用该block

 @param cell cell
 @param indexPath 行数信息
 @param dataInfo 行数据
 */
typedef void (^JDTableViewCellLoadBlock)(UITableViewCell *cell,NSIndexPath *indexPath, id dataInfo) ;

#pragma mark ----------编辑功能---------------

/**
 单选行删除block

 @param indexPath 行数信息
 */
typedef void(^JDSingleLineDeleteAction) (NSIndexPath *indexPath);

/**
 多选行删除block

 @param indexPaths 行数信息
 */
typedef void(^JDMultiLineDeleteAction) (NSArray *indexPaths);

/**
 是否能删除block

 @param indexPath 行数信息
 @return 行对应的编辑能力，YES：能编辑，NO：不能编辑
 */
typedef BOOL(^JDCanEditable) (NSIndexPath *indexPath, id dataInfo);


@interface JDTableViewConfig : NSObject

/**
  cell的类名或xib组成的数组
 */
@property (nonatomic, strong) NSArray  *tableViewCellArray;

/**
  headerView的类名或xib组成的数组
 */
@property (nonatomic, strong) NSArray  *tableViewHeaderViewArray;

/**
  不传cell类型时，可通过设置cell的style来初始化cell
 */
@property (nonatomic, assign) UITableViewCellStyle tableViewCellStyle;

#pragma mark --------------- 对应事件 ---------------

/**
  didSelectRowAtIndexPath
 */
@property (nonatomic, copy) JDDidSelectCellBlock didSelectCellBlock;

/**
  计算行高
 */
@property (nonatomic, copy) JDCellHeightBlock cellHeightBlock;

/**
  数据源对应的header索引
 */
@property (nonatomic, copy) JDHeaderTypeBlock headerTypeBlock;


/**
  数据源对应的cell索引
 */
@property (nonatomic, copy) JDCellTypeBlock cellTypeBlock;


/**
 cellForRowAtIndexPath  方法会调用该block
 */
@property (nonatomic, copy) JDTableViewCellLoadBlock didLoadCellBlock;

/**
 cellForRowAtIndexPath  方法会调用该block
 */
@property (nonatomic, copy) JDTableViewCellLoadBlock willLoadCellBlock;

#pragma mark --------------- 其他功能 ---------------

/**
 是否支持高度缓存，在高度计算复杂、频繁等条件下 建议开启
 */
@property (nonatomic, assign) BOOL supportHeightCache;

/**
 延迟一会取消选中状态
 */
@property (nonatomic, assign) BOOL clearSelectionDelay;

#pragma mark --------------- 编辑 ---------------

/**
 是否处于编辑状态
 */
@property (nonatomic, assign, readonly) BOOL editable;

/**
  是否能编辑 block
 */
@property (nonatomic, assign) JDCanEditable canEditable;

/**
  删除按钮的标题
 */
@property (nonatomic, strong) NSString *deleteConfirmationButtonTitle;

/**
  开启多行删除block
 */
@property(nonatomic, copy) JDMultiLineDeleteAction multiLineDeleteAction;

/**
  开启单行删除block
 */
@property(nonatomic, copy) JDSingleLineDeleteAction singleLineDeleteAction;

@end

NS_ASSUME_NONNULL_END
