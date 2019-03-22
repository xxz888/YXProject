//
//  YXMinePingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMinePingLunViewController.h"
#import "YXMinePingLunTableViewCell.h"

@interface YXMinePingLunViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableVIew;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation YXMinePingLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的点评";
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableVIew registerNib:[UINib nibWithNibName:@"YXMinePingLunTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMinePingLunTableViewCell"];
    self.yxTableVIew.tableFooterView = [[UIView alloc]init];
    [self addRefreshView:self.yxTableVIew];
    [self requestMyDianPing];
    self.yxTableVIew.separatorStyle = 0 ;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)headerRereshing{
    [super headerRereshing];
    [self requestMyDianPing];

}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestMyDianPing];

}
-(void)requestMyDianPing{
    kWeakSelf(self);
    [YX_MANAGER requestGetMyDianPingList:NSIntegerToNSString(self.requestPage) success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableVIew reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMinePingLunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMinePingLunTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSString * string = [dic[@"photo_list_details"] count] > 0 ? dic[@"photo_list_details"][0][@"photo_url"] : @"";
    NSString * str1 = [(NSMutableString *)string replaceAll:@" " target:@"%20"];
    cell.selectionStyle = 0;
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
  
    cell.cnLbl.text =  [kGetString(dic[@"price_box_china"]) append:@"元"];
    cell.skLbl.text =  [kGetString(dic[@"price_box_hongkong"]) append:@"元"];
    cell.hwLbl.text =  [kGetString(dic[@"price_box_overswas"]) append:@"元"];

    cell.titleLbl.text = dic[@"cigar_name"];
    
    cell.timeLbl.text = [[ShareManager timestampSwitchTime:[kGetString(dic[@"comment_time"]) longLongValue] andFormatter:@""] append:@"   点评了"];
    
    cell.plLbl.text = dic[@"comment"];
    return cell;
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
