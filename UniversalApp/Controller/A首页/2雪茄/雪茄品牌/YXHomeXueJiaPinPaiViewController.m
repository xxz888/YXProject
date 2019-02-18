//
//  YXHomeXueJiaPinPaiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiViewController.h"
#import "PYSearchViewController.h"
#import "PYSearch.h"
#import "PYTempViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeXueJiaFeiGuViewController.h"
#import "YXHomeXueJiaMyGuanZhuViewController.h"
#import "YXHomeXueJiaGuBaViewController.h"
@interface YXHomeXueJiaPinPaiViewController() <PYSearchViewControllerDelegate> {
        YXHomeXueJiaGuBaViewController *  VC1;
        YXHomeXueJiaFeiGuViewController*  VC2;
        YXHomeXueJiaMyGuanZhuViewController *  VC3;
        YXHomeXueJiaGuBaViewController *  VC4;
}
@end
@implementation YXHomeXueJiaPinPaiViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
    if (self.whereCome) {
        self.title = @"请选择品牌";
        [self addNavigationItemWithImageNames:@[@"返回键"] isLeft:YES target:self action:@selector(clickBackAction) tags:nil];
    }else{
        self.title = @"雪茄品牌";
        //[self setNavSearchView];
    }
    [self setInitCollection];
}
-(void)setInitCollection{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    if (!VC1) {
        VC1 = [[YXHomeXueJiaGuBaViewController alloc]init];
        VC1.whereCome = self.whereCome;
    }
    if (!VC2) {
        VC2 = [[YXHomeXueJiaFeiGuViewController alloc]init];
        VC2.whereCome = self.whereCome;
    }
    if (!VC3) {
        VC3 = [[YXHomeXueJiaMyGuanZhuViewController alloc]init];
    }
    if (!VC4) {
        VC4 = [stroryBoard instantiateViewControllerWithIdentifier:@"YXHomeXueJiaGuBaViewController"];
    }
    //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
    NSArray* names = self.whereCome ? @[@"古巴",@"非古"] : @[@"古巴",@"非古",@"我的关注"];
    NSArray* controllers = @[VC1,VC2,VC3];
    [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:self.whereCome ? kTopHeight : kTopHeight view:self.view];
}
-(void)clickBackAction{
    [self finishPublish];
}
#pragma mark - 完成发布
//完成发布
-(void)finishPublish{
    //2.block传值
    if (self.mDismissBlock != nil) {
        self.mDismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//block声明方法
-(void)toDissmissSelf:(dismissBlock)block{
    self.mDismissBlock = block;
}
@end
