//
//  Demo1ViewController.m
//  Demo
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "Demo1ViewController.h"
#import "DataUtils.h"
#import "FirstTableViewHeaderFooterView.h"
#import <JDTableView/JDSectionModel.h>
#import <JDTableView/UITableView+JDExtension.h>
@import JDAutoLayout;

@interface Demo1ViewController ()

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    
    [self.view addSubview:self.tableView];
    self.tableView.jd_insets(UIEdgeInsetsZero).jd_layout();
    
    self.tableViewModel = [[JDViewModel alloc] initWithDelegate:self dataSource:self];
    self.tableView.jd_viewModel = self.tableViewModel;
    
    //配置tableView
    [self configTableView];
    
    //配置数据源
    [self configDataSource];
    // Do any additional setup after loading the view.
}

- (void)editAction:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (void)configTableView {
    self.tableView.jd_tableViewCellArray = @[
                                             [UINib nibWithNibName:@"DemoTableViewCell1" bundle:nil],
                                             [UINib nibWithNibName:@"DemoTableViewCell2" bundle:nil]
                                             ];
    self.tableView.jd_tableViewHeaderViewArray = @[
                                                   [FirstTableViewHeaderFooterView class]
                                                   ];
    self.tableView.jd_headerTypeBlock = ^NSInteger(NSUInteger section, id sectionInfo) {
        return 0;
    };
    //编辑
    self.tableView.jd_canEditable = ^BOOL(NSIndexPath *indexPath) {
        return YES;
    };
    
    self.tableView.jd_singleLineDeleteAction = ^(NSIndexPath *indexPath) {
        NSLog(@"我要删除第%ld行",indexPath.row);
    };
}

- (void)configDataSource {
    
    //开始组织对象
    JDSectionModel *section1 = [[JDSectionModel alloc] init];
    //section1.title = @"TableView";
    section1.sectionData = @"我是自定义数据";
    section1.cellTypeBlock = ^NSInteger(NSIndexPath *indexPath, id dataInfo) {
        return [dataInfo[@"type"] integerValue];
    };
    NSDictionary *data = [DataUtils dataFromJsonFile:@"first.json"];
    [section1 addRowDatasFromArray:data[@"items"]];
    [self.tableViewModel addSectionData:section1];
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
