//
//  DemoTableViewCell2.m
//  Demo
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "DemoTableViewCell2.h"
#import <JDTableView/UITableViewCell+Simplify.h>

@implementation DemoTableViewCell2 {
    
    __weak IBOutlet UILabel *_testLabel;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)jd_render:(id)dataInfo {
    _testLabel.text = dataInfo[@"title"];
}

- (CGFloat)jd_tableView:(UITableView *)tableView cellInfo:(id)dataInfo {
    return 80;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
