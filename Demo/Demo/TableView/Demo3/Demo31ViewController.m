//
//  Demo31ViewController.m
//  Demo
//
//  Created by JD on 2018/4/20.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "Demo31ViewController.h"
#import "Demo32ViewController.h"
#import "FirstTableViewHeaderFooterView.h"
#import "DataUtils.h"

@interface Demo31ViewController () <JDTableViewDelegate,JDTableViewDataSource>

@end

@implementation Demo31ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置tableView
    [self configTableView];
    //配置数据源
    [self configDataSource];
    // Do any additional setup after loading the view.
}


- (void)configTableView {
    __weak Demo31ViewController *weakSelf = self;
    JDTableViewConfig *config = [[JDTableViewConfig alloc] init];
    //配置都有哪些cells
    config.tableViewCellArray = @[[UINib nibWithNibName:@"DemoTableViewCell1" bundle:nil],
                                  [UINib nibWithNibName:@"DemoTableViewCell2" bundle:nil]];
    //配置数据源与cell的对应关系
    config.cellTypeBlock = ^NSInteger(NSIndexPath *indexPath, id dataInfo) {
        return 0;
    };
    //配置都有哪些header
    config.tableViewHeaderViewArray = @[[FirstTableViewHeaderFooterView class]];
    //配置数据源与header的对应关系
    config.headerTypeBlock = ^NSInteger(NSUInteger section, id sectionInfo) {
        return 0;
    };
    config.didSelectCellBlock = ^(NSIndexPath *indexPath, id dataInfo) {
         [weakSelf.navigationController pushViewController:[[Demo32ViewController alloc] init] animated:YES];
    };
    /////////////////以下是编辑功能，可以不看/////////////////////////
    config.supportHeightCache = YES;
    self.tableView.jd_config = config;
}

- (void)configDataSource {
    NSArray *data = [DataUtils dataFromJsonFile:@"second.json"];
    
    for (NSInteger i = 0; i < data.count; i++) {
        //开始组织对象
        JDSectionModel *section = [[JDSectionModel alloc] init];
        //section1.title = @"TableView";
        section.sectionData = data[i];
        //section也可以配置数据源与cell的对应关系，它的优先级高于config的配置
        section.cellTypeBlock = ^NSInteger(NSIndexPath *indexPath, id dataInfo) {
            return [dataInfo[@"type"] integerValue];
        };
        [section addRowDatasFromArray:data[i][@"items"]];
        [self.tableViewModel addSectionData:section];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
