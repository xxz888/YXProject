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
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
@end
