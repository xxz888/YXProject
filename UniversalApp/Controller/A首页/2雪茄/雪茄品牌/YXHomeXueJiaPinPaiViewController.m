//
//  YXHomeXueJiaPinPaiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiViewController.h"
#import "PYSearchViewController.h"
#import "PYSearch.h"
#import "PYTempViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeXueJiaFeiGuViewController.h"
#import "YXHomeXueJiaMyGuanZhuViewController.h"
#import "YXHomeXueJiaGuBaViewController.h"
@interface YXHomeXueJiaPinPaiViewController() <PYSearchViewControllerDelegate>
    {
        YXHomeXueJiaGuBaViewController * VC1;
        YXHomeXueJiaFeiGuViewController * VC2;
        YXHomeXueJiaGuBaViewController * VC3;
        YXHomeXueJiaGuBaViewController * VC4;
    }
@end
@implementation YXHomeXueJiaPinPaiViewController
-(void)viewDidLoad{
    [self setNavSearchView];
    [self setInitCollection];
}





-(void)setInitCollection{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    if (!VC1) {
        VC1 = [[YXHomeXueJiaGuBaViewController alloc]init];
    }
    if (!VC2) {
        VC2 = [[YXHomeXueJiaFeiGuViewController alloc]init];
    }
    if (!VC3) {
        VC3 = [[YXHomeXueJiaMyGuanZhuViewController alloc]init];
    }
    if (!VC4) {
        VC4 = [stroryBoard instantiateViewControllerWithIdentifier:@"YXHomeXueJiaGuBaViewController"];
    }
    NSArray* names = @[@"古巴",@"非古",@"我的关注"];
    NSArray* controllers = @[VC1,VC2,VC3];
    [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:84 view:self.view];
}



#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView{
    UIColor *color =  YXRGBAColor(239, 239, 239);
    UITextField * searchBar = [[UITextField alloc] init];
    searchBar.frame = CGRectMake(50, 0, KScreenWidth - 50, 35);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 10;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"   🔍 搜索";
    [searchBar addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingDidBegin];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = searchBar;
}
-(void)textField1TextChange:(UITextField *)tf{
    [self clickSearchBar];
}
- (void)clickSearchBar{
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        [searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
    }];
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = 1;
    searchViewController.delegate = self;
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    [self.navigationController pushViewController:searchViewController animated:YES];
}
@end
