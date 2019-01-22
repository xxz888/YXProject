//
//  YXQCDJCDetailTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXQCDJCDetailTableViewController.h"

@interface YXQCDJCDetailTableViewController ()

@end

@implementation YXQCDJCDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球场信息";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

@end
