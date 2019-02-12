//
//  YXFindSearchResultViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultViewController.h"
#import "YXFindViewController.h"
#import "YXFindSearchResultUsersViewController.h"

@interface YXFindSearchResultViewController (){
    YXFindViewController * findVC;
    YXFindSearchResultUsersViewController * userVC;
    YXFindSearchResultUsersViewController * tagVC;
}

@end

@implementation YXFindSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    findVC = [[YXFindViewController alloc]init];
    findVC.yxTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    userVC = [[YXFindSearchResultUsersViewController alloc]init];
    tagVC = [[YXFindSearchResultUsersViewController alloc]init];
    NSArray* names = @[@"全部",@"用户",@"标签"];
    NSArray* controllers = @[findVC,userVC,tagVC];
    [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:kTopHeight view:self.view];
}
@end
