//
//  UITableView+JDExtension.h
//  JDCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//
//
#import <UIKit/UIKit.h>
#import "JDTableViewConfig.h"
#import "JDViewModel.h"
#import "JDTableViewDataSource.h"
#import "JDTableViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (JDExtension)

/**
 委托类
 */
@property (nonatomic, weak) id<JDTableViewDelegate> jd_delegate;

/**
 数据源
 */
@property (nonatomic, weak) id<JDTableViewDataSource> jd_dataSource;

/**
 数据源加工厂
 */
@property (nonatomic, strong) JDViewModel *jd_viewModel;

/**
 配置类
 */
@property (nonatomic, strong) JDTableViewConfig *jd_config;

/**
 根据indexPath获取type
 */
- (NSUInteger)jd_typeForRowAtIndexPath:(NSIndexPath *)indexPath;


@end


@interface UITableView (JDEditable)

/**
 修改设置多行编辑

 @param editing 是否编辑
 @param animated 是否有动画
 */
- (void)jd_setMultiLineEditing:(BOOL)editing animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

