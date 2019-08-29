//
//  YXMineAboutUsViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/8/29.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineAboutUsViewController.h"

@interface YXMineAboutUsViewController ()

@end

@implementation YXMineAboutUsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
}

@end
