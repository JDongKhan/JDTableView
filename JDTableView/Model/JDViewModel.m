//
//  JDTableViewModel.m
//
//  Created by JD on 2017/9/15.
//  Copyright © 2017年 JD. All rights reserved.
//

#import "JDViewModel.h"
#import "JDSectionModel.h"

@implementation JDViewModel {
    //存放二维数组
    NSMutableArray<id<JDSectionModelDataSource>> *_allDataArray;
}

- (instancetype)init {
    if (self = [super init]) {
        _allDataArray = [NSMutableArray array];
    }
    return self;
}

- (void)clear {
    [_allDataArray removeAllObjects];
}

//在第section的区域插入sectionData数据
- (void)insertSection:(NSUInteger)section sectionData:(id<JDSectionModelDataSource>)sectionData {
    [_allDataArray insertObject:sectionData atIndex:section];
}

/**
 添加所有sections数据
 */
- (void)addAllSectionData:(NSArray<id<JDSectionModelDataSource>> *)sections {
    [_allDataArray addObjectsFromArray:sections];
}

//增加sectionData 其rows数据需要自己指定
- (void)addSectionData:(id<JDSectionModelDataSource>)sectionData {
    [_allDataArray addObject:sectionData];
}

/**
 增加rowDatas,默认加到第一块
 */
- (void)addRowDatasFromArray:(NSArray *)array {
    JDSectionModel *sectionInfo = [[JDSectionModel alloc] init];
    [sectionInfo addRowDatasFromArray:array];
    [self addSectionData:sectionInfo];
}

//添加行数据
- (void)addRowData:(id)rowData section:(NSUInteger)section {
    id<JDSectionModelDataSource> sectionData = [_allDataArray objectAtIndex:section];
    NSMutableArray *itemArray = [sectionData itemArray];
    NSAssert([itemArray isKindOfClass:[NSMutableArray class]], @"can not add from NSArray，please change to NSMutableArray");
    [itemArray addObject:rowData];
}

//移除块数据
- (void)removeSectionDataAtSection:(NSUInteger)section {
    if (_allDataArray.count > section) {
        [_allDataArray removeObjectAtIndex:section];
    }
}

- (void)removeSectionData:(id)sectionData {
    [_allDataArray removeObject:sectionData];
}

//移除行数据
- (void)removeRowDataAtIndexPath:(NSIndexPath *)indexPath {
    id<JDSectionModelDataSource> sectionData = [_allDataArray objectAtIndex:indexPath.section];
    NSMutableArray *itemArray = [sectionData itemArray];
    NSAssert([itemArray isKindOfClass:[NSMutableArray class]], @"can not add from NSArray，please change to NSMutableArray");
    [itemArray removeObjectAtIndex:indexPath.row];
}

- (void)removeRowData:(id)rowData section:(NSUInteger)section {
    id<JDSectionModelDataSource> sectionData = [_allDataArray objectAtIndex:section];
    NSMutableArray *itemArray = [sectionData itemArray];
    [itemArray removeObject:rowData];
}

- (void)removeAllDatas {
    [_allDataArray removeAllObjects];
}

@end

@implementation JDViewModel (getData)

#pragma mark --------------获取数据--------------------
- (NSUInteger)numberOfSections {
    return _allDataArray.count;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    id<JDSectionModelDataSource> sectionData = _allDataArray[section];
    NSArray *itemArray = [sectionData itemArray];
    return itemArray.count;
}

//返回section的数据
- (id)sectionDataAtSection:(NSUInteger)section {
    return _allDataArray[section];
}

//返回对应位置的数据
- (id)rowDataAtIndexPath:(NSIndexPath *)indexPath {
    id<JDSectionModelDataSource> sectionData = _allDataArray[indexPath.section];
    id dataInfo = nil;
    NSArray *itemArray = [sectionData itemArray];
    if (itemArray.count > indexPath.row) {
        dataInfo = itemArray[indexPath.row];
    }
    return dataInfo;
}


@end
