//
//  JDBaseRefreshManager.h
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 14/12/15.
//  Copyright © 2014年 王金东. All rights reserved.
//

typedef NS_ENUM(NSInteger,JDBlockFlags) {
    JDBlockFlagsHasCopyDispose = (1 << 25),
    JDBlockFlagsHasCtor = (1 << 26), // helpers have C++ code
    JDBlockFlagsIsGlobal = (1 << 28),
    JDBlockFlagsHasStret = (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    JDBlockFlagsHasSignature = (1 << 30)
};

#import <Foundation/Foundation.h>

@interface JDBlockDescription : NSObject

@property (nonatomic, readonly) JDBlockFlags flags;

@property (nonatomic, readonly) NSMethodSignature *blockSignature;

@property (nonatomic, readonly) unsigned long int size;

@property (nonatomic, readonly) id block;

- (id)initWithBlock:(id)block;

- (BOOL)isCompatibleForBlockSwizzlingWithMethodSignature:(NSMethodSignature *)methodSignature;

@end
