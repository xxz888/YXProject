//
//  YXFindSearchResultUsersViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultUsersViewController.h"
#import "YXFindSearchTableViewCell.h"
#import "YXFindSearchResultTagViewController.h"

@interface YXFindSearchResultUsersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * yxTableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXFindSearchResultUsersViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self requestFindAll_user:self.key];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    [self createyxTableView];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestFindAll_user:self.key];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestFindAll_user:self.key];
}
-(void)requestAction{
    [self requestFindAll_user:self.key];
}
-(void)createyxTableView{
    if (!self.yxTableView) {
        self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-40) style:UITableViewStylePlain];
        self.yxTableView.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:self.yxTableView];
    }
    self.yxTableView.backgroundColor = KWhiteColor;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindSearchTableViewCell"];
    self.yxTableView.delegate= self;
    self.yxTableView.dataSource = self;
    self.yxTableView.separatorStyle = 0;
    
}


-(void)requestFindAll_user:(NSString *)key{
    if (!key) {
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestFind_user:@{@"name":key,@"page":NSIntegerToNSString(self.requestPage),@"name_unicode":[key utf8ToUnicode]} success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YXFindSearchTableViewCell";
    YXFindSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.cellImageView.layer.masksToBounds = YES;
    cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.size.width / 2.0;
    NSString * str = [(NSMutableString *)self.dataArray[indexPath.row][@"photo"] replaceAll:@" " target:@"%20"];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.cellLbl.text = self.dataArray[indexPath.row][@"username"];
    cell.cellAutherLbl.text = self.dataArray[indexPath.row][@"site"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


@end
