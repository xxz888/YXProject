//
//  YXSecondViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXSecondViewController.h"
#import "PYSearchViewController.h"
#import "YXFindSearchResultViewController.h"
#import "YXFindViewController.h"
#import "YXFindHeaderView.h"
#import "YXFaBuNewVCViewController.h"
#import "PYSearchViewController.h"

@interface YXSecondViewController ()<PYSearchViewControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * typeArray;
@property(nonatomic,strong)NSString * type;
@property (nonatomic) BOOL isCanBack;
@property(strong,nonatomic)YXFindHeaderView * findHeaderView;

@end

@implementation YXSecondViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initConfing];
    [self requestFindTag];
    [self rightBottomBtn];
}
-(void)rightBottomBtn{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"findjiahao"] forState:0];
    btn.frame = CGRectMake(KScreenWidth-16-54, KScreenHeight-kTabBarHeight-54-10+6, 54, 54);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(handleShowContentViewController) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setNavSearchView{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXFindHeaderView" owner:self options:nil];
    self.findHeaderView = [nib objectAtIndex:0];
    self.findHeaderView.frame = CGRectMake(KScreenWidth - 120, 0, 120, 50);
    [_segmentedPageViewController.categoryView addSubview:self.findHeaderView];
    kWeakSelf(self);
    self.findHeaderView.searchBlock = ^{
        [weakself clickSearchBar];
    };
    
    self.findHeaderView.fabuBlock = ^{
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        
        [weakself handleShowContentViewController];
//        XWPopMenuController *vc = [[XWPopMenuController alloc]init];
//        [weakself presentViewController:vc animated:NO completion:nil];
    };
}
- (void)handleShowContentViewController {
    if (![userManager loadUserInfo]) {
           KPostNotification(KNotificationLoginStateChange, @NO);
           return;
       }
    YXFaBuNewVCViewController * contentViewController = [[YXFaBuNewVCViewController alloc] init];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentViewMargins = UIEdgeInsetsMake(KScreenHeight-175-kTabBarHeight-10, KScreenWidth-146, kTabBarHeight+10, 0);
    modalViewController.contentViewController = contentViewController;
    [modalViewController showWithAnimated:YES completion:nil];
    
    contentViewController.block = ^{
        [modalViewController hideWithAnimated:YES completion:nil];
    };
}
-(void)clickSelectBtn:(UIButton *)btn{
    
}
-(void)initConfing{
    self.dataArray = [[NSMutableArray alloc]init];
}
#pragma mark ========== 1111111-先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindTag{
//    kWeakSelf(self);
//    [YX_MANAGER requestGet_users_find_tag:@"" success:^(id object) {
//        [weakself.dataArray removeAllObjects];
//        NSDictionary * newDic = @{@"weight":@"0",@"type":@"最新",@"id":@"-1"};
//        [weakself.dataArray addObject:newDic];
//        [weakself.dataArray addObjectsFromArray:object];
//        [weakself initSegment];
//    }];
    [self.dataArray removeAllObjects];
    NSDictionary * newDic = @{@"weight":@"0",@"type":@"最新",@"id":@"-1"};
    [self.dataArray addObject:newDic];
    NSDictionary * newDic1 = @{@"weight":@"1",@"type":@"最热",@"id":@"1"};
    [self.dataArray addObject:newDic1];
    [self initSegment];
}
-(void)initSegment{
    self.typeArray = [[NSMutableArray alloc]init];
    [self addChildViewController:self.segmentedPageViewController];
    [self.view addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    kWeakSelf(self);
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view).mas_offset(UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0));
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
        _segmentedPageViewController.categoryView.frame = CGRectMake(0, 0, KScreenWidth, 50);
        _segmentedPageViewController.categoryView.userInteractionEnabled = YES;
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont systemFontOfSize:14];
        _segmentedPageViewController.categoryView.titleSelectedFont = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
        _segmentedPageViewController.categoryView.titleSelectedColor = SEGMENT_COLOR;
        _segmentedPageViewController.pageViewControllers = controllers.copy;
        _segmentedPageViewController.categoryView.titles = titles;
        _segmentedPageViewController.categoryView.cellSpacing = 10;

        _segmentedPageViewController.categoryView.originalIndex = 0;
        
        //搜索栏
        [self setNavSearchView];
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
            [hotSeaches addObject:[dic[@"key"] UnicodeToUtf81]];
        }
        PYSearchViewController * searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            YXFindSearchResultViewController * VC = [[YXFindSearchResultViewController alloc] init];
            VC.searchBlock = ^(NSString * string) {
                weakself.searchHeaderView.searchBar.text = [string UnicodeToUtf8];
            };
            VC.searchText = [searchText UnicodeToUtf81];
            [searchViewController.navigationController pushViewController:VC animated:YES];
        }];
        searchViewController.searchResultShowMode = 1;
        searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
        searchViewController.searchHistoryStyle = 1;
        searchViewController.delegate = self;
//        RootNavigationController *nav2 = [[RootNavigationController alloc]initWithRootViewController:searchViewController];
//        [self presentViewController:nav2 animated:NO completion:nil];
        [self.navigationController pushViewController:searchViewController animated:YES];
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
