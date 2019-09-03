//
//  YXMineJiFenTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/8/30.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineJiFenTableViewController.h"
#import "YXMineJiFenHistoryViewController.h"
#import "YXMineQianDaoView.h"
#import "YXMineChouJiangViewController.h"

@interface YXMineJiFenTableViewController ()

@end

@implementation YXMineJiFenTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kRGBA(10, 36, 54, 1);
    ViewRadius(self.accImv, 36);
    ViewRadius(self.qiandaoBtn, 11);
    [self.qiandaoBtn setBackgroundColor:kRGBA(10, 36, 54, 1)];
    ViewRadius(self.qiandaoView, 5);
    
    ViewBorderRadius(self.finish1, 11, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish2, 11, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish3, 11, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish4, 11, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish5, 11, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish6, 11, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish7, 11, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish8, 11, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish9, 11, 1, kRGBA(10, 36, 54, 1));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)qiandaoAction:(id)sender {
    
    [self.qiandaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
    [self.qiandaoBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [self.qiandaoBtn setBackgroundColor:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0]];
    self.qiandaoBtn.userInteractionEnabled = NO;
 
    [self handleShowContentView];
}
- (IBAction)jifenHistoryAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXMineJiFenHistoryViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineJiFenHistoryViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}






- (void)handleShowContentView {
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXMineQianDaoView" owner:self options:nil];
    YXMineQianDaoView * contentView = [nib objectAtIndex:0];
    contentView.frame = CGRectMake(20, 110, KScreenWidth-40, 403);
    contentView.backgroundColor = KClearColor;
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
//    modalViewController.contentViewMargins = UIEdgeInsetsMake(0, modalViewController.view.frame.size.width/2, 0, 0);
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",self.tableView.contentOffset.y);
    if (self.tableView.contentOffset.y <= 0) {
        self.tableView.bounces = NO;
        
        NSLog(@"禁止下拉");
    }
    else
        if (self.tableView.contentOffset.y >= 0){
            self.tableView.bounces = YES;
            NSLog(@"允许上拉");
            
        }
}
- (IBAction)jifenshangchengAction:(id)sender {
    [self.navigationController pushViewController:[YXMineChouJiangViewController new] animated:YES];
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint offset = tableV.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    tableV.contentOffset = offset;
//}
@end
