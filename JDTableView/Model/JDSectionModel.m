//
//  JDSectionModel.m
//
//  Created by JD on 2016/9/15.
//  Copyright © 2016年 JD. All rights reserved.
//

#import "JDSectionModel.h"

@implementation JDSectionModel{
    //存储其他额外数据
    NSMutableDictionary *_otherInfo;
    //操作数据
    JDCellTypeBlock _typeBlock;
    JDDidSelectCellBlock _didSelectBlock;
}

- (instancetype)init {
    if (self = [super init]) {
        _otherInfo = [NSMutableDictionary dictionary];
        _dataArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark  ------ 添加行数据 ------
- (void)addRowData:(id)rowData {
    if ([_dataArray isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray*)_dataArray addObject:rowData];
    }
}

- (void)addRowDatasFromArray:(NSArray *)rowDatas {
    if ([_dataArray isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray*)_dataArray addObjectsFromArray:rowDatas];
    }
}

- (void)removeAllDatas {
    if ([_dataArray isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray *)_dataArray removeAllObjects];
    }
}

#pragma mark ------ 可以添加额外的数据 ------
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {
    [_otherInfo setValue:value forKey:key];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return [_otherInfo valueForKey:key];
}

#pragma mark  ------ 需要实现的方法 ------
- (NSArray *)itemArray {
    return _dataArray;
}

// 数据源对应的cell索引
- (JDCellTypeBlock)cellTypeBlock {
    return _typeBlock;
}

- (void)setCellTypeBlock:(JDCellTypeBlock)cellTypeBlock {
    _typeBlock = cellTypeBlock;
}

// didSelectRowAtIndexPath
- (JDDidSelectCellBlock)didSelectCellBlock {
    return _didSelectBlock;
}

- (void)setDidSelectCellBlock:(JDDidSelectCellBlock)didSelectCellBlock {
    _didSelectBlock = didSelectCellBlock;
}


@end

#pragma mark  ----------------rowData-----------

@implementation JDRowModel {
    //存储其他额外数据
    NSMutableDictionary *_otherInfo;
}

- (instancetype)init {
    if (self = [super init]) {
        _otherInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark 可以添加额外的数据
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {
    [_otherInfo setValue:value forKey:key];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return [_otherInfo valueForKey:key];
}

@end
