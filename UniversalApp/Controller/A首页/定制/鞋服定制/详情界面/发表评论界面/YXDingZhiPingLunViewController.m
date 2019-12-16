//
//  YXDingZhiPingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiPingLunViewController.h"

@interface YXDingZhiPingLunViewController ()

@end

@implementation YXDingZhiPingLunViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backVcaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
