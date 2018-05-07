//
//  Demo2ViewController.m
//  Demo
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "Demo2ViewController.h"
#import "DataUtils.h"
#import <JDTableView/JDViewModel.h>
#import <JDTableView/JDSectionModel.h>
#import <JDTableView/UITableView+JDExtension.h>

@interface Demo2ViewController ()

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
    
    [self configDataSource];
}


- (void)configTableView {
    JDTableViewConfig *config = [[JDTableViewConfig alloc] init];
    //配置都有哪些cells
    config.tableViewCellArray = @[[UINib nibWithNibName:@"DemoTableViewCell1" bundle:nil],
                                  [UINib nibWithNibName:@"DemoTableViewCell2" bundle:nil]];
    //配置数据源与cell的对应关系
    config.cellTypeBlock = ^NSInteger(NSIndexPath *indexPath, id dataInfo) {
        return [dataInfo[@"type"] integerValue];
    };
    self.tableView.jd_config = config;
}

//读取数据源
- (void)configDataSource {
    NSDictionary *data = [DataUtils dataFromJsonFile:@"first.json"];
    [self.tableViewModel addRowDatasFromArray:data[@"items"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
