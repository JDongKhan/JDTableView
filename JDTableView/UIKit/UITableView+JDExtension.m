//
//  UITableView+JDExtension.m
//  JDCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import "UITableView+JDExtension.h"
#import "UITableViewCell+JDExtension.h"
#import "JDViewModel.h"
#import "JDTableView_marco_private.h"
#import "UITableView+Private.h"
#import "JDTableViewConfig.h"

@implementation UITableView (JDExtension)

- (void)setJd_viewModel:(JDViewModel *)jd_viewModel {
    objc_setAssociatedObject(self, @selector(jd_viewModel), jd_viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self jd_dynamicDelegate:jd_viewModel.delegate];
    [self jd_dynamicDataSource:jd_viewModel.dataSource];
}

- (JDViewModel *)jd_viewModel {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark 注册cell
//注册 多个tableviewCell 传入是数组
- (void)setJd_config:(JDTableViewConfig *)config {
    if (config != nil) {
        objc_setAssociatedObject(self, @selector(jd_config), config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self registerCell:config];
        [self registerHeaderCell:config];
    }
}

- (JDTableViewConfig *)jd_config {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)registerCell:(JDTableViewConfig *)config {
    NSArray *array = config.tableViewCellArray;
    for (NSInteger i = 0; i < array.count; i++) {
        id cell = array[i];
        //生成cellid
        NSString *cellID = jd_tableView_cellID(i);
        if ([cell isKindOfClass:[UINib class]]) {
            [self registerNib:cell forCellReuseIdentifier:cellID];
        } else {
            [self registerClass:cell forCellReuseIdentifier:cellID];
        }
    }
}

- (void)registerHeaderCell:(JDTableViewConfig *)config {
    NSArray *array = config.tableViewHeaderViewArray;
    for (NSInteger i = 0; i < array.count; i++) {
        id headerView = array[i];
        //生成cellid
        NSString *headerID = jd_tableView_header_cellID(i);
        if ([headerView isKindOfClass:[UINib class]]) {
            [self registerNib:headerView forHeaderFooterViewReuseIdentifier:headerID];
        } else {
            [self registerClass:headerView forHeaderFooterViewReuseIdentifier:headerID];
        }
    }
}

@end


#pragma mark ----------------编辑能力------------
@implementation UITableView (Editable)

- (void)jd_setMultiLineEditing:(BOOL)editing animated:(BOOL)animated {
    if (!editing) {
        NSArray *array = [self indexPathsForSelectedRows];
        if (self.jd_config.multiLineDeleteAction) {
            self.jd_config.multiLineDeleteAction(array);
        }
    }
    [self setEditing:editing animated:animated];
}

@end

