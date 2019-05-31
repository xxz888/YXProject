//
//  YXZhiNanDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanDetailViewController.h"
#import "YXZhiNanDetailHeaderView.h"
#import "YXZhiNan1Cell.h"
#import "YXZhiNan2Cell.h"
#import "YXZhiNan3Cell.h"
#import "YXZhiNan4Cell.h"

@interface YXZhiNanDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
    @property (nonatomic,strong) YXZhiNanDetailHeaderView * headerView;
    @property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) CGFloat contentHeight;
@end

@implementation YXZhiNanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化UI
    [self setVCUI];
    [self requestZhiNanGet];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];

}
-(void)requestZhiNanGet{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"0/%@",self.startDic[@"id"]];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger obj = [dic[@"obj"] integerValue];
    if (obj == 1) {
        return 45;
    }else if(obj == 2) {
        return  [YXZhiNan2Cell jisuanCellHeight:dic];
    }else if(obj == 3 || obj == 4) {
        return 245;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger obj = [dic[@"obj"] integerValue];
    if (obj == 1) {
        YXZhiNan1Cell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan1Cell" forIndexPath:indexPath];
        [cell1 setCellData:dic];
        return cell1;
    }else if(obj == 2) {
        YXZhiNan2Cell * cell2 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan2Cell" forIndexPath:indexPath];
        [cell2 setCellData:dic];
        return cell2;
    }else if(obj == 3) {
        YXZhiNan3Cell * cell3 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan3Cell" forIndexPath:indexPath];
        [cell3 setCellData:dic];
        return cell3;
    }else if(obj == 4) {
        YXZhiNan4Cell * cell4 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan4Cell" forIndexPath:indexPath];
        [cell4 setCellData:dic];
        return cell4;
    }else if(obj == 5) {
        YXZhiNan1Cell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan1Cell" forIndexPath:indexPath];
        [cell1 setCellData:dic];
        return cell1;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!_headerView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXZhiNanDetailHeaderView" owner:self options:nil];
        _headerView = [nib objectAtIndex:0];
    }
    
    [_headerView setHeaderViewData:self.startDic];

    kWeakSelf(self);
    _headerView.backVCBlock = ^{

    };
    _headerView.openBlock = ^(void) {
  
    };
    return _headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KScreenWidth * 9/16 + self.contentHeight + 15;
}
//初始化UI
-(void)setVCUI{
    _contentHeight = [ShareManager inTextZhiNanOutHeight:self.startDic[@"intro"] lineSpace:9 fontSize:15];
    self.view.backgroundColor = KWhiteColor;
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan1Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan1Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan2Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan2Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan3Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan3Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan4Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan4Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan5Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan5Cell"];
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
