//
//  YXHomeViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeViewController.h"


#import "YXHomeTuiJianViewController.h"
#import "YXHomeXueJiaViewController.h"
#import "YXHomeMeiJiuViewController.h"
#import "YXHomeGaoErFuViewController.h"
@interface YXHomeViewController ()<UINavigationControllerDelegate>{
    YXHomeTuiJianViewController * TuiJianVC;
    YXHomeXueJiaViewController * XueJiaVC;
    YXHomeMeiJiuViewController * MeiJiuVC;
    YXHomeGaoErFuViewController * GaoErFuVC;
}

@end

@implementation YXHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
//    if (!TuiJianVC) {
//        TuiJianVC = [[YXHomeTuiJianViewController alloc]init];
//    }
    if (!XueJiaVC) {
        XueJiaVC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaViewController"];
    }
//    if (!MeiJiuVC) {
//        MeiJiuVC = [[YXHomeMeiJiuViewController alloc]init];
//    }
    if (!GaoErFuVC) {
        GaoErFuVC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeGaoErFuViewController"];
    }
    NSArray* names = @[@"推荐",@"雪茄",@"美酒",@"高尔夫"];
    NSArray* controllers = @[XueJiaVC,XueJiaVC,GaoErFuVC,GaoErFuVC];
    [self setSegmentControllersArray:controllers title:names defaultIndex:1 top:64 view:self.view];
}
@end
