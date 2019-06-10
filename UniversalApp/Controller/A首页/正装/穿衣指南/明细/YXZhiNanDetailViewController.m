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
#import "YXZhiNan5Cell.h"
#import "QiniuLoad.h"
#import "XHWebImageAutoSize.h"
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
    [self.navigationController.navigationBar setHidden:NO];
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
        return 90;
    }else if(obj == 2) {
        return  [YXZhiNan2Cell jisuanCellHeight:dic] + 30;
    }else if(obj == 3 || obj == 4) {
        return (KScreenWidth-30)*[dic[@"ratio"] doubleValue] + 30;
    }else if(obj == 5){
        return 80;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger obj = [dic[@"obj"] integerValue];
    if (obj == 1 ) {
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
    }else if (obj == 5) {
        YXZhiNan5Cell * cell5 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan5Cell" forIndexPath:indexPath];
        [cell5 setCellData:dic];
        return cell5;
    }
    return nil;
}
//初始化UI
-(void)setVCUI{
    [self addNavigationItemWithImageNames:@[@"更多"] isLeft:NO target:self action:@selector(moreShare) tags:@[@"999"]];
    self.view.backgroundColor = KWhiteColor;
    self.title = self.vcTitle;
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan1Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan1Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan2Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan2Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan3Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan3Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan4Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan4Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan5Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan5Cell"];
}
-(void)moreShare{
    [[ShareManager sharedShareManager] saveImage:self.yxTableView];
}

@end
