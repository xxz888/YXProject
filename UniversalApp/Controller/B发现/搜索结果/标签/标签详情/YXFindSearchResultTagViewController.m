//
//  YXFindSearchResultTagViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultTagViewController.h"

@interface YXFindSearchResultTagViewController ()

@end

@implementation YXFindSearchResultTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    self.yxTableView.frame = CGRectMake(0, kTopHeight + 30 + 5, KScreenWidth, KScreenHeight-kTopHeight - 30 - 5);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
