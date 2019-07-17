//
//  YXSecondViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXSecondViewController.h"
#import "HGSegmentedPageViewController.h"
#import "PYSearchViewController.h"
#import "YXFindSearchViewController.h"
#import "YXFindSearchResultViewController.h"
#import "YXFindViewController.h"
@interface YXSecondViewController ()<PYSearchViewControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * typeArray;
@property(nonatomic,strong)NSString * type;
@property (nonatomic) BOOL isCanBack;

@end

@implementation YXSecondViewController
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
    //搜索栏
    [self setNavSearchView];
    [self initConfing];
    [self requestFindTag];

}
-(void)initConfing{
    self.dataArray = [[NSMutableArray alloc]init];
}
#pragma mark ========== 1111111-先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindTag{
    kWeakSelf(self);
    [YX_MANAGER requestGet_users_find_tag:@"" success:^(id object) {
        [weakself.dataArray removeAllObjects];
        NSDictionary * newDic = @{@"weight":@"0",@"type":@"最新",@"id":@"-1"};
        [weakself.dataArray addObject:newDic];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself initSegment];
    }];
}
-(void)initSegment{
    self.typeArray = [[NSMutableArray alloc]init];
    [self addChildViewController:self.segmentedPageViewController];
    [self.view addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    kWeakSelf(self);
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view).mas_offset(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
    }];
}
- (HGSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        NSMutableArray * titles =  [NSMutableArray array];
        NSMutableArray * controllers = [NSMutableArray array];
        for (NSDictionary * dic in self.dataArray) {
            //title
            [titles addObject:dic[@"type"]];
            //控制器
            YXFindViewController * vc = [[YXFindViewController alloc]init];
            vc.startDic = [NSDictionary dictionaryWithDictionary:dic];
            [controllers addObject:vc];
        }        
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont systemFontOfSize:14];
        _segmentedPageViewController.categoryView.titleSelectedFont = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        _segmentedPageViewController.categoryView.titleSelectedColor = SEGMENT_COLOR;
        _segmentedPageViewController.pageViewControllers = controllers.copy;
        _segmentedPageViewController.categoryView.titles = titles;
        _segmentedPageViewController.categoryView.cellSpacing = 10;

        _segmentedPageViewController.categoryView.originalIndex = 0;
    }
    return _segmentedPageViewController;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self clickSearchBar];
    return NO;
}
- (void)clickSearchBar{
    kWeakSelf(self);
    [YX_MANAGER requestGetFind_all:@"" success:^(id object) {
        NSMutableArray * hotSeaches = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in object) {
            [hotSeaches addObject:[dic[@"key"] UnicodeToUtf8]];
        }
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
#pragma mark -- 禁用边缘返回
-(void)forbiddenSideBack{
    self.isCanBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    }
}
#pragma mark --恢复边缘返回
- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}
@end
