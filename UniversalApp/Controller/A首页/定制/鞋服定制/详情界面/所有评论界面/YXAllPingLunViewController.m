//
//  YXAllPingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXAllPingLunViewController.h"
#import "YXDingZhiDetailTableViewCell.h"
#import "YXChildPingLunViewController.h"

@interface YXAllPingLunViewController (){
    NSInteger _btnType;
}
@property(nonatomic,strong)NSMutableArray * btnArray;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation YXAllPingLunViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
    [self getShopPingLunList];
}

//初始化控件
-(void)initControl{
    
    ViewBorderRadius(self.btn1, 14, 1, KClearColor);
    [self selectBtnStatus:self.btn1];
    ViewBorderRadius(self.btn2, 14, 1, KClearColor);
    [self unSelectBtnStatus:self.btn2];
    ViewBorderRadius(self.btn3, 14, 1, KClearColor);
    [self unSelectBtnStatus:self.btn3];
    ViewBorderRadius(self.btn4, 14, 1, KClearColor);
    [self unSelectBtnStatus:self.btn4];
    self.btnArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    _btnType = 1;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXDingZhiDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXDingZhiDetailTableViewCell"];
    [self addRefreshView:self.yxTableView];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self getShopPingLunList];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self getShopPingLunList];
}
-(void)getShopPingLunList{
    NSString * par = [NSString stringWithFormat:@"page=%ld&business_id=%@&type=%@",
                      (long)self.requestPage,self.startDic[@"id"],NSIntegerToNSString(_btnType)];
    kWeakSelf(self);
    [YXPLUS_MANAGER getShopBusiness_commentSuccess:par success:^(id object) {
      [weakself.yxTableView.mj_header endRefreshing];
      [weakself.yxTableView.mj_footer endRefreshing];
       weakself.dataArray = [weakself commonAction:object[@"data"] dataArray:weakself.dataArray];
       [weakself.yxTableView reloadData];
        NSInteger count = weakself.dataArray.count;
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YXDingZhiDetailTableViewCell cellDefaultHeight:self.dataArray[indexPath.row]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
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
         UIImage * likeImage = isp ? [UIImage imageNamed:@"F蓝色已点赞"] : [UIImage imageNamed:@"F灰色未点赞"];
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

-(void)selectBtnStatus:(UIButton *)btn{
    ViewBorderRadius(btn, 14, 1, KClearColor);
    [btn setTitleColor:KWhiteColor forState:0];
    [btn setBackgroundColor:SEGMENT_COLOR];
}
-(void)unSelectBtnStatus:(UIButton *)btn{
     ViewBorderRadius(btn, 14, 1, KClearColor);
      [btn setTitleColor:COLOR_444444 forState:0];
      [btn setBackgroundColor:COLOR_F5F5F5];
}

- (IBAction)btnAction:(UIButton *)btn {
    //1010,1020,大于1000代表未选择，小于1000代表选择
        switch (btn.tag) {
            case 1010:{
                _btnType = 1;
                self.btn1.tag = 10;
                [self selectBtnStatus:btn];
                
                self.btn2.tag = 1020;
                [self unSelectBtnStatus:self.btn2];
                self.btn3.tag = 1030;
                [self unSelectBtnStatus:self.btn3];
                self.btn4.tag = 1040;
                [self unSelectBtnStatus:self.btn4];
            }
                break;
            case 1020:{
                _btnType = 2;
                self.btn2.tag = 20;
                [self selectBtnStatus:btn];
                
                self.btn1.tag = 1010;
                [self unSelectBtnStatus:self.btn1];
                self.btn3.tag = 1030;
                [self unSelectBtnStatus:self.btn3];
                self.btn4.tag = 1040;
                [self unSelectBtnStatus:self.btn4];
            }
                    
                break;
            case 1030:{
                _btnType = 3;
                self.btn3.tag = 30;
                [self selectBtnStatus:btn];
                
                self.btn2.tag = 1020;
                [self unSelectBtnStatus:self.btn2];
                self.btn1.tag = 1010;
                [self unSelectBtnStatus:self.btn1];
                self.btn4.tag = 1040;
                [self unSelectBtnStatus:self.btn4];
            }
                    
                break;
            case 1040:{
                _btnType = 4;
                self.btn4.tag = 40;
                [self selectBtnStatus:btn];
                
                self.btn2.tag = 1020;
                [self unSelectBtnStatus:self.btn2];
                self.btn3.tag = 1030;
                [self unSelectBtnStatus:self.btn3];
                self.btn1.tag = 1010;
                [self unSelectBtnStatus:self.btn1];
            }
                        
                break;
            default:
                break;
    }
    [self getShopPingLunList];
}
@end
