//
//  YXMineMyDianZanViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineMyDianZanViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineImageDetailViewController.h"
@interface YXMineMyDianZanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YXMineMyDianZanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的点赞";
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineEssayTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineEssayTableViewCell"];
    self.yxTableView.separatorStyle = 0;
    [self addRefreshView:self.yxTableView];
    [self requestMyDianZanLIst];
 
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestMyDianZanLIst];

}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestMyDianZanLIst];

}
-(void)requestMyDianZanLIst{
    kWeakSelf(self);
    [YX_MANAGER requestMyDianZanList:NSIntegerToNSString(self.requestPage) success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 508;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineEssayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineEssayTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.likeBtn.hidden = YES;
    NSString * str = [(NSMutableString *)dic[@"photo"] replaceAll:@" " target:@"%20"];
    [cell.essayTitleImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.essayNameLbl.text = dic[@"user_name"];
    cell.essayTimeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    
    //自定义
    NSString * str1 = [(NSMutableString *)dic[@"photo1"] replaceAll:@" " target:@"%20"];
    NSURL * url = [NSURL URLWithString:str1];
    UIImageView * mineImageView = [[UIImageView alloc]init];
    mineImageView.frame = CGRectMake(0, 0, KScreenWidth-10, cell.midView.frame.size.height);
    [cell.midView addSubview:mineImageView];
    [mineImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_moren"]];
    ViewRadius(mineImageView, 3);
    cell.mineImageLbl.text = [dic[@"describe"] UnicodeToUtf8];
    cell.mineTimeLbl.text = dic[@"publish_site"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:VC animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
