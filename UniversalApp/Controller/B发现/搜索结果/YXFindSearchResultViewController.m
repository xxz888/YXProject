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
#import "YXFindSearchResultAllViewController.h"
#import "UIView+PYSearchExtension.h"
@interface YXFindSearchResultViewController (){
    YXFindSearchResultAllViewController * allVC;
    YXFindSearchResultUsersViewController * userVC;
    YXFindSearchResultUsersViewController * tagVC;
}

@end

@implementation YXFindSearchResultViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowLiftBack = NO;
    [self setNavSearchView];
    
    allVC = [[YXFindSearchResultAllViewController alloc]init];
    userVC = [[YXFindSearchResultUsersViewController alloc]init];
    tagVC = [[YXFindSearchResultUsersViewController alloc]init];
    NSArray* names = @[@"全部",@"用户",@"标签"];
    NSArray* controllers = @[allVC,userVC,tagVC];
    [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:kTopHeight view:self.view];
}
- (void)cancleAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
