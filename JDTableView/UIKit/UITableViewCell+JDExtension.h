//
//  UITableViewCell+JDExtension.h
//  JDCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (JDExtension)

/**
 行数信息
 */
@property (nonatomic,strong) NSIndexPath *jd_indexPath;

/**
 cell所在的tableview
 */
@property (nonatomic,weak) UITableView *jd_tableView;

/**
 tableView的委托类
 */
@property (nonatomic,weak) id jd_delegate;

/**
 cell需要实现的方法
 框架调用此方法渲染
 */
- (void)jd_render:(id)dataInfo;

/**
 框架调用此方法计算高度
 */
- (CGFloat)jd_tableView:(UITableView *)tableView cellInfo:(id)dataInfo;

@end

NS_ASSUME_NONNULL_END
