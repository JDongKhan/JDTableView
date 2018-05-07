//
//  UITableView+_Private.m
//  JD
//
//  Created by JD on 2017/9/16.
//  Copyright © 2017年 JD. All rights reserved.
//

#import "UITableView+Private.h"
#import "UITableView+JDExtension.h"
#import <objc/runtime.h>
#import "JDTableViewDelegate.h"
#import "JDTableViewDataSource.h"


NSString *const _cellID = @"tableViewCellID";

NSString *const _headerViewID = @"tableViewHeaderID";

NSString *jd_tableView_cellID(NSUInteger type) {
    return [_cellID stringByAppendingFormat:@"_%ld",(long)type];
}

NSString *jd_tableView_header_cellID(NSUInteger type) {
    return [_headerViewID stringByAppendingFormat:@"_%ld",(long)type];
}

@implementation UITableView (Private)

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

@end
