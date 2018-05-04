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

@interface UITableView (JDExtension)

//数据源
@property (nonatomic, strong) JDViewModel *jd_viewModel;

/**
 配置
 */
@property (nonatomic, strong) JDTableViewConfig *jd_config;


@end



@interface UITableView (Editable)

- (void)jd_setMultiLineEditing:(BOOL)editing animated:(BOOL)animated;

@end

