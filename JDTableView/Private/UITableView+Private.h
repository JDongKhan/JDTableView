//
//  UITableView+_Private.h
//  JD
//
//  Created by JD on 2017/9/16.
//  Copyright © 2017年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *jd_tableView_cellID(NSUInteger type);
extern NSString *jd_tableView_header_cellID(NSUInteger type);

@interface UITableView (Private)

/**
  根据indexPath获取type
 */
- (NSUInteger)typeForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
  动态实现delegate和source
 */
- (void)jd_dynamic:(id)delegate;

/**
 动态实现delegate

 @param delegate 委托
 */
- (void)jd_dynamicDelegate:(id)delegate;

/**
 动态实现datasource

 @param dataSource 数据源
 */
- (void)jd_dynamicDataSource:(id)dataSource;


@end
