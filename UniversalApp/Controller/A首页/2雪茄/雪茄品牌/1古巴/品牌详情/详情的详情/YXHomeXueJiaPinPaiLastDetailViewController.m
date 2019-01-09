//
//  YXHomeXueJiaPinPaiLastDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiLastDetailViewController.h"

@interface YXHomeXueJiaPinPaiLastDetailViewController ()

@end

@implementation YXHomeXueJiaPinPaiLastDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //请求评价列表 平均分
//    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"1"] success:^(id object) {
//
//    }];
    
//    //请求评价列表 个人分
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"2"] success:^(id object) {

    }];
//
//    //请求评价列表 最新评论列表
//    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"3"] success:^(id object) {
//
//    }];
//
//    //请求评价列表 最热评论列表
//    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"4"] success:^(id object) {
//
//    }];
}
-(NSString *)getParamters:(NSString *)type{
    return [NSString stringWithFormat:@"%@/%@",type,self.startDic[@"id"]];
}
@end
