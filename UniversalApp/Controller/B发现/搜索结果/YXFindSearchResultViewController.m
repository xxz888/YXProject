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
#import "HGSegmentedPageViewController.h"

@interface YXFindSearchResultViewController (){
    YXFindSearchResultAllViewController * allVC;
    YXFindSearchResultUsersViewController * userVC;
}
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;

@end

@implementation YXFindSearchResultViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowLiftBack = NO;
    [self setNavSearchView];
    self.searchHeaderView.searchBar.text = self.searchText;

    
    
    [self addChildViewController:self.segmentedPageViewController];
    [self.view addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    kWeakSelf(self);
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view).mas_offset(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
}

- (HGSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        allVC = [[YXFindSearchResultAllViewController alloc]init];
        allVC.key = self.searchText;
        userVC = [[YXFindSearchResultUsersViewController alloc]init];
        userVC.key = self.searchText;
        userVC.whereCome = NO;
        
        NSArray* titles = @[@"全部",@"用户"];
        NSArray* controllers = @[allVC,userVC];
        
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.pageViewControllers = controllers.copy;
        _segmentedPageViewController.categoryView.titles = titles;
        _segmentedPageViewController.categoryView.originalIndex = 0;
    }
    return _segmentedPageViewController;
}
- (void)cancleAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    allVC.key = textField.text;
       userVC.key = textField.text;
       [allVC requestFindAll:textField.text];
    [userVC requestFindAll_user:textField.text];
    
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    allVC.key = searchBar.text;
    userVC.key = searchBar.text;
    [allVC requestFindAll:searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBlock(self.searchHeaderView.searchBar.text);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
