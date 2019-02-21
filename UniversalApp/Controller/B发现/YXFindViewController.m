//
//  YXFindViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//
#import "YXFindViewController.h"

#import "YXFindSearchResultViewController.h"
#import "PYSearchViewController.h"
#import "YXFindSearchViewController.h"
@interface YXFindViewController ()<PYSearchViewControllerDelegate>{
    NSInteger page ;
    CBSegmentView * sliderSegmentView;
}
@property(nonatomic,strong)NSMutableArray * typeArray;
@property(nonatomic,strong)NSString * type;
@end

@implementation YXFindViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //搜索栏
    [self setNavSearchView];
    //头视图
    [self headerView];
    //其他方法
    [self setOtherAction];
    //请求
    [self requestFindTag];
}
-(void)setOtherAction{
    self.title = @"发现";
    self.isShowLiftBack = NO;
    self.typeArray = [[NSMutableArray alloc]init];
    self.navigationItem.rightBarButtonItem = nil;
    self.yxTableView.frame = CGRectMake(0, kTopHeight + 40, KScreenWidth, KScreenHeight - kTopHeight-TabBarHeight - 40);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.type = @"1";
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestFindTheType];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestFindTheType];
}
#pragma mark ========== headerview ==========
-(void)headerView{
    kWeakSelf(self);
    sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, 40)];
    sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
        [weakself.dataArray removeAllObjects];
        weakself.type = weakself.typeArray[x];
        weakself.requestPage = 1;
        [weakself requestFindTheType];
    };
    [self.view addSubview:sliderSegmentView];
}
-(void)requestAction{
    [self requestFindTheType];
}
#pragma mark ========== 1111111-先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindTag{
    kWeakSelf(self);
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [YX_MANAGER requestGet_users_find_tag:@"" success:^(id object) {
        [weakself.typeArray removeAllObjects];
        for (NSDictionary * dic in object) {
            [array addObject:dic[@"type"]];
            [weakself.typeArray addObject:dic[@"id"]];
        }
        weakself.type = weakself.typeArray[0];
       [sliderSegmentView setTitleArray:array withStyle:CBSegmentStyleSlider];
       [weakself requestFindTheType];
    }];
}
#pragma mark ========== 2222222-在请求具体tag下的请求,获取发现页标签数据全部接口 ==========
-(void)requestFindTheType{
    kWeakSelf(self);
    NSString * parString =[NSString stringWithFormat:@"%@/%@",self.type,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGet_users_find:parString success:^(id object){
        if ([object count] > 0) {
            NSMutableArray *_dataSourceTemp=[NSMutableArray new];
            for (NSDictionary *company in object) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:company];
                [dic setObject:@"0" forKey:@"isShowMoreText"];
                [_dataSourceTemp addObject:dic];
            }
            object=_dataSourceTemp;
        }
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self clickSearchBar];
//    [QMUITips showInfo:SHOW_FUTURE_DEV inView:self.view hideAfterDelay:1];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return NO;
}
- (void)clickSearchBar{
    [YX_MANAGER requestGetFind_all:@"" success:^(id object) {
        NSMutableArray * hotSeaches = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in object) {
            [hotSeaches addObject:[dic[@"key"] UnicodeToUtf8]];
        }
        kWeakSelf(self);
        YXFindSearchViewController *searchViewController = [YXFindSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            YXFindSearchResultViewController * VC = [[YXFindSearchResultViewController alloc] init];
            VC.searchBlock = ^(NSString * string) {
                weakself.searchHeaderView.searchBar.text = [string UnicodeToUtf8];
            };
            VC.searchText = [searchText UnicodeToUtf8];
            [searchViewController.navigationController pushViewController:VC animated:YES];
        }];
        searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
        searchViewController.searchHistoryStyle = 1;
        searchViewController.delegate = self;
        RootNavigationController *nav2 = [[RootNavigationController alloc]initWithRootViewController:searchViewController];
        [self presentViewController:nav2 animated:NO completion:nil];
    }];
}
@end
