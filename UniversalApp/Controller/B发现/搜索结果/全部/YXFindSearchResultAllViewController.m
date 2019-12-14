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
#import "YXMineImageDetailViewController.h"
#import "Moment.h"
#import "Comment.h"
#import "NSString+CString.h"
@interface YXFindSearchResultAllViewController ()< UITextFieldDelegate,PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
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
    self.searchHeaderView.findTextField.delegate = self;
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self requestFindAll:textField.text];
    return YES;
}
#pragma mark ========== 1111111-先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindAll:(NSString *)string{
    if (!string) {
        return;
    }
    
    kWeakSelf(self);
    if ([string contains:@"#"]) {string = [string split:@"#"][1];}
    [YX_MANAGER requestSearchFind_all:@{@"key":string,@"page":NSIntegerToNSString(self.requestPage),@"type":@"1",@"key_unicode":string} success:^(id object) {
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
@end
