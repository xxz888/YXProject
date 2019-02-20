//
//  YXFindSearchResultAllViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultAllViewController.h"
#import "PYSearchViewController.h"
#import "PYSearch.h"
#import "PYTempViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineEssayDetailViewController.h"
#import "YXMineImageDetailViewController.h"
#import "YXMineViewController.h"
#import "YXMineImageCollectionViewCell.h"

#import "YXFindImageTableViewCell.h"
#import "YXFindQuestionTableViewCell.h"
#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "Moment.h"
#import "Comment.h"
#import "YXMineFootDetailViewController.h"
@interface YXFindSearchResultAllViewController ()<PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSString * type;

@end

@implementation YXFindSearchResultAllViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //其他方法
    [self setOtherAction];
    //请求
    [self requestAction];
}
-(void)setOtherAction{
    self.title = @"发现";
    self.isShowLiftBack = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.yxTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight-TabBarHeight);
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestFindAll:self.key];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestFindAll:self.key];
}
-(void)requestAction{
    [self requestFindAll:self.key];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

}
#pragma mark ========== 1111111-先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindAll:(NSString *)key{
    if (!key) {
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestSearchFind_all:@{@"key":key,@"page":NSIntegerToNSString(self.requestPage),@"type":@"1"} success:^(id object) {
        if ([object count] > 0) {
            NSMutableArray *_dataSourceTemp=[NSMutableArray new];
            for (NSDictionary *company in object) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:company];
                [dic setObject:@"0" forKey:@"isShowMoreText"];
                [_dataSourceTemp addObject:dic];
            }
            object=_dataSourceTemp;
        }
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}

@end
