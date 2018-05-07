//
//  TableViewController.m
//  Demo
//
//  Created by JD on 2018/5/7.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "TableViewController.h"
#import <JDTableView/UITableView+JDExtension.h>
@import JDAutoLayout;


@interface TableViewController () <JDTableViewDelegate,JDTableViewDataSource>

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.jd_delegate = self;
    self.tableView.jd_dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.jd_insets(UIEdgeInsetsZero).jd_layout();

    self.tableViewModel = [[JDViewModel alloc] init];
    self.tableView.jd_viewModel = self.tableViewModel;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
