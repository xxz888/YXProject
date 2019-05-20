//
//  YXQCDJCHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/17.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXQCDJCHeaderView.h"
#define demoURL @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2797616721,1483253964&fm=26&gp=0.jpg"

@implementation YXQCDJCHeaderView


- (void)drawRect:(CGRect)rect {
    [self.headerView addSubview:[ShareManager setUpSycleScrollView:@[demoURL]]];
}


@end
