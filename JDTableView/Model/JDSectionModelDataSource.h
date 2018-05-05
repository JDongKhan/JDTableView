//
//  JDSectionModelDataSource.h
//
//  Created by JD on 2016/9/15.
//  Copyright © 2016年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>


//cell type
typedef NSInteger (^JDCellTypeBlock)(NSIndexPath *indexPath, id dataInfo) ;

// didSelectRowAtIndexPath
typedef void    (^JDDidSelectCellBlock)(NSIndexPath *indexPath, id dataInfo) ;


@protocol JDSectionModelDataSource <NSObject>

@required
- (NSArray *)itemArray;

@optional
- (NSString *)title;

@optional
// 数据源对应的cell索引
@property(nonatomic, copy) JDCellTypeBlock cellTypeBlock;
// didSelectRowAtIndexPath
@property(nonatomic, copy) JDDidSelectCellBlock didSelectCellBlock;

@end
