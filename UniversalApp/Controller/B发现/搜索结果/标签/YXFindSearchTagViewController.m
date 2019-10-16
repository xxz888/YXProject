//
//  YXFindSearchTagViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchTagViewController.h"
#import "YXFindSearchTableViewCell.h"
#import "YXFindSearchResultTagViewController.h"
#import "YXFindSearchTagDetailViewController.h"
@interface YXFindSearchTagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * yxTableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXFindSearchTagViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self requestFindAll_Tag:self.key];
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
    [self requestFindAll_Tag:self.key];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestFindAll_Tag:self.key];
}
-(void)requestAction{
    [self requestFindAll_Tag:self.key];
}
-(void)createyxTableView{
    if (!self.yxTableView) {
        self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-40) style:UITableViewStylePlain];
        [self.view addSubview:self.yxTableView];
    }
    self.yxTableView.backgroundColor = KWhiteColor;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindSearchTableViewCell"];
    self.yxTableView.delegate= self;
    self.yxTableView.dataSource = self;
    self.yxTableView.separatorStyle = 0;
    
}

#pragma mark ========== 1111111-先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindAll_Tag:(NSString *)key{
    if (!key) {
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestSearchFind_all:@{@"key":key,@"key_unicode":[key utf8ToUnicode],@"page":NSIntegerToNSString(self.requestPage),@"type":@"2"} success:^(id object) {
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
    NSString * photo = [str contains:IMG_OLD_URI] ? [str replaceAll:IMG_OLD_URI target:IMG_URI] : str;
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.cellLbl.text =  self.dataArray[indexPath.row][@"tag"] ;
    cell.cellAutherLbl.text = kGetString(self.dataArray[indexPath.row][@"count_tag"]);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
    VC.type = @"3";
    VC.key = self.dataArray[indexPath.row][@"tag"];
    VC.startDic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
    
}

@end
