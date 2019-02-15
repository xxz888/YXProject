//
//  YXHomeXueJiaQuestionViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaQuestionViewController.h"
#import "MomentCell.h"
#import "Moment.h"
#import "Comment.h"
#import "MLLabel.h"
#import <MLLinkLabel.h>
#import "PYSearchViewController.h"
#import "PYTempViewController.h"
#import "YXHomeQuestionFaBuViewController.h"

@interface YXHomeXueJiaQuestionViewController ()
@property (nonatomic, strong) NSMutableArray *momentList;
@property (nonatomic, strong) NSMutableArray *picArray;

@end

@implementation YXHomeXueJiaQuestionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"问答";
     self.yxTableView.frame = CGRectMake(0, kTopHeight, k_screen_width, k_screen_height-kTopHeight);
     [self requestQuestion];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestQuestion];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestQuestion];
    
}
-(void)requestQuestion{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/kw/%@",self.whereCome,   NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestQuestionGET:par success:^(id object) {
        if ([object count] > 0) {
            NSMutableArray *_dataSourceTemp=[NSMutableArray new];
            for (NSDictionary *company in object) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:company];
                [dic setObject:@"3" forKey:@"obj"];
                [_dataSourceTemp addObject:dic];
            }
            object=_dataSourceTemp;
        }
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
