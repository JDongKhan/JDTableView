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

@interface Demo1ViewController ()

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
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
    /////////////////以下是编辑功能，可以不看/////////////////////////
    //配置indexPath下的数据源是否有编辑能力
    config.canEditable = ^BOOL(NSIndexPath *indexPath,id dataInfo) {
        return YES;
    };
    config.supportHeightCache = YES;
    //设置单行删除回调
    config.singleLineDeleteAction = ^(NSIndexPath *indexPath) {
        NSLog(@"我要删除第%ld行",indexPath.row);
    };
    self.tableView.jd_config = config;
}

- (void)configDataSource {
    for (NSInteger i = 0; i < 4; i++) {
        //开始组织对象
        JDSectionModel *section = [[JDSectionModel alloc] init];
        //section1.title = @"TableView";
        section.sectionData = [NSString stringWithFormat:@"我是自定义数据%ld",i];
        //section也可以配置数据源与cell的对应关系，它的优先级高于config的配置
        section.cellTypeBlock = ^NSInteger(NSIndexPath *indexPath, id dataInfo) {
            return [dataInfo[@"type"] integerValue];
        };
        NSDictionary *data = [DataUtils dataFromJsonFile:@"first.json"];
        [section addRowDatasFromArray:data[@"items"]];
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
