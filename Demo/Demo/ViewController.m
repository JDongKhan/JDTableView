//
//  ViewController.m
//  Demo
//
//  Created by JD on 2018/3/26.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "ViewController.h"
#import <JDTableView/JDViewModel.h>
#import <JDTableView/JDSectionModel.h>
#import <JDTableView/UITableView+JDExtension.h>

@interface ViewController () <JDTableViewDelegate,JDTableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDataSource];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)configDataSource {
    
    JDSectionModel *section1 = [[JDSectionModel alloc] init];
    section1.title = @"TableView";
    
    JDRowModel *row0 = [[JDRowModel alloc] init];
    row0.title = @"Demo1";
    [row0 setValue:@"Demo1ViewController" forKey:@"viewController"];
    
    JDRowModel *row01 = [[JDRowModel alloc] init];
    row01.title = @"Demo2";
    [row01 setValue:@"Demo2ViewController" forKey:@"viewController"];
    
    JDRowModel *row02 = [[JDRowModel alloc] init];
    row02.title = @"Demo3";
    [row02 setValue:@"Demo31ViewController" forKey:@"viewController"];
    
    [section1 addRowDatasFromArray:@[
                                     row0,
                                     row01,
                                     row02
                                     ]];
    [self.tableViewModel addSectionData:section1];
    
    JDSectionModel *section2 = [[JDSectionModel alloc] init];
    section2.title = @"CollectionView";
    JDRowModel *row1 = [[JDRowModel alloc] init];
    row1.title = @"Demo1";
    [section2 addRowDatasFromArray:@[
                                     row1
                                     ]];
    [self.tableViewModel addSectionData:section2];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JDRowModel *row = [self.tableViewModel rowDataAtIndexPath:indexPath];
    NSString *vcName = [row valueForKey:@"viewController"];
    if (vcName.length > 0) {
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
