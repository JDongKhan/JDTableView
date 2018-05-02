//
//  UITableView+Simplify.m
//  JDCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import "UITableView+Simplify.h"
#import "UITableViewCell+Simplify.h"
#import "JDViewModel.h"
#import "JDTableView_marco_private.h"
#import "UITableView+Private.h"


#pragma mark  ----属性
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation UITableView (Simplify)
#pragma clang diagnostic pop

#pragma mark -----------------------------set方法----------------------------------

#pragma mark 构造数据集合  数据源
//selected
COPY_ASSOCIATION_METHOD(setJd_didSelectCellBlock, jd_didSelectCellBlock, JDDidSelectCellBlock, nil)

//height
COPY_ASSOCIATION_METHOD(setJd_cellHeightBlock, jd_cellHeightBlock, JDCellHeightBlock, nil)

- (void)setJd_viewModel:(JDViewModel *)jd_viewModel {
    objc_setAssociatedObject(self, @selector(jd_viewModel), jd_viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self jd_dynamicDelegate:jd_viewModel.delegate];
    [self jd_dynamicDataSource:jd_viewModel.dataSource];
}

- (JDViewModel *)jd_viewModel {
    return objc_getAssociatedObject(self, _cmd);
}

//header type
- (void)setJd_headerTypeBlock:(JDHeaderTypeBlock)jd_headerTypeBlock {
    objc_setAssociatedObject(self, @selector(jd_headerTypeBlock), jd_headerTypeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (JDHeaderTypeBlock)jd_headerTypeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

//cell type
COPY_ASSOCIATION_METHOD(setJd_cellTypeBlock, jd_cellTypeBlock, JDCellTypeBlock, nil)

//will load cell
COPY_ASSOCIATION_METHOD(setJd_willLoadCellBlock, jd_willLoadCellBlock, JDTableViewCellLoadBlock, nil)

//did load cell
COPY_ASSOCIATION_METHOD(setJd_didLoadCellBlock, jd_didLoadCellBlock, JDTableViewCellLoadBlock, nil)

//tableview的类型
INT_ASSOCIATION_METHOD(setJd_tableViewCellStyle,jd_tableViewCellStyle,UITableViewCellStyle)

//开启延迟取消选中的背景
BOOL_ASSOCIATION_METHOD(setJd_clearsSelectionDelay, jd_clearsSelectionDelay)

//是否支持高度缓存
BOOL_ASSOCIATION_METHOD(setJd_supportHeightCache, jd_supportHeightCache)


#pragma mark 注册cell
//注册 多个tableviewCell 传入是数组
- (void)setJd_tableViewCellArray:(NSArray *)tableViewCellArray {
    if (tableViewCellArray != nil) {
        objc_setAssociatedObject(self, @selector(jd_tableViewCellArray), tableViewCellArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
        for (NSInteger i = 0; i< tableViewCellArray.count; i++) {
            id cell = tableViewCellArray[i];
            //生成cellid
            NSString *cellID = jd_tableView_cellID(i);
            if ([cell isKindOfClass:[UINib class]]) {
                [self registerNib:cell forCellReuseIdentifier:cellID];
            } else {
                [self registerClass:cell forCellReuseIdentifier:cellID];
            }
        }
    }
}

- (NSArray *)jd_tableViewCellArray {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJd_tableViewHeaderViewArray:(NSArray *)jd_tableViewHeaderViewArray {
    if (jd_tableViewHeaderViewArray != nil) {
        objc_setAssociatedObject(self, @selector(jd_tableViewHeaderViewArray), jd_tableViewHeaderViewArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
        for (NSInteger i = 0; i< jd_tableViewHeaderViewArray.count; i++) {
            id headerView = jd_tableViewHeaderViewArray[i];
            //生成cellid
            NSString *headerID = jd_tableView_header_cellID(i);
            if ([headerView isKindOfClass:[UINib class]]) {
                [self registerNib:headerView forHeaderFooterViewReuseIdentifier:headerID];
            } else {
                [self registerClass:headerView forHeaderFooterViewReuseIdentifier:headerID];
            }
        }
    }
}

- (NSArray *)jd_tableViewHeaderViewArray {
    return objc_getAssociatedObject(self, _cmd);
}

@end


#pragma mark ----------------编辑能力------------
static const void *tableViewKeyForSingleLineDeleteAction = &tableViewKeyForSingleLineDeleteAction;
static const void *tableViewKeyForMultiLineDeleteAction = &tableViewKeyForMultiLineDeleteAction;

@implementation UITableView (Editable)

//editable
BOOL_ASSOCIATION_METHOD(setJd_editable, jd_editable)

- (void)setJd_singleLineDeleteAction:(JDSingleLineDeleteAction)singleLineDeleteAction {
    objc_setAssociatedObject(self, tableViewKeyForSingleLineDeleteAction, singleLineDeleteAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (singleLineDeleteAction != nil) {
        self.jd_editable = YES;
    } else {
        self.jd_editable = NO;
    }
}

- (JDSingleLineDeleteAction)jd_singleLineDeleteAction {
    return objc_getAssociatedObject(self, tableViewKeyForSingleLineDeleteAction);
}

- (void)setJd_multiLineDeleteAction:(JDMultiLineDeleteAction)multiLineDeleteAction {
    objc_setAssociatedObject(self, tableViewKeyForMultiLineDeleteAction,multiLineDeleteAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (multiLineDeleteAction != nil) {
        self.jd_editable = YES;
    } else {
        self.jd_editable = NO;
    }
}

- (JDMultiLineDeleteAction)jd_multiLineDeleteAction {
    return objc_getAssociatedObject(self, tableViewKeyForMultiLineDeleteAction);
}

//can editable
COPY_ASSOCIATION_METHOD(setJd_canEditable, jd_canEditable, JDCanEditable, nil)

//delete button title
COPY_ASSOCIATION_METHOD(setJd_deleteConfirmationButtonTitle, jd_deleteConfirmationButtonTitle, NSString *, nil)

- (void)jd_setMultiLineEditing:(BOOL)editing animated:(BOOL)animated {
    if (!editing) {
        NSArray *array = [self indexPathsForSelectedRows];
        if (self.jd_multiLineDeleteAction) {
            self.jd_multiLineDeleteAction(array);
        }
    }
    [self setEditing:editing animated:animated];
}

@end

