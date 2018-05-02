//
//  JDTableViewDelegate.m
//  JDTableView
//
//  Created by 王金东 on 2016/8/3.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import "JDTableViewDelegate.h"
#import "JDBlockDescription.h"
#import "UITableViewCell+Simplify.h"
#import "JDViewModel.h"
#import <objc/runtime.h>
#import "UITableView+Private.h"
#import "UITableView+Simplify.h"
#import "UITableViewHeaderFooterView+Simplify.h"

@implementation JDTableViewDelegate

+ (void)deselect:(UITableView *)tableView{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id dataInfo = [tableView.jd_viewModel rowDataAtIndexPath:indexPath];
    if (tableView.jd_willLoadCellBlock) {
        tableView.jd_willLoadCellBlock(cell,indexPath,dataInfo);
    }
    //我来帮你处理数据
    [cell jd_render:dataInfo];
    //给你一次自己处理的机会
    if (tableView.jd_didLoadCellBlock) {
        tableView.jd_didLoadCellBlock(cell,indexPath,dataInfo);
    }
}

//选中cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击过去就会帮你取消点击后的效果
    if (tableView.jd_clearsSelectionDelay) {
        [JDTableViewDelegate performSelector:@selector(deselect:) withObject:tableView afterDelay:0.5f];
    }
    id dataInfo = [tableView.jd_viewModel rowDataAtIndexPath:indexPath];
    //好吧，你最大，你先处理
    if (tableView.jd_didSelectCellBlock) {
        tableView.jd_didSelectCellBlock(indexPath,dataInfo);
    } else {
        //还是以NSDictionary为主来分析，其它model情况太复杂
        id selectBlock = nil;
        id sectionInfo = [tableView.jd_viewModel sectionDataAtSection:indexPath.section];
        if ([sectionInfo conformsToProtocol:@protocol(JDSectionModelDataSource)]) {
            id<JDSectionModelDataSource> model = sectionInfo;
            if([model respondsToSelector:@selector(jd_didSelectCellBlock)]){
                selectBlock =  [model didSelectCellBlock];
            }
        }
        if (selectBlock != nil) {
            //开始分析block的参数，你可随意设置1个或更多的参数，我来动态处理你的参数
            //不过不能超出[indexPath,tableView,dataInfo]的范围，因为我还在成长
            // allocating a block description
            JDBlockDescription *blockDescription = [[JDBlockDescription alloc] initWithBlock:selectBlock];
            // getting a method signature for this block
            NSMethodSignature *methodSignature = blockDescription.blockSignature;
            NSInteger cout = methodSignature.numberOfArguments;
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setTarget:[selectBlock copy]];
            //NSArray *arguments = @[indexPath,tableView,dataInfo];
            for (NSInteger i = 1; i < cout; i++) {
                const char *type = [methodSignature getArgumentTypeAtIndex:i];
                NSString *typeName = [NSString stringWithUTF8String:type];
                void *arg = &dataInfo;
                if([typeName isEqualToString:@"@\"NSIndexPath\""]){
                    arg = &indexPath;
                }else if([typeName isEqualToString:@"@\"UITableView\""]){
                    arg = &tableView;
                }
                [invocation setArgument:arg atIndex:i];
            }
            [invocation invoke];
        }
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id dataInfo = [tableView.jd_viewModel rowDataAtIndexPath:indexPath];
    //NSLog(@"计算第%d块，第%d行行高",indexPath.section,indexPath.row);
    //自己计算高度
    if (tableView.jd_cellHeightBlock) {
        return tableView.jd_cellHeightBlock(indexPath,dataInfo);
    } else {
        //将计算高度的方法交给cell来处理，cell来做，毕竟cell的高度cell来做不是应该的吗？ 顺便也瘦了vc的身，
        UITableViewCell *cell = nil;
        //JDLog(@"渲染第%d块，第%d行",indexPath.section,indexPath.row);
        //生成cellid
        NSUInteger type = [tableView typeForRowAtIndexPath:indexPath];
        NSString *cellID = jd_tableView_cellID(type);
        cell = [JDTableViewDelegate tableView:tableView templateCellForReuseIdentifier:cellID delegate:tableView.delegate];
        if (cell != nil) {
            cell.jd_indexPath = indexPath;
            //我是来判断是否缓存了高度
            //缓存用的是UITableView+UITableView+FDIndexPathHeightCache,
            //当然感谢作者帮我们做了这个，不然还要自己写缓存 /(ㄒoㄒ)/~~
//            if (tableView.jd_supportHeightCache && [tableView.indexPathHeightCache existsHeightAtIndexPath:indexPath]) {
//                return [tableView.indexPathHeightCache heightForIndexPath:indexPath];
//            }
            //给cell的dataInfo赋值,并计算高度
            CGFloat height =  [cell jd_tableView:tableView cellInfo:dataInfo];
//            if (tableView.jd_supportHeightCache) {
//                [tableView.indexPathHeightCache cacheHeight:height byIndexPath:indexPath];
//            }
            return height;
        }
    }
    //默认44应该不难理解吧
    return 44.0f;
}


//header view
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<JDSectionModelDataSource> sectionInfo = [tableView.jd_viewModel sectionDataAtSection:section];
    CGFloat height = 0.0001;
    
    if ([sectionInfo respondsToSelector:@selector(title)]) {
        NSString *title = [sectionInfo title];
        if (title.length > 0) {
            height = 44.0f;
        }
    }
    
    NSInteger type = -1;
    if (tableView.jd_headerTypeBlock) {
        type = tableView.jd_headerTypeBlock(section,sectionInfo);
    }
    if (type >= 0) {
        NSString *headerID = jd_tableView_header_cellID(type);
        UITableViewHeaderFooterView *headerView = [JDTableViewDelegate tableView:tableView templateHeaderViewForReuseIdentifier:headerID delegate:tableView.delegate];
        height = [headerView jd_tableView:tableView sectionInfo:sectionInfo];
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id sectionInfo = [tableView.jd_viewModel sectionDataAtSection:section];
    NSInteger type = -1;
    if (tableView.jd_headerTypeBlock) {
        type = tableView.jd_headerTypeBlock(section,sectionInfo);
    }
    if (type >= 0) {
        NSString *headerID = jd_tableView_header_cellID(type);
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UITableViewHeaderFooterView *)view forSection:(NSInteger)section {
    id sectionInfo = [tableView.jd_viewModel sectionDataAtSection:section];
    [view jd_render:sectionInfo];
}


//根据identifier获取临时tableviewcell用于临时计算
+ (__kindof UITableViewCell *)tableView:(UITableView *)tableView
         templateCellForReuseIdentifier:(NSString *)identifier
                               delegate:(id)delegate {
    NSAssert(identifier.length > 0, @"identifier:%@ is empty", identifier);
    
    NSMutableDictionary<NSString *, UITableViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(delegate, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(delegate, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewCell *templateCell = templateCellsByIdentifiers[identifier];
    [templateCell prepareForReuse];//放回重用池
    if (!templateCell) {
        templateCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (templateCell) {
            templateCellsByIdentifiers[identifier] = templateCell;
        }
    }
    return templateCell;
}


//根据identifier获取临时tableviewcell用于临时计算
+ (__kindof UITableViewHeaderFooterView *)tableView:(UITableView *)tableView
         templateHeaderViewForReuseIdentifier:(NSString *)identifier
                               delegate:(id)delegate {
    NSAssert(identifier.length > 0, @"identifier:%@ is empty", identifier);
    
    NSMutableDictionary<NSString *, UITableViewHeaderFooterView *> *templateHeaderViewByIdentifiers = objc_getAssociatedObject(delegate, _cmd);
    if (!templateHeaderViewByIdentifiers) {
        templateHeaderViewByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(delegate, _cmd, templateHeaderViewByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewHeaderFooterView *templateHeaderView = templateHeaderViewByIdentifiers[identifier];
    [templateHeaderView prepareForReuse];//放回重用池
    if (!templateHeaderView) {
        templateHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (templateHeaderView) {
            templateHeaderViewByIdentifiers[identifier] = templateHeaderView;
        }
    }
    return templateHeaderView;
}


#pragma mark ------------------edit------------------
//编缉按扭样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置删除多行
    if (tableView.jd_multiLineDeleteAction != nil) {
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    //那个删除的text你不高兴可以自己来设置
    if (tableView.jd_deleteConfirmationButtonTitle != nil) {
        return tableView.jd_deleteConfirmationButtonTitle;
    }
    return @"删除";
}



@end
