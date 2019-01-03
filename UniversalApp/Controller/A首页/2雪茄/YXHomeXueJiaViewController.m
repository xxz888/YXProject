
//
//  YXHomeXueJiaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaViewController.h"
#import "YXHomeXueJiaTableViewCell.h"
#import "YXHomeXueJiaHeaderView.h"

@interface YXHomeXueJiaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * bottomTableView;
@property(nonatomic,strong)YXHomeXueJiaHeaderView * headerView;

@end

@implementation YXHomeXueJiaViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    kWeakSelf(self);
    [YX_MANAGER requestGETAdvertising:@"1" success:^(id object) {
        
       
        [weakself.headerView setUpSycleScrollView:nil];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tableview列表
    [self createBottomTableView];
}



//tableview
-(void)createBottomTableView{
    if (!self.bottomTableView) {
        self.bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bootomView.frame.size.width, self.bootomView.frame.size.height) style:UITableViewStyleGrouped];
    }
    self.bottomTableView.delegate= self;
    self.bottomTableView.dataSource = self;
    [self.bootomView addSubview:self.bottomTableView];
    

}

//代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeXueJiaHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 400);
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 400;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YXHomeXueJiaTableViewCell";
    YXHomeXueJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[YXHomeXueJiaTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    return cell;
}
@end
