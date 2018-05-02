//
//  UITableView+_Private.m
//  JD
//
//  Created by JD on 2017/9/16.
//  Copyright © 2017年 JD. All rights reserved.
//

#import "UITableView+Private.h"
#import "JDTableView_marco_private.h"
#import "UITableView+Simplify.h"
#import "JDViewModel.h"
#import <objc/runtime.h>
#import "JDTableViewDelegate.h"
#import "JDTableViewDataSource.h"


NSString *const _cellID = @"tableViewCellID";

NSString *const _headerViewID = @"tableViewHeaderID";

NSString *jd_tableView_cellID(NSUInteger type) {
    return [_cellID stringByAppendingFormat:@"_%ld",(long)type];
}

NSString *jd_tableView_header_cellID(NSUInteger type) {
    return [_cellID stringByAppendingFormat:@"_%ld",(long)type];
}

@implementation UITableView (Private)

//获取indexPath对应的cell索引
- (NSUInteger)typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger type = 0;
    if (self.jd_tableViewCellArray != nil) {
        id dataInfo = [self.jd_viewModel rowDataAtIndexPath:indexPath];
        //先取tableView的全局配置
        if (self.jd_cellTypeBlock) {
            type =  self.jd_cellTypeBlock(indexPath,dataInfo);
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
        if (type >= self.jd_tableViewCellArray.count) {//如果得到的type大于数组的长度 则默认等于0位置的type
            type = 0;
        }
    }
    return type;
}

- (void)jd_dynamic:(id)delegate {
    [self jd_dynamicDelegate:delegate];
    [self jd_dynamicDataSource:delegate];
}

- (void)jd_dynamicDelegate:(id)delegate {
    [self impDelegate:delegate];
    self.delegate = delegate;
}

- (void)jd_dynamicDataSource:(id)dataSource {
    [self impDataSource:dataSource];
    self.dataSource = dataSource;
}

- (void)impDataSource:(id)dataSource {
    if (dataSource == nil) {
        return;
    }
    //因调用频率较低固可以用此种简单的加锁方式
    SEL selectors[] = {
        @selector(tableView:cellForRowAtIndexPath:),
        @selector(numberOfSectionsInTableView:),
        @selector(tableView:numberOfRowsInSection:),
        @selector(tableView:titleForHeaderInSection:),
        /***************************************************/
        @selector(sectionIndexTitlesForTableView:),
        /*************************edit**************************/
        @selector(tableView:canEditRowAtIndexPath:),
        @selector(tableView:commitEditingStyle:forRowAtIndexPath:),
        @selector(tableView:canMoveRowAtIndexPath:)
    };
    tableView_addMethod(selectors,sizeof(selectors)/sizeof(SEL), [dataSource class],[JDTableViewDataSource class]);
}

- (void)impDelegate:(id)delegate {
    if (delegate == nil) {
        return;
    }
    SEL selectors[] = {
        @selector(tableView:heightForRowAtIndexPath:),
        @selector(tableView:willDisplayCell:forRowAtIndexPath:),
        @selector(tableView:didSelectRowAtIndexPath:),
        
        @selector(tableView:viewForHeaderInSection:),
        @selector(tableView:willDisplayHeaderView:forSection:),
        @selector(tableView:heightForHeaderInSection:),
        /*************************edit**************************/
        @selector(tableView:editingStyleForRowAtIndexPath:),
        @selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:),
    };
    //如果你设置了rowHeight，则不需要我们来处理heightForRowAtIndexPath，当然你需要在setDelegate之前设置rowHeight，否则我们当做没看到
    if (self.rowHeight > 0) {
        selectors[0] = NULL;
    }
    tableView_addMethod(selectors,sizeof(selectors)/sizeof(SEL), [delegate class],[JDTableViewDelegate class]);
}

void tableView_addMethod(SEL *selectors,int count, Class toClass, Class impClass){
    //因调用频率较低固可以用此种简单的加锁方式
    @synchronized (toClass) {
        Class kClass = [toClass class];
        Class dClass = impClass;
        
        for (NSUInteger index = 0; index < count; index++) {
            SEL originalSelector = selectors[index];
            if (originalSelector == NULL) {
                continue;
            }
            IMP originalImp = class_getMethodImplementation(kClass, originalSelector);
            IMP realImp = class_getMethodImplementation(dClass, originalSelector);
            if (originalImp != realImp) {
                Method method = class_getInstanceMethod(dClass, originalSelector);
                const char *type =  method_getTypeEncoding(method);
                //如果有方法了 add会失败的，add失败说明由你来处理喽
                class_addMethod(kClass, originalSelector, realImp,type);
            }
            
        }
    }
}

@end
