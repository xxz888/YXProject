//
//  YXMineJIFenLishiChildViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/1.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineJIFenLishiChildViewController.h"
#import "YXMineJiFenLiShiChildTableViewCell.h"

@interface YXMineJIFenLishiChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * yxTableView;

@end

@implementation YXMineJIFenLishiChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableviewCon];
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    
    self.yxTableView = [[UITableView alloc]init];
    self.yxTableView.frame = CGRectMake(0,0, KScreenWidth,self.view.frame.size.height-kTopHeight-120);
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineJiFenLiShiChildTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineJiFenLiShiChildTableViewCell"];
    [self.view addSubview:self.yxTableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineJiFenLiShiChildTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineJiFenLiShiChildTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = 0;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
