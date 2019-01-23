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
    [self setSegmentControllersArray:controllers title:names defaultIndex:1 top:64 view:self.view ];

}


@end
