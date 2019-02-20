//
//  YXFindSearchResultTagViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultTagViewController.h"
#import "YXHomeXueJiaTableViewCell.h"
@interface YXFindSearchResultTagViewController ()

@end

@implementation YXFindSearchResultTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.isShowLiftBack = YES;
    self.title = self.key;
    self.yxTableView.frame = CGRectMake(0, kTopHeight + 30 + 5, KScreenWidth, KScreenHeight-kTopHeight - 30 - 5);
    [self requestHotAndNew:@"3"];
}
-(void)requestHotAndNew:(NSString *)type{
    kWeakSelf(self);
    [YX_MANAGER requestSearchFind_all:@{@"key":self.key,@"page":NSIntegerToNSString(self.requestPage),@"type":type} success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    sender.selectedSegmentIndex == 0 ?     [self requestHotAndNew:@"3"] :     [self requestHotAndNew:@"4"];

}
@end
