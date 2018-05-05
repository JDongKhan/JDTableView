//
//  JDTableViewModel.h
//
//  Created by JD on 2017/9/15.
//  Copyright © 2017年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JDSectionModelDataSource;

NS_ASSUME_NONNULL_BEGIN

@interface JDViewModel : NSObject

@property (nonatomic, weak) id delegate;

@property (nonatomic, weak) id dataSource;

//一定要用此方法初始化
- (instancetype)initWithDelegate:(id)delegate dataSource:(id)dataSource;

// tableView右边的IndexTitles数据源
@property (nonatomic, strong) NSArray *sectionIndexTitles;

//清理数据
- (void)clear;

//在第section的区域插入sectionData数据
- (void)insertSection:(NSUInteger)section sectionData:(id<JDSectionModelDataSource>)sectionData;

/**
  添加所有sections数据
 */
- (void)addAllSectionData:(NSArray<id<JDSectionModelDataSource>> *)sections;

//增加sectionData 其rows数据需要自己指定
- (void)addSectionData:(id<JDSectionModelDataSource>)sectionData;

//增加sectionData,将sectionData作为该块的第一个数据
- (void)addSectionDataWithArray:(NSArray *)array;

//添加行数据
- (void)addRowData:(id)rowData section:(NSUInteger)section;

//移除块数据
- (void)removeSectionDataAtSection:(NSUInteger)section;
- (void)removeSectionData:(id)sectionData;

//移除行数据
- (void)removeRowDataAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeRowData:(id)rowData section:(NSUInteger)section;

@end


@interface JDViewModel (getData)

#pragma mark ----------- 我是分隔线 ------------

//返回section数量
- (NSUInteger)numberOfSections;

//根据section返回rows
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;

//返回section的数据
- (id)sectionDataAtSection:(NSUInteger)section;

//返回对应位置的数据
- (id)rowDataAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

