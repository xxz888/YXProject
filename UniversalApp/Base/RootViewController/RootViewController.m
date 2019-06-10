//
//  RootViewController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import <UShareUI/UShareUI.h>
#import "PYSearchViewController.h"
#import "PYTempViewController.h"
#import "YXFindSearchHeadView.h"

@interface RootViewController ()<PYSearchViewControllerDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,UIScrollViewDelegate>{
    XHStarRateView *starRateView ;
    UITableView * _yxTableView;
    UICollectionView * _yxCollectionView;
}

@property (nonatomic,strong) UIImageView* noDataView;

@property (nonatomic) BOOL isCanBack;

@end

@implementation RootViewController







- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}
//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =KWhiteColor;
    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //默认导航栏样式：黑字
    self.StatusBarStyle = 0;
    [[UINavigationBar appearance] setTintColor:KBlackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.requestPage = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnFindVC:) name:@"returnFind" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnHomeVC:) name:@"returnHome" object:nil];

}
- (void)returnFindVC:(NSNotification *)notification{
    self.navigationController.tabBarController.selectedIndex = 1;
}
- (void)returnHomeVC:(NSNotification *)notification{
//    self.navigationController.tabBarController.selectedIndex = 0;
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    RootViewController * VC = nil;
    VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaFootViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}



- (void)showLoadingAnimation{
}

- (void)stopLoadingAnimation{
}

-(void)showNoDataImage
{
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"generl_nodata"]];
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [_noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:_noDataView];
        }
    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

- (void)addRefreshView:(UITableView *)yxTableView{
    _yxTableView = yxTableView;
    yxTableView.showsHorizontalScrollIndicator = YES;
    yxTableView.estimatedRowHeight = 0;
    yxTableView.estimatedSectionFooterHeight = 0;
    yxTableView.estimatedSectionHeaderHeight = 0;
    //头部刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    yxTableView.mj_header = header;
    
    //底部刷新
    yxTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
- (void)addCollectionViewRefreshView:(UICollectionView *)yxCollectionView{
    _yxCollectionView = yxCollectionView;
    yxCollectionView.showsHorizontalScrollIndicator = YES;
    //头部刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    yxCollectionView.mj_header = header;
    //底部刷新
    yxCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
-(void)headerRereshing{
    self.requestPage = 1;

}
-(void)footerRereshing{
    self.requestPage += 1;

}
-(NSMutableArray *)commonAction:(id)obj dataArray:(NSMutableArray *)dataArray{
    NSMutableArray * nnnArray = [NSMutableArray arrayWithArray:dataArray];
    if (self.requestPage == 1) {
        [nnnArray removeAllObjects];
        [nnnArray addObjectsFromArray:obj];
    }else{
        if ([obj count] == 0) {
            [_yxTableView.mj_footer endRefreshing];
        }
        nnnArray = [NSMutableArray arrayWithArray:[nnnArray arrayByAddingObjectsFromArray:obj]];
    }
    DO_IN_MAIN_QUEUE_AFTER(0.5f, ^{
        [_yxTableView.mj_header endRefreshing];
        [_yxTableView.mj_footer endRefreshing];
    });
    return nnnArray;
}
-(NSMutableArray *)commonCollectionAction:(id)obj dataArray:(NSMutableArray *)dataArray{

    NSMutableArray * nnnArray = [NSMutableArray arrayWithArray:dataArray];
    if (self.requestPage == 1) {
        [nnnArray removeAllObjects];
        [nnnArray addObjectsFromArray:obj];
    }else{
        if ([obj count] == 0) {
//            [QMUITips showInfo:REFRESH_NO_DATA inView:self.view hideAfterDelay:1];
            [_collectionView.mj_footer endRefreshing];
        }
        nnnArray = [NSMutableArray arrayWithArray:[nnnArray arrayByAddingObjectsFromArray:obj]];
    }
    DO_IN_MAIN_QUEUE_AFTER(0.5f, ^{
        [_yxCollectionView.mj_header endRefreshing];
        [_yxCollectionView.mj_footer endRefreshing];
    });
    return nnnArray;
}
/**
 *  懒加载UITableView
 *
 *  @return UITableViewT
 */
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight -kTabBarHeight) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header = header;
        
        //底部刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        _tableView.backgroundColor=CViewBgColor;
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenHeight - kTopHeight - kTabBarHeight) collectionViewLayout:flow];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _collectionView.mj_header = header;
        
        //底部刷新
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        
        _collectionView.backgroundColor=CViewBgColor;
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}
/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        [self addNavigationItemWithImageNames:@[@"返回键"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)backBtnClicked
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark ————— 导航栏 添加图片按钮 —————
/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
        UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //将宽度设为负值
        spaceItem.width= -5;
        [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(5.5, 0, 5.5, 0)];
        }else{
            if (tags.count > 0 && [tags[0] integerValue] == 999) {
                [btn setImageEdgeInsets:UIEdgeInsetsMake(6.5, 30, 6.5, 4)];

            }else{
                [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];

            }

        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

#pragma mark ————— 导航栏 添加文字按钮 —————
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = SYSTEMFONT(16);
        [btn setTitleColor:KBlackColor forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        //设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}

//取消请求
- (void)cancelRequest
{
    
}

- (void)dealloc
{
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    searchBar.showsCancelButton = YES;
//    //找到searchbar下得UINavigationButton即是cancel按钮，改变他即可
//    UIButton *searchBarCancelBtn = searchBar.subviews[0].subviews[2];
//    [searchBarCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [searchBarCancelBtn setTitleColor:[UIColor colorWithWhite:0.325 alpha:1.000] forState:UIControlStateNormal];
    return YES;
}
//监视搜索框的结果
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    NSLog(@"%@", searchText);
}
// called when keyboard search button pressed

#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXFindSearchHeadView" owner:self options:nil];
    _searchHeaderView = [nib objectAtIndex:0];
    _searchHeaderView.searchBar.delegate = self;
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = _searchHeaderView;
    

}
#pragma mark - gesture actions
- (void)cancleAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)textField1TextChange:(UITextField *)tf{
//    [self clickSearchBar];
}
-(void)setSegmentControllersArray:(NSArray *)controllers title:(NSArray *)titlesArray defaultIndex:(NSInteger)index top:(CGFloat)top view:(UIView *)view{
    ZXSegmentController* segmentController = [[ZXSegmentController alloc] initWithControllers:controllers
                                                                               withTitleNames:titlesArray
                                                                             withDefaultIndex:index
                                                                               withTitleColor:YXRGBAColor(129, 129, 129)
                                                                       withTitleSelectedColor:KBlackColor
                                                                              withSliderColor:KBlackColor
                                            ];
    segmentController.view.backgroundColor = KWhiteColor;
    segmentController.enableSwipeGestureRecognizer = NO;
    
    kWeakSelf(self);
    [self addChildViewController:(self.segmentController = segmentController)];
    [segmentController didMoveToParentViewController:self];
    [self.view addSubview:segmentController.view];
    [self createAutolayout:top];
}
- (void)createAutolayout:(CGFloat)top{
    [self.segmentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark - gesture actions
- (void)closeKeyboard:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}
-(void)fiveStarView:(CGFloat)score view:(UIView *)view{
    starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    starRateView.currentScore = score;
    starRateView.isAnimation = YES;
    starRateView.rateStyle = WholeStar;
    starRateView.tag = 1;
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [view addSubview:starRateView];
    starRateView.userInteractionEnabled = NO;
}

@end
