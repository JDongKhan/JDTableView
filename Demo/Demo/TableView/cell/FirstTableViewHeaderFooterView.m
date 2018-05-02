//
//  FirstTableViewHeaderFooterView.m
//  Demo
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "FirstTableViewHeaderFooterView.h"
#import <JDTableView/JDSectionModel.h>

@implementation FirstTableViewHeaderFooterView {
    UILabel *_textLabel;
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (nil != self) {
        self.contentView.backgroundColor = [UIColor grayColor];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 175, 23)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:textLabel];
        _textLabel = textLabel;
    }
    return self;
}

- (void)jd_render:(JDSectionModel *)sectionInfo {
    NSString *title = sectionInfo.sectionData;
    _textLabel.text = title;
}

- (CGFloat)jd_tableView:(UITableView *)tableView sectionInfo:(id)sectionInfo {
    return 50;
}

@end
