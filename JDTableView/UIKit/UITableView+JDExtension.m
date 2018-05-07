//
//  UITableView+JDExtension.m
//  JDCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import "UITableView+JDExtension.h"
#import "JDViewModel.h"
#import <objc/runtime.h>
#import "UITableView+Private.h"

@implementation UITableView (JDExtension)

- (void)setJd_delegate:(id<JDTableViewDelegate>)delegate {
    NSAssert(delegate, @"delegate为空");
    //动态的给viewModel里面的delegate和dataSource添加委托实现方法
    [self jd_dynamicDelegate:delegate];
}
- (id<JDTableViewDelegate>)jd_delegate {
    return self.delegate;
}

- (void)setJd_dataSource:(id<JDTableViewDataSource>)dataSource {
    NSAssert(dataSource, @"dataSource为空");
    [self jd_dynamicDataSource:dataSource];
}
- (id<JDTableViewDataSource>)jd_dataSource {
    return self.dataSource;
}

/**
 持有viewModel数据源
 */
- (void)setJd_viewModel:(JDViewModel *)jd_viewModel {
    objc_setAssociatedObject(self, @selector(jd_viewModel), jd_viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JDViewModel *)jd_viewModel {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark 注册cell

/**
 持有config配置表
 */
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

/**
 注册cell
 */
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

/**
 注册headerViewCell
 */
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

//获取indexPath对应的cell索引
- (NSUInteger)jd_typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger type = 0;
    if (self.jd_config.tableViewCellArray != nil) {
        id dataInfo = [self.jd_viewModel rowDataAtIndexPath:indexPath];
        //先取tableView的全局配置
        if (self.jd_config.cellTypeBlock) {
            type =  self.jd_config.cellTypeBlock(indexPath,dataInfo);
        }
        //如果section里面配置过，则以section配置为主
        id<JDSectionModelDataSource> sectionData =  [self.jd_viewModel sectionDataAtSection:indexPath.section];
        if ([sectionData respondsToSelector:@selector(cellTypeBlock)]) {
            JDCellTypeBlock cellTypeBlock = [sectionData cellTypeBlock];
            if (cellTypeBlock) {
                type =  cellTypeBlock(indexPath,dataInfo);
            }
        }
        //但是你不能超过cell的种类
        if (type >= self.jd_config.tableViewCellArray.count) {//如果得到的type大于数组的长度 则默认等于0位置的type
            type = 0;
        }
    }
    return type;
}

@end


#pragma mark ----------------编辑能力------------
@implementation UITableView (JDEditable)

/**
 修改设置多行编辑
 
 @param editing 是否编辑
 @param animated 是否有动画
 */
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

