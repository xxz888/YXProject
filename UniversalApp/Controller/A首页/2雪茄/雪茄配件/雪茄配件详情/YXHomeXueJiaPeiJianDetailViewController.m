//
//  YXHomeXueJiaPeiJianDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPeiJianDetailViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXHomeXueJiaPeiJianDetailTuiJianViewController.h"
@interface YXHomeXueJiaPeiJianDetailViewController (){
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC1;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC2;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC3;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC4;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC5;
    YXHomeXueJiaPeiJianDetailTuiJianViewController * VC6;

}

@end

@implementation YXHomeXueJiaPeiJianDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.startDic[@"brand_name"];

    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    VC1 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC1.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC1.segIndex = @"1";
    
    VC2 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC2.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC2.segIndex = @"2";

    VC3 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC3.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC3.segIndex = @"3";

    VC4 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC4.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC4.segIndex = @"4";

    VC5 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC5.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC5.segIndex = @"5";

    VC6 = [[YXHomeXueJiaPeiJianDetailTuiJianViewController alloc]init];
    VC6.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    VC4.segIndex = @"6";

    NSArray* names = @[@"推荐",@"雪茄剪",@"打火机",@"保湿盒",@"雪茄盒",@"烟灰缸"];
    NSArray* controllers = @[VC1,VC2,VC3,VC4,VC5,VC6];
    [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:kTopHeight view:self.view  ];
}


@end
