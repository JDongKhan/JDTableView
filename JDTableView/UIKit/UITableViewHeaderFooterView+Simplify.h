//
//  UITableViewHeaderFooterView+Simplify.h
//
//  Created by JD on 2017/9/27.
//  Copyright © 2017年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewHeaderFooterView (Simplify)

- (CGFloat)jd_tableView:(UITableView *)tableView sectionInfo:(id)sectionInfo;

- (void)jd_render:(id)sectionInfo;

@end
