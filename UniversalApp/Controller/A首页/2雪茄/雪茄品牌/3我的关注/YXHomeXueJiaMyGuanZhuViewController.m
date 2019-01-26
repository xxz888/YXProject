//
//  YXHomeXueJiaMyGuanZhuViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/26.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaMyGuanZhuViewController.h"

@interface YXHomeXueJiaMyGuanZhuViewController ()

@end

@implementation YXHomeXueJiaMyGuanZhuViewController
-(void)viewWillAppear:(BOOL)animated{
    [self requestGETMyGuanZhuList];
}
-(void)requestGETMyGuanZhuList{
    kWeakSelf(self);
    [YX_MANAGER requestGETMyGuanZhuList:@"" success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.hotDataArray removeAllObjects];
        weakself.dataArray = [weakself userSorting:[NSMutableArray arrayWithArray:object]];
        [weakself.hotDataArray addObjectsFromArray:object];
        [weakself createMiddleCollection];
        [weakself.yxTableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
