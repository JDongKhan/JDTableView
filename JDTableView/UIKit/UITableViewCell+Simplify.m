//
//  UITableViewCell+Simplify.m
//  JDCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import "UITableViewCell+Simplify.h"
#import "JDTableView_marco_private.h"
#import <objc/runtime.h>
#import "JDSectionModel.h"

@implementation UITableViewCell (Simplify)

#pragma mark -----------------------------set方法----------------------------------

//indexPath
RETAIN_ASSOCIATION_METHOD(setJd_indexPath, jd_indexPath, NSIndexPath *)

//tableView
WEAK_ASSOCIATION_METHOD(setJd_tableView, jd_tableView, UITableView *)

//delegate
WEAK_ASSOCIATION_METHOD(setJd_delegate, jd_delegate, id)

#pragma mark ---------------------------------------------------------------------
- (CGFloat)jd_tableView:(UITableView *)tableView cellInfo:(id)dataInfo {
    return 44.0f;
}

- (void)jd_render:(id)dataInfo {
    if(dataInfo != nil){
        //渲染数据源
        if ([dataInfo isKindOfClass:[NSString class]]) {
            self.textLabel.text = dataInfo;
        } else if([dataInfo isKindOfClass:[JDRowModel class]]) {
            
            JDRowModel *rowData = dataInfo;
            // image
            id image = rowData.image;
            if ([image isKindOfClass:[NSString class]]) {
                self.imageView.image = [UIImage imageNamed:image];
            } else if([image isKindOfClass:[UIImage class]]) {
                self.imageView.image = image;
            } else {
                self.imageView.image = nil;
            }
            // title
            NSString *title = rowData.title;
            if (title.length > 0) {
                self.textLabel.text = title;
            } else {
                self.textLabel.text = nil;
            }
            // detail
            NSString *detail = rowData.detail;
            if (detail.length > 0) {
                self.detailTextLabel.text = detail;
            } else {
                self.detailTextLabel.text = nil;
            }
            //样式设置
            UIColor *titleColor = rowData.titleColor;
            UIFont *titleFont = rowData.titleFont;
            if (titleColor != nil) {
                self.textLabel.textColor = titleColor;
            }
            if (titleFont != nil) {
                self.textLabel.font = titleFont;
            }
            
            UIColor *detailColor = rowData.detailColor;
            UIFont *detailfont = rowData.detailFont;
            if (detailColor != nil) {
                self.detailTextLabel.textColor = detailColor;
            }
            if (detailfont != nil) {
                self.detailTextLabel.font = detailfont;
            }
            //accessoryType
            NSInteger type = rowData.accessoryType;
            if (type > 0) {
                self.accessoryType = type;
            }
            //accessortView
            UIView *view = rowData.accessoryView;
            self.accessoryView = view;
        }
    }
}

@end
