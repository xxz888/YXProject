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
{
    NSString * _sort;
    NSString * _isreverse1;
    NSString * _isreverse2;
    NSString * _isreverse3;
    NSString * _isreverse4;

}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;

@end

@implementation YXHomeXueJiaFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"品鉴足迹";
    self.dataArray = [[NSMutableArray alloc]init];
    _sort = @"1";
    _isreverse1 = _isreverse2 = _isreverse3 = _isreverse4 = @"1";
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaFootTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaFootTableViewCell"];
    self.yxTableView.delegate=  self;
    self.yxTableView.dataSource = self;
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    [self addRefreshView:self.yxTableView];

    [self requestZuJi:_isreverse1];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestZuJi:_isreverse1];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestZuJi:_isreverse1];

}
-(void)requestZuJi:(NSString *)isreverse{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@/%@",NSIntegerToNSString(self.requestPage),_sort,isreverse];
    [YX_MANAGER requestGetMy_Track_list:par success:^(id object) {


        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
-(void)setFourButton{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaFootTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaFootTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSDictionary * dicTag = dic[@"cigar_info"];
    NSString * str = [(NSMutableString *)dicTag[@"photo"] replaceAll:@" " target:@"%20"];
    [cell.footImageVIew sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    
    NSString * string1 = [NSString stringWithFormat:@"%@/%@",dicTag[@"brand_name"],dicTag[@"cigar_name"]];
    cell.footTitleLbl.text = string1;
    
    NSString * string2 = [NSString stringWithFormat:@"售价:%@元/支",dicTag[@"price_single_china"]];
    cell.footPriceLbl.text = string2;
    
    NSString * string3 =[@"添加于 " append:[ShareManager timestampSwitchTime:[dic[@"publish_time"] longLongValue] andFormatter:@""]];
    cell.footTimeLbl.text = string3;
    
    [self fiveStarView:[dicTag[@"comment_avg"][@"average_score__avg"] floatValue] view:cell.footStarView];
    return cell;
}
- (IBAction)fourBtnAction:(UIButton *)sender{
    _sort = NSIntegerToNSString(sender.tag);
    switch (sender.tag) {
        case 1:_isreverse1 = [_isreverse1 isEqualToString:@"1"] ? @"0" : @"1";
            [self requestZuJi:_isreverse1];
            BOOL isReverseBool1 = [_isreverse1 isEqualToString:@"1"] ? YES : NO;
            [self.timeBtn setTitle:isReverseBool1 ? @"时间↑":@"时间↓" forState:UIControlStateNormal];
            
            [self.nameBtn setTitle:@"名字" forState:UIControlStateNormal];
            [self.priceBtn setTitle:@"价格" forState:UIControlStateNormal];
            [self.scoreBtn setTitle:@"评分" forState:UIControlStateNormal];
            break;
        case 2:_isreverse2 = [_isreverse2 isEqualToString:@"1"] ? @"0" : @"1";
            [self requestZuJi:_isreverse2];
            BOOL isReverseBool2 = [_isreverse2 isEqualToString:@"1"] ? YES : NO;
            [self.nameBtn setTitle:isReverseBool2 ? @"名字↑":@"名字↓" forState:UIControlStateNormal];
            
            
            [self.timeBtn setTitle:@"时间" forState:UIControlStateNormal];
            [self.priceBtn setTitle:@"价格" forState:UIControlStateNormal];
            [self.scoreBtn setTitle:@"评分" forState:UIControlStateNormal];
            break;
        case 3:_isreverse3 = [_isreverse3 isEqualToString:@"1"] ? @"0" : @"1";
            [self requestZuJi:_isreverse3];
            BOOL isReverseBool3 = [_isreverse3 isEqualToString:@"1"] ? YES : NO;
            [self.priceBtn setTitle:isReverseBool3 ? @"价格↑":@"价格↓" forState:UIControlStateNormal];
            
            [self.timeBtn setTitle:@"时间" forState:UIControlStateNormal];
            [self.nameBtn setTitle:@"名字" forState:UIControlStateNormal];
            [self.scoreBtn setTitle:@"评分" forState:UIControlStateNormal];
            break;
        case 4:_isreverse4 = [_isreverse4 isEqualToString:@"1"] ? @"0" : @"1";
            [self requestZuJi:_isreverse4];
            BOOL isReverseBool4 = [_isreverse4 isEqualToString:@"1"] ? YES : NO;
            [self.scoreBtn setTitle:isReverseBool4 ? @"评分↑":@"评分↓" forState:UIControlStateNormal];
            
            
            [self.timeBtn setTitle:@"时间" forState:UIControlStateNormal];
            [self.nameBtn setTitle:@"名字" forState:UIControlStateNormal];
            [self.priceBtn setTitle:@"价格" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

@end
