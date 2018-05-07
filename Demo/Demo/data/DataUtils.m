//
//  DataUtils.m
//  JianShuDemo
//
//  Created by 王金东 on 2016/7/18.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import "DataUtils.h"

@implementation DataUtils


+ (id)dataFromJsonFile:(NSString *)jsonFile {
    NSURL *url = [[NSBundle mainBundle] URLForResource:[jsonFile stringByDeletingPathExtension] withExtension:[jsonFile pathExtension]];
    NSError *error;
    id content =  [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:kNilOptions error:&error];
    return content;
}

@end
