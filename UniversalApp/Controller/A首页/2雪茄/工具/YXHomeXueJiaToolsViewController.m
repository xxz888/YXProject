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

#import "YXHomeChiCunViewController.h"
#import "YXXingZhuangViewController.h"
#import "YXColorViewController.h"
@interface YXHomeXueJiaToolsViewController (){
    YXColorViewController * VC1;
    YXXingZhuangViewController * VC2;
    YXHomeChiCunViewController * VC3;
}

@end

@implementation YXHomeXueJiaToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工具";
    [self setSegment];
}
-(void)setSegment{
    if (!VC1) {
        VC1 = [[YXColorViewController alloc]init];
    }
    if (!VC2) {
        VC2 = [[YXXingZhuangViewController alloc]init];
    }
    if (!VC3) {
        VC3 = [[YXHomeChiCunViewController alloc]init];
    }
    
    
    NSArray* names = @[@"雪茄颜色",@"雪茄形状",@"尺寸工具"];
    NSArray* controllers = @[VC1,VC2,VC3];
    
    
    /*
     *   controllers长度和names长度必须一致，否则将会导致cash
     *   segmentController在一个屏幕里最多显示6个按钮，如果超过6个，将会自动开启滚动功能，如果不足6个，按钮宽度=父view宽度/x  (x=按钮个数)
     */
    ZXSegmentController* segmentController = [[ZXSegmentController alloc] initWithControllers:controllers
                                                                               withTitleNames:names
                                                                             withDefaultIndex:0
                                                                               withTitleColor:YXRGBAColor(153, 153, 153)
                                                                       withTitleSelectedColor:YXRGBAColor(161, 120, 58)
                                                                              withSliderColor:YXRGBAColor(161, 120, 58)];
    [self addChildViewController:(self.segmentController = segmentController)];
    [self.view addSubview:segmentController.view];
    [segmentController didMoveToParentViewController:self];
    [self createAutolayout];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [segmentController scrollToIndex:1 animated:YES];
    });
}
- (void)createAutolayout{
    /*
     高度自由化的布局，可以根据需求，把segmentController布局成你需要的样子.(面对不同的场景，设置不同的top距离)
     */
    [self.segmentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
}


@end
