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
#import "PYSearchViewController.h"
#import "YXPublishImageViewController.h"
#import "YXWenZhangEditorViewController.h"
@interface YXSecondViewController ()<PYSearchViewControllerDelegate,UIGestureRecognizerDelegate,lzMenuDelegate>
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
//    [self rightBottomBtn];
    [self addButton];

}
- (void)addButton{
    
    CGRect floatFrame = CGRectMake(KScreenWidth-70, KScreenHeight-kTabBarHeight-80, 48, 48);
    self.menuBtn = [[LZMenuButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"findjiahao"] andPressedImage:[UIImage imageNamed:@"fabunewclose"] withScrollview:nil effectImage:[UIImage imageNamed:@""] menuWidth:45];
    self.menuBtn.imageArray = @[@"fabunewshaitu",@"fabunewwenzhang"];
    self.menuBtn.labelArray = @[@"文章",@"晒图"];
    self.menuBtn.hideWhileScrolling = NO;
    self.menuBtn.delegate = self;
    [self.view addSubview:self.menuBtn];
    
}
- (void)didSelectMenuOptionAtIndex:(NSInteger)row{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    if (row==1) {
        YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
        imageVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imageVC animated:YES completion:nil];
    }else{
        YXWenZhangEditorViewController * pinpaiVC = [[YXWenZhangEditorViewController alloc]init];
        pinpaiVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:pinpaiVC animated:YES completion:nil];
    }

    
    
   
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
    NSDictionary * newDic = @{@"weight":@"0",@"type":@"推荐",@"id":@"1"};
    [self.dataArray addObject:newDic];
    NSDictionary * newDic1 = @{@"weight":@"1",@"type":@"热门",@"id":@"2"};
    [self.dataArray addObject:newDic1];
    NSDictionary * newDic2 = @{@"weight":@"2",@"type":@"关注",@"id":@"3"};
    [self.dataArray addObject:newDic2];
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
        _segmentedPageViewController.categoryView.titleNomalFont = BOLDSYSTEMFONT(18);
        _segmentedPageViewController.categoryView.titleSelectedFont =  BOLDSYSTEMFONT(24);
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
            [hotSeaches addObject:dic[@"key"]];
        }
        PYSearchViewController * searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            YXFindSearchResultViewController * VC = [[YXFindSearchResultViewController alloc] init];
            VC.searchBlock = ^(NSString * string) {
                weakself.searchHeaderView.searchBar.text = string;
            };
            VC.searchText = searchText;
            [searchViewController.navigationController pushViewController:VC animated:YES];
        }];
        searchViewController.searchResultShowMode = 1;
        searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
        searchViewController.searchHistoryStyle = 1;
        searchViewController.delegate = weakself;
        [weakself.navigationController pushViewController:searchViewController animated:YES];
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
