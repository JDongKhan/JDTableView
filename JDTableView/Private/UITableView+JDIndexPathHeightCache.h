//
//  JDBaseRefreshManager.h
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 14/12/15.
//  Copyright © 2015年 王金东. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface JDIndexPathHeightCache : NSObject

// Enable automatically if you're using index path driven height cache
@property (nonatomic, assign) BOOL automaticallyInvalidateEnabled;

// Height cache
- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateAllHeightCache;

@end

@interface UITableView (JDIndexPathHeightCache)
/// Height cache by index path. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) JDIndexPathHeightCache *indexPathHeightCache;
@end

@interface UITableView (JDIndexPathHeightCacheInvalidation)
/// Call this method when you want to reload data but don't want to invalidate
/// all height cache by index path, for example, load more data at the bottom of
/// table view.
- (void)reloadDataWithoutInvalidateIndexPathHeightCache;
@end
