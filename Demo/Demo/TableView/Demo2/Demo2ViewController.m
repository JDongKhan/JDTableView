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
@import JDAutoLayout;

@interface Demo2ViewController ()


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JDViewModel *tableViewModel;

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.jd_insets(UIEdgeInsetsZero).jd_layout();
    
    self.tableViewModel = [[JDViewModel alloc] initWithDelegate:self dataSource:self];
    self.tableView.jd_viewModel = self.tableViewModel;
    [self configTableView];
    [self configDataSource];
}



- (void)configTableView {
    self.tableView.jd_tableViewCellArray = @[
                                             [UINib nibWithNibName:@"DemoTableViewCell1" bundle:nil],
                                             [UINib nibWithNibName:@"DemoTableViewCell2" bundle:nil]
                                             ];
    self.tableView.jd_cellTypeBlock = ^NSInteger(NSIndexPath *indexPath, id dataInfo) {
        return [dataInfo[@"type"] integerValue];
    };
}

- (void)configDataSource {
    NSDictionary *data = [DataUtils dataFromJsonFile:@"first.json"];
    [self.tableViewModel addSectionDataWithArray:data[@"items"]];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
