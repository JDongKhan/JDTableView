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
        self.contentView.backgroundColor = [UIColor redColor];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 175, 23)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:textLabel];
        _textLabel = textLabel;
    }
    return self;
}

- (void)jd_render:(JDSectionModel *)sectionInfo {
    if ([sectionInfo.sectionData isKindOfClass:[NSString class]]) {
        NSString *title = sectionInfo.sectionData;
        _textLabel.text = title;
    } else {
        _textLabel.text = sectionInfo.sectionData[@"title"];
    }
}

- (CGFloat)jd_tableView:(UITableView *)tableView sectionInfo:(id)sectionInfo {
    return 50;
}

@end
