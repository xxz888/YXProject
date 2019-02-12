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
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
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
#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView{
    UIColor *color =  YXRGBAColor(217, 217, 217);
    UITextField * searchBar = [[UITextField alloc] init];
    [self.view addSubview:searchBar];
    searchBar.frame = CGRectMake(10, 20, KScreenWidth-70, 40);
    ViewBorderRadius(searchBar, 1, 1, color);
    searchBar.placeholder = @"搜索";
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(searchBar.py_size.width-30, 20, 25, 25);
    btn.centerY = searchBar.centerY;
    [btn setBackgroundImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
    [searchBar addSubview:btn];
//    [searchBar addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingDidBegin];
    [self.view addSubview:btn];

    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(KScreenWidth-50, 20, 40, 40);
    cancleBtn.centerY = searchBar.centerY;
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setFont:[UIFont systemFontOfSize:14]];
    [cancleBtn setTitleColor:KDarkGaryColor forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancleBtn];
}
-(void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
