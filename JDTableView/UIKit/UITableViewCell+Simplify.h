//
//  UITableViewCell+Simplify.h
//  JDCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableViewCell (Simplify)

// 行数
@property (nonatomic,strong) NSIndexPath *jd_indexPath;

// 获取tableview
@property (nonatomic,weak) UITableView *jd_tableView;

//委托类
@property (nonatomic,weak) id jd_delegate;

// cell需要实现的方法
// 框架调用此方法渲染
- (void)jd_render:(id)dataInfo;

// 框架调用此方法计算高度
- (CGFloat)jd_tableView:(UITableView *)tableView cellInfo:(id)dataInfo;

@end
