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
@interface YXHomeViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    YXHomeTuiJianViewController * TuiJianVC;
    YXHomeXueJiaViewController * XueJiaVC;
    YXHomeMeiJiuViewController * MeiJiuVC;
    YXHomeGaoErFuViewController * GaoErFuVC;
}
@property (nonatomic) BOOL isCanBack;
@end

@implementation YXHomeViewController
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
    }
}
#pragma mark --恢复边缘返回
- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}

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
    NSArray* names = @[@"雪茄"];
    NSArray* controllers = @[XueJiaVC];
    [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:0 view:self.view];
}
@end
