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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowLiftBack = YES;
    [self setNavSearchView];
    self.searchHeaderView.searchBar.text = self.searchText;
    allVC = [[YXFindSearchResultAllViewController alloc]init];
    allVC.key = self.searchText;
    userVC = [[YXFindSearchResultUsersViewController alloc]init];
    userVC.key = self.searchText;

    userVC.whereCome = NO;
    tagVC = [[YXFindSearchResultUsersViewController alloc]init];
    tagVC.key = self.searchText;

    tagVC.whereCome = YES;

    NSArray* names = @[@"全部",@"用户",@"标签"];
    NSArray* controllers = @[allVC,userVC,tagVC];
    [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:kTopHeight view:self.view];
}
- (void)cancleAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    allVC.key = searchBar.text;
    userVC.key = searchBar.text;
    tagVC.key = searchBar.text;
    [allVC requestFindAll:searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ([searchBar.text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}
@end
