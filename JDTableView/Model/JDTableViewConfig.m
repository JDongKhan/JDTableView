//
//  JDTableViewConfig.m
//  JDAutoLayout
//
//  Created by JD on 2018/5/4.
//

#import "JDTableViewConfig.h"

@implementation JDTableViewConfig

- (void)setSingleLineDeleteAction:(JDSingleLineDeleteAction)singleLineDeleteAction {
    _singleLineDeleteAction = singleLineDeleteAction;
    if (singleLineDeleteAction != nil) {
        _editable = YES;
    } else {
        _editable = NO;
    }
}

- (void)setMultiLineDeleteAction:(JDMultiLineDeleteAction)multiLineDeleteAction {
    _multiLineDeleteAction = multiLineDeleteAction;
    if (multiLineDeleteAction != nil) {
        _editable = YES;
    } else {
        _editable = NO;
    }
}



@end
