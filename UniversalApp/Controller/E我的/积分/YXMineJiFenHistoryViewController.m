//
//  YXMineJiFenHistoryViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/1.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineJiFenHistoryViewController.h"
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXMineJIFenLishiChildViewController.h"

@interface YXMineJiFenHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic,strong) NSMutableArray * titlesArr;
@property (nonatomic,strong) NSMutableArray * vcArr;


@end

@implementation YXMineJiFenHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcArr = [NSMutableArray array];
    self.titlesArr = [NSMutableArray array];
    
    YXMineJIFenLishiChildViewController * vc = [[YXMineJIFenLishiChildViewController alloc]init];
    vc.type = @"1";
    YXMineJIFenLishiChildViewController * vc1 = [[YXMineJIFenLishiChildViewController alloc]init];
    vc1.type = @"2";
    YXMineJIFenLishiChildViewController * vc2 = [[YXMineJIFenLishiChildViewController alloc]init];
    vc2.type = @"3";

    [self.vcArr addObject:vc];
    [self.vcArr addObject:vc1];
    [self.vcArr addObject:vc2];
    
    [self.titlesArr addObject:@"全部"];
    [self.titlesArr addObject:@"收入"];
    [self.titlesArr addObject:@"支出"];

    [self initSegment];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}
-(void)initSegment{
    [self addChildViewController:self.segmentedPageViewController];
    [self.bottomView addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    kWeakSelf(self);
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.bottomView).mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (HGSegmentedPageViewController *)segmentedPageViewController{
    if (!_segmentedPageViewController) {
        
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.categoryView.titleNomalFont = [UIFont systemFontOfSize:16];
        _segmentedPageViewController.categoryView.titleSelectedFont = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        _segmentedPageViewController.categoryView.titleSelectedColor = SEGMENT_COLOR;
        _segmentedPageViewController.pageViewControllers = self.vcArr.copy;
        _segmentedPageViewController.categoryView.titles = self.titlesArr;
        _segmentedPageViewController.categoryView.originalIndex = 0;
    }
    return _segmentedPageViewController;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
