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
    [cell.footImageVIew sd_setImageWithURL:[NSURL URLWithString:dicTag[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    
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
            break;
        case 2:_isreverse2 = [_isreverse2 isEqualToString:@"1"] ? @"0" : @"1";
            [self requestZuJi:_isreverse2];

            break;
        case 3:_isreverse3 = [_isreverse2 isEqualToString:@"1"] ? @"0" : @"1";
            [self requestZuJi:_isreverse3];

            break;
        case 4:_isreverse4 = [_isreverse2 isEqualToString:@"1"] ? @"0" : @"1";
            [self requestZuJi:_isreverse4];

            break;
        default:
            break;
    }
}

@end
