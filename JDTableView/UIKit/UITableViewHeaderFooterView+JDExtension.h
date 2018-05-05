//
//  UITableViewHeaderFooterView+JDExtension.h
//
//  Created by JD on 2017/9/27.
//  Copyright © 2017年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewHeaderFooterView (JDExtension)

/**
 框架调用此方法计算高度
 */
- (CGFloat)jd_tableView:(UITableView *)tableView sectionInfo:(id)sectionInfo;

/**
 view需要实现的方法
 框架调用此方法渲染
 */
- (void)jd_render:(id)sectionInfo;

@end

NS_ASSUME_NONNULL_END
