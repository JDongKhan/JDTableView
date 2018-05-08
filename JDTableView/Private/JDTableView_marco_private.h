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

#define metamacro_concat(A, B)  metamacro_concat_(A, B)
#define metamacro_concat_(A, B) A ## B

#define __jd_int_value( __nubmer ) [__nubmer intValue]
#define __jd_NSInteger_value( __nubmer ) [__nubmer integerValue]
#define __jd_CGFloat_value( __nubmer ) [__nubmer floatValue]
#define __jd_BOOL_value( __nubmer ) [__nubmer boolValue]
#define __jd_NSTimeInterval_value( __nubmer ) [__nubmer doubleValue]


#define NUMBER_ASSOCIATION_METHOD(__set,__get,__type) \
- (void)__set:(__type)value { \
    objc_setAssociatedObject(self, @selector(__get), @(value), OBJC_ASSOCIATION_COPY_NONATOMIC); \
} \
- (__type)__get { \
    NSNumber *number =  objc_getAssociatedObject(self, _cmd); \
    return metamacro_concat(metamacro_concat(__jd_, __type), _value)(number); \
} \

#endif /* JDTableView_marco_private_h */
