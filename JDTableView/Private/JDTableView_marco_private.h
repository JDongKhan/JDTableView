//
//  JDTableView_marco_private.h
//  JD
//
//  Created by JD on 2017/9/2.
//  Copyright © 2017年 JD. All rights reserved.
//

#ifndef JDTableView_marco_private_h
#define JDTableView_marco_private_h
#import <objc/runtime.h>

#define RETAIN_ASSOCIATION_METHOD(_set,_get,_type) \
- (void)_set:(_type)value { \
    objc_setAssociatedObject(self, @selector(_get), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
} \
- (_type)_get { \
    return  objc_getAssociatedObject(self, _cmd); \
} \


#define COPY_ASSOCIATION_METHOD(_set,_get,_type,_defaultValue) \
- (void)_set:(_type)value { \
    objc_setAssociatedObject(self, @selector(_get), value, OBJC_ASSOCIATION_COPY_NONATOMIC); \
} \
- (_type)_get { \
    _type t =  objc_getAssociatedObject(self, _cmd); \
    if(t == nil){\
        t = _defaultValue; \
    } \
    return t;\
} \

#define WEAK_ASSOCIATION_METHOD(_set,_get,_type) \
- (void)_set:(_type)value { \
    __weak id weakObject = value; \
    objc_setAssociatedObject(self, @selector(_get),^{ \
        return weakObject; \
    }, OBJC_ASSOCIATION_COPY_NONATOMIC); \
} \
- (_type)_get { \
    id(^block)(void) =  objc_getAssociatedObject(self, _cmd);\
    if (block) {\
        return block();\
    }\
    return nil;\
} \


#define BOOL_ASSOCIATION_METHOD(_set,_get) \
- (void)_set:(BOOL)value { \
    objc_setAssociatedObject(self, @selector(_get), @(value), OBJC_ASSOCIATION_COPY_NONATOMIC); \
} \
- (BOOL)_get { \
    return  [objc_getAssociatedObject(self, _cmd) boolValue]; \
} \


#define INT_ASSOCIATION_METHOD(_set,_get,_type) \
- (void)_set:(_type)value { \
    objc_setAssociatedObject(self,@selector(_get), @(value), OBJC_ASSOCIATION_COPY_NONATOMIC); \
} \
- (_type)_get { \
    return  [objc_getAssociatedObject(self, _cmd) integerValue]; \
} \

#endif /* JDTableView_marco_private_h */
