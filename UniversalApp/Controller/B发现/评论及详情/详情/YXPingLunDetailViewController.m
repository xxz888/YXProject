//
//  YXPingLunDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXPingLunDetailViewController.h"
#import "YXChildPingLunTableViewCell.h"
#import "YXChildFootView.h"
@interface YXPingLunDetailViewController ()

@end

@implementation YXPingLunDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
}
//初始化控件
-(void)initControl{
    self.navigationController.navigationBar.hidden = YES;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXChildPingLunTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXChildPingLunTableViewCell"];
    [self.yxTableView reloadData];
    [self addShadowToView:self.bottomView withColor:kRGBA(102, 102, 102, 0.08)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXChildFootView" owner:self options:nil];
    YXChildFootView * footView = [nib objectAtIndex:0];
    return footView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 46;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXChildPingLunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXChildPingLunTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,-4);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 5;
    theView.layer.cornerRadius = 5;
    
}

@end
