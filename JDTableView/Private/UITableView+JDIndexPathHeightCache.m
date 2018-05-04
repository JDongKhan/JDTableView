//
//  JDBaseRefreshManager.h
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 14/12/15.
//  Copyright © 2015年 王金东. All rights reserved.
//

#import "UITableView+JDIndexPathHeightCache.h"
#import <objc/runtime.h>

typedef NSMutableArray<NSMutableArray<NSNumber *> *> JDIndexPathHeightsBySection;

@interface JDIndexPathHeightCache ()
@property (nonatomic, strong) JDIndexPathHeightsBySection *heightsBySectionForPortrait;
@property (nonatomic, strong) JDIndexPathHeightsBySection *heightsBySectionForLandscape;
@end

@implementation JDIndexPathHeightCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _heightsBySectionForPortrait = [NSMutableArray array];
        _heightsBySectionForLandscape = [NSMutableArray array];
    }
    return self;
}

- (JDIndexPathHeightsBySection *)heightsBySectionForCurrentOrientation {
    return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? self.heightsBySectionForPortrait: self.heightsBySectionForLandscape;
}

- (void)enumerateAllOrientationsUsingBlock:(void (^)(JDIndexPathHeightsBySection *heightsBySection))block {
    block(self.heightsBySectionForPortrait);
    block(self.heightsBySectionForLandscape);
}

- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row];
    return ![number isEqualToNumber:@-1];
}

- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath {
    self.automaticallyInvalidateEnabled = YES;
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row] = @(height);
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row];
#if CGFLOAT_IS_DOUBLE
    return number.doubleValue;
#else
    return number.floatValue;
#endif
}

- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    [self enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
        heightsBySection[indexPath.section][indexPath.row] = @-1;
    }];
}

- (void)invalidateAllHeightCache {
    [self enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
        [heightsBySection removeAllObjects];
    }];
}

- (void)buildCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths {
    // Build every section array or row array which is smaller than given index path.
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self buildSectionsIfNeeded:indexPath.section];
        [self buildRowsIfNeeded:indexPath.row inExistSection:indexPath.section];
    }];
}

- (void)buildSectionsIfNeeded:(NSInteger)targetSection {
    [self enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
        for (NSInteger section = 0; section <= targetSection; ++section) {
            if (section >= heightsBySection.count) {
                heightsBySection[section] = [NSMutableArray array];
            }
        }
    }];
}

- (void)buildRowsIfNeeded:(NSInteger)targetRow inExistSection:(NSInteger)section {
    [self enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
        NSMutableArray<NSNumber *> *heightsByRow = heightsBySection[section];
        for (NSInteger row = 0; row <= targetRow; ++row) {
            if (row >= heightsByRow.count) {
                heightsByRow[row] = @-1;
            }
        }
    }];
}

@end

@implementation UITableView (SPTIndexPathHeightCache)

- (JDIndexPathHeightCache *)indexPathHeightCache {
    JDIndexPathHeightCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [JDIndexPathHeightCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end

// We just forward primary call, in crash report, top most method in stack maybe FD's,
// but it's really not our bug, you should check whether your table view's data source and
// displaying cells are not matched when reloading.
static void __SPT_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(void (^callout)(void)) {
    callout();
}
#define SPTPrimaryCall(...) do {__SPT_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(^{__VA_ARGS__});} while(0)

@implementation UITableView (SPTIndexPathHeightCacheInvalidation)

- (void)reloadDataWithoutInvalidateIndexPathHeightCache {
    SPTPrimaryCall([self spt_reloadData];);
}

+ (void)load {
    // All methods that trigger height cache's invalidation
//    SEL selectors[] = {
//        @selector(reloadData),
//        @selector(insertSections:withRowAnimation:),
//        @selector(deleteSections:withRowAnimation:),
//        @selector(reloadSections:withRowAnimation:),
//        @selector(moveSection:toSection:),
//        @selector(insertRowsAtIndexPaths:withRowAnimation:),
//        @selector(deleteRowsAtIndexPaths:withRowAnimation:),
//        @selector(reloadRowsAtIndexPaths:withRowAnimation:),
//        @selector(moveRowAtIndexPath:toIndexPath:)
//    };
//    
//    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
//        SEL originalSelector = selectors[index];
//        SEL swizzledSelector = NSSelectorFromString([@"spt_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
//        Method originalMethod = class_getInstanceMethod(self, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
}

- (void)spt_reloadData {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
            [heightsBySection removeAllObjects];
        }];
    }
    SPTPrimaryCall([self spt_reloadData];);
}

- (void)spt_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.indexPathHeightCache buildSectionsIfNeeded:section];
            [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection insertObject:[NSMutableArray array] atIndex:section];
            }];
        }];
    }
    SPTPrimaryCall([self spt_insertSections:sections withRowAnimation:animation];);
}

- (void)spt_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.indexPathHeightCache buildSectionsIfNeeded:section];
            [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection removeObjectAtIndex:section];
            }];
        }];
    }
    SPTPrimaryCall([self spt_deleteSections:sections withRowAnimation:animation];);
}

- (void)spt_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock: ^(NSUInteger section, BOOL *stop) {
            [self.indexPathHeightCache buildSectionsIfNeeded:section];
            [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[section] removeAllObjects];
            }];

        }];
    }
    SPTPrimaryCall([self spt_reloadSections:sections withRowAnimation:animation];);
}

- (void)spt_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.indexPathHeightCache buildSectionsIfNeeded:section];
        [self.indexPathHeightCache buildSectionsIfNeeded:newSection];
        [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
            [heightsBySection exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }];
    }
    SPTPrimaryCall([self spt_moveSection:section toSection:newSection];);
}

- (void)spt_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[indexPath.section] insertObject:@-1 atIndex:indexPath.row];
            }];
        }];
    }
    SPTPrimaryCall([self spt_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)spt_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        
        NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
            if (!mutableIndexSet) {
                mutableIndexSet = [NSMutableIndexSet indexSet];
                mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
            }
            [mutableIndexSet addIndex:indexPath.row];
        }];
        
        [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSIndexSet *indexSet, BOOL *stop) {
            [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[key.integerValue] removeObjectsAtIndexes:indexSet];
            }];
        }];
    }
    SPTPrimaryCall([self spt_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)spt_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
                heightsBySection[indexPath.section][indexPath.row] = @-1;
            }];
        }];
    }
    SPTPrimaryCall([self spt_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)spt_moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.indexPathHeightCache buildCachesAtIndexPathsIfNeeded:@[sourceIndexPath, destinationIndexPath]];
        [self.indexPathHeightCache enumerateAllOrientationsUsingBlock:^(JDIndexPathHeightsBySection *heightsBySection) {
            NSMutableArray<NSNumber *> *sourceRows = heightsBySection[sourceIndexPath.section];
            NSMutableArray<NSNumber *> *destinationRows = heightsBySection[destinationIndexPath.section];
            NSNumber *sourceValue = sourceRows[sourceIndexPath.row];
            NSNumber *destinationValue = destinationRows[destinationIndexPath.row];
            sourceRows[sourceIndexPath.row] = destinationValue;
            destinationRows[destinationIndexPath.row] = sourceValue;
        }];
    }
    SPTPrimaryCall([self spt_moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];);
}

@end
