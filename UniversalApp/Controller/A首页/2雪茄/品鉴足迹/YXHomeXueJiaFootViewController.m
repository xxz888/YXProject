//
//  YXHomeXueJiaFootViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaFootViewController.h"
#import "YXHomeXueJiaFootTableViewCell.h"
@interface YXHomeXueJiaFootViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YXHomeXueJiaFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"品鉴足迹";
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaFootTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaFootTableViewCell"];
    self.yxTableView.delegate=  self;
    self.yxTableView.dataSource = self;
    
}
-(void)setFourButton{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaFootTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaFootTableViewCell" forIndexPath:indexPath];
    
    return cell;
}

@end
