//
//  YXMineAllViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAllViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineAllViewController ()

@end

@implementation YXMineAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id obj = UserDefaultsGET(@"a2");
    id obj1 = UserDefaultsGET(@"a2");

    //user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
#pragma mark ========== 我自己的所有 ==========
-(void)requestMine_AllList{
    kWeakSelf(self);
    [YX_MANAGER requestGetSersAllList:@"1" success:^(id object) {
    }];
}
#pragma mark ========== 其他用户的所有 ==========
-(void)requestOther_AllList{
    kWeakSelf(self);
    [YX_MANAGER requestGetSers_Other_AllList:[self.userId append:@"/1"] success:^(id object) {
        UserDefaultsSET(object, @"a2");
    }];
}


@end
