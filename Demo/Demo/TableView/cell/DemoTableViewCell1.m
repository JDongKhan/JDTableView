//
//  DemoTableViewCell1.m
//  Demo
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "DemoTableViewCell1.h"
#import <JDTableView/UITableViewCell+JDExtension.h>

@implementation DemoTableViewCell1 {
    
    __weak IBOutlet UILabel *_testDetailLabel;
    __weak IBOutlet UILabel *_authorLabel;
    __weak IBOutlet UILabel *_secondLabel;
    __weak IBOutlet UILabel *_testLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)jd_render:(id)dataInfo {
    _testLabel.text = dataInfo[@"title"];
    _secondLabel.text = dataInfo[@"secondTitle"];
    _authorLabel.text = dataInfo[@"author"];
    _testDetailLabel.text = dataInfo[@"detail"];
}

- (CGFloat)jd_tableView:(UITableView *)tableView cellInfo:(id)dataInfo {
    CGFloat height = [self sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(self.contentView.bounds.size.width-20, MAXFLOAT) string:dataInfo[@"detail"]].height;
    return 65 + height + 15;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string {
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
