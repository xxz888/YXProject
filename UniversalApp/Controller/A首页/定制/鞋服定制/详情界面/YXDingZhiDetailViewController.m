//
//  YXDingZhiDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiDetailViewController.h"
#import "YXDingZhiDetailView.h"
#import "YXDingZhiFooterView.h"
#import "YXAllPingLunViewController.h"

#import "YXDingZhiDetailTableViewCell.h"
#import "YXDingZhiPingLunViewController.h"
#import "YXChildPingLunViewController.h"
#import "YXDingZhiShangJiaViewController.h"

@interface YXDingZhiDetailViewController ()

@property (nonatomic,strong) YXDingZhiDetailView * headerView;
@property (nonatomic,strong) YXDingZhiFooterView * footerView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation YXDingZhiDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getShopPingLunList];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initControl];
}
-(void)getShopPingLunList{
    NSString * par = [NSString stringWithFormat:@"page=%ld&business_id=%@&type=%@",(long)self.requestPage,self.startDic[@"id"],@"1"];
    kWeakSelf(self);
    [YXPLUS_MANAGER getShopBusiness_commentSuccess:par success:^(id object) {
      [weakself.yxTableView.mj_header endRefreshing];
      [weakself.yxTableView.mj_footer endRefreshing];
      weakself.dataArray = [weakself commonAction:object[@"data"] dataArray:weakself.dataArray];
      [weakself.yxTableView reloadData];
    }];
}
//初始化控件
-(void)initControl{
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhiDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhiDetailTableViewCell"];
    self.dataArray = [[NSMutableArray alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXDingZhiDetailView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.startDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    [self.headerView setCellData];
    self.headerView.pingjiaCount.text = [NSString stringWithFormat:@"评价(%lu)",(unsigned long)self.dataArray.count];
    [self allBlockAction];
    return self.headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXDingZhiFooterView" owner:self options:nil];
    self.footerView = [nib objectAtIndex:0];
    [self allBlockAction];
    return self.footerView;
}
-(void)allBlockAction{
    kWeakSelf(self);
    self.headerView.pingLunBlock = ^{
        YXDingZhiPingLunViewController * vc = [[YXDingZhiPingLunViewController alloc]init];
        vc.startDic = [NSDictionary dictionaryWithDictionary:weakself.startDic];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    self.headerView.clickCountViewBlock = ^{
        YXDingZhiShangJiaViewController * vc = [[YXDingZhiShangJiaViewController alloc]init];
        vc.startArray = [weakself.startDic[@"photo_list"] split:@","];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    self.footerView.allBtnBlock = ^{
        YXAllPingLunViewController * vc = [[YXAllPingLunViewController alloc]init];
        vc.startDic = [NSDictionary dictionaryWithDictionary:weakself.startDic];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 460;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 72;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YXDingZhiDetailTableViewCell cellDefaultHeight:self.dataArray[indexPath.row]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count >=3 ? 3 : self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDingZhiDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXDingZhiDetailTableViewCell" forIndexPath:indexPath];
    cell.zanBtn.tag = indexPath.row;
    cell.startDic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    [cell setCellData:self.dataArray[indexPath.row]];
    kWeakSelf(self);
    cell.zanblock = ^(NSInteger index) {
        NSIndexPath * indexPathSelect = [NSIndexPath indexPathForRow:index  inSection:0];
        YXDingZhiDetailTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
        //赞
        BOOL isp =  [weakself.dataArray[index][@"is_praise"] integerValue] == 1;
        UIImage * likeImage = isp ?  IMAGE_NAMED(@"F灰色未点赞") : IMAGE_NAMED(@"F蓝色已点赞");
        [cell.zanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
        
        NSString * comment_id = kGetString(weakself.dataArray[index][@"id"]);
        [YXPLUS_MANAGER clickShopBusiness_comment_praiseSuccess:@{@"comment_id":comment_id,@"type":@"1"} success:^(id object) {
            [weakself getShopPingLunList];
        }];
    };
    cell.talkblock = ^(NSInteger index){
        YXChildPingLunViewController * vc = [[YXChildPingLunViewController alloc]init];
        vc.startDic = [NSDictionary dictionaryWithDictionary:weakself.dataArray[index]];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)collAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.collImv.image = IMAGE_NAMED(@"G收藏已选择");
    }else{
        self.collImv.image = IMAGE_NAMED(@"G收藏未选择");
    }
}

- (IBAction)shareAction:(id)sender {
    [WP_TOOL_ShareManager saveImage:self.yxTableView];
}

- (IBAction)telAction:(id)sender {
    [self makePhoneCall3:@"1338287213"];
}


/**
  * 拨打电话，弹出提示，拨打完电话回到原来的应用
  * 注意这里是 telprompt://
  * @param phoneNumber 电话号码字符串
 */
- (void)makePhoneCall3:(NSString *)phoneNumber {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]]];
}



@end
