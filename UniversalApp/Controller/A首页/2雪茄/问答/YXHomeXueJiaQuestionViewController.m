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
    UIButton * btn = [UIButton buttonWithType:0];
    [btn setTitle:@"发布提问" forState:UIControlStateNormal];
    btn.backgroundColor = YXRGBAColor(38, 38, 38);
    btn.tintColor = YXRGBAColor(145, 123, 67);
    btn.frame = CGRectMake(0, KScreenHeight-50, KScreenWidth,   50);
    [btn addTarget:self action:@selector(pushTiWen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
     self.yxTableView.frame = CGRectMake(0, kTopHeight, k_screen_width, k_screen_height-kTopHeight-50);
     [self requestQuestion];
}
-(void)pushTiWen{
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    YXHomeQuestionFaBuViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeQuestionFaBuViewController"];
    [self.navigationController pushViewController:VC animated:YES];
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
