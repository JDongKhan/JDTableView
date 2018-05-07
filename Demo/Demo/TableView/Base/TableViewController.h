//
//  TableViewController.h
//  Demo
//
//  Created by JD on 2018/5/7.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JDTableView/JDViewModel.h>

@interface TableViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JDViewModel *tableViewModel;

@end
