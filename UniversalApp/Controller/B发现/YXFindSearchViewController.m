//
//  YXFindSearchViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchViewController.h"
#import "YXFindSearchHeadView.h"

@interface YXFindSearchViewController ()
@property(nonatomic,strong)YXFindSearchHeadView * findSearchView;
@end

@implementation YXFindSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.translucent = NO;
    

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
