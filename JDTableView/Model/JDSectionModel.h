//
//  JDSectionModel.h
//
//  Created by JD on 2016/9/15.
//  Copyright © 2016年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDSectionModelDataSource.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDSectionModel : NSObject <JDSectionModelDataSource>

/**
 section的title
 */
@property (nonatomic, copy) NSString *title;

/**
 用于存放section数据
 */
@property (nonatomic, strong) id sectionData;

/**
 用于存放rows数据
 */
@property (nonatomic, copy) NSArray *dataArray;

/**
 添加行数据

 @param rowData 一行的数据
 */
- (void)addRowData:(id)rowData;

/**
 添加多行数据

 @param rowDatas 多行数据
 */
- (void)addRowDatasFromArray:(NSArray *)rowDatas;

/**
 移除所有行数据
 */
- (void)removeAllDatas;

@end



#pragma mark  ----------------rowData-----------

/**
 提供的默认RowModel，一般用于设置、用户信息等本地界面
 */
@interface JDRowModel : NSObject

/**
 the key of  image
 */
@property (nonatomic, strong) id image;

/**
 the key of  title
 */
@property (nonatomic, copy) NSString *title;

/**
 the key of  detail
 */
@property (nonatomic, copy) NSString *detail;

/**
  the key of accessoryType
 */
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

/**
  the key of accessoryView
 */
@property (nonatomic, strong) UIView *accessoryView;

/******** 样式设置key ********/
/**
 the key of title color
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
  the key of title font
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
  the key of detail color
 */
@property (nonatomic, strong) UIColor *detailColor;

/**
  the key of detail font
 */
@property (nonatomic, strong) UIFont *detailFont;

@end


NS_ASSUME_NONNULL_END
