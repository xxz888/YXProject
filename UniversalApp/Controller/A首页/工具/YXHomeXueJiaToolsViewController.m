//
//  YXHomeXueJiaToolsViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaToolsViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeYiFuViewController.h"
#import "YXHomeChiCunViewController.h"
#import "YXXingZhuangViewController.h"
#import "YXColorViewController.h"
#import "HGSegmentedPageViewController.h"
@interface YXHomeXueJiaToolsViewController (){
    YXColorViewController * VC1;
    YXXingZhuangViewController * VC2;
    YXHomeChiCunViewController * VC3;
    YXHomeYiFuViewController * yifuVC;
    
}
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;

@end

@implementation YXHomeXueJiaToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工具";
//    [self setSegment];
    
    
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
        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        yifuVC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeYiFuViewController"];
        
        VC1 = [[YXColorViewController alloc]init];
        VC2 = [[YXXingZhuangViewController alloc]init];
        VC3 = [[YXHomeChiCunViewController alloc]init];
        
        
        NSArray *titles = @[@"套装搭配",@"雪茄颜色",@"雪茄形状",@"尺寸工具"];
        NSArray *controllers = @[yifuVC,VC1,VC2,VC3];
        
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.pageViewControllers = controllers.copy;
        _segmentedPageViewController.categoryView.titles = titles;
        _segmentedPageViewController.categoryView.originalIndex = 0;
    }
    return _segmentedPageViewController;
}


@end
