
//
//  YXHomeXueJiaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaViewController.h"
#import <ZXSegmentController/ZXSegmentController.h>
#import "HGSegmentedPageViewController.h"
#import "SocketRocketUtility.h"
#import "YXHomeXueJiaToolsViewController.h"
#import "JQFMDB.h"
#import "MessageModel.h"
#import "YXDingZhiViewController.h"
@interface YXHomeXueJiaViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic) BOOL isCanBack;
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic,strong) NSMutableArray * titlesArr;



@end

@implementation YXHomeXueJiaViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];

    
    [[SocketRocketUtility instance] SRWebSocketStart];
    
    JQFMDB *db = [JQFMDB shareDatabase];
    if (![db jq_isExistTable:YX_USER_LiaoTian]) {
      [db jq_createTable:YX_USER_LiaoTian dicOrModel:[MessageModel class]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcArr = [NSMutableArray array];
    self.titlesArr = [NSMutableArray array];
    [self requestZhiNan1Get];



}
-(void)requestZhiNan1Get{
      kWeakSelf(self);
    
      YXHomeXueJiaToolsViewController * toolsVC = [[YXHomeXueJiaToolsViewController alloc]init];
      toolsVC.startId = @"5";
    
      YXDingZhiViewController * dingzhiVC = [[YXDingZhiViewController alloc]init];
      [weakself.vcArr addObject:toolsVC];
//      [weakself.vcArr addObject:dingzhiVC];

      [weakself.titlesArr addObject:@"指南"];
//      [weakself.titlesArr addObject:@"定制"];
    
      [weakself initSegment];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];

}
-(void)initSegment{
    [self addChildViewController:self.segmentedPageViewController];
    [self.view addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    kWeakSelf(self);
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view).mas_offset(UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0));
    }];
    
    //添加搜索框
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(15, 50, KScreenWidth-30, 30)];
    searchView.layer.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor;
    searchView.layer.cornerRadius = 15;
//    [self.segmentedPageViewController.view addSubview:searchView];
    
    
    UIImageView * fangdajingView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 18, 18)];
    fangdajingView.image = [UIImage imageNamed:@"放大镜"];
    [searchView addSubview:fangdajingView];
    
    UILabel * fangdajingLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 100, 30)];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"搜索蓝皮书"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    
    fangdajingLabel.attributedText = string;
    fangdajingLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    fangdajingLabel.textAlignment = NSTextAlignmentLeft;
    fangdajingLabel.alpha = 1.0;
    [searchView addSubview:fangdajingLabel];
    
}
- (HGSegmentedPageViewController *)segmentedPageViewController{
    if (!_segmentedPageViewController) {
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.categoryView.titleNomalFont = BOLDSYSTEMFONT(18);
        _segmentedPageViewController.categoryView.titleSelectedFont =  BOLDSYSTEMFONT(24);
        _segmentedPageViewController.categoryView.titleSelectedColor = SEGMENT_COLOR;
        _segmentedPageViewController.pageViewControllers = self.vcArr.copy;
        _segmentedPageViewController.categoryView.titles = self.titlesArr;
        _segmentedPageViewController.categoryView.originalIndex = 0;
    }
    return _segmentedPageViewController;
}
@end
