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
#import "YXZhiNanPingLunViewController.h"
#import "YXZhiNanType2TableViewCell.h"
#import "YXMineImageDetailViewController.h"
#import "YXFirstFindImageTableViewCell.h"
@interface YXZhiNanDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) YXZhiNanDetailHeaderView * headerView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * linkArray;
@property (nonatomic,strong) NSMutableArray * allOptionArray;
@property (nonatomic,strong) NSMutableArray * collArray;

@property (nonatomic,assign) BOOL is_collect;
@property (weak, nonatomic) IBOutlet UILabel *plLbl;
@property (weak, nonatomic) IBOutlet UILabel *collLbl;
    
@property (nonatomic,assign) CGFloat contentHeight;
@end

@implementation YXZhiNanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化UI
    [self setVCUI];
    //在这里要做请求,请求最后最后一个界面的数据
    [self requestZhiNanGet];
    //这里请求的是是否收藏之类的
    [self requestZhiNanGetCollData];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
//初始化UI
-(void)setVCUI{
//    self.bottomViewHeight.constant = self.whereCome ? 0 : IS_IPhoneX ? 90 : 60;
//    self.bottomView.hidden = self.whereCome;
    [self addNavigationItemWithImageNames:@[@"B黑色横向更多"] isLeft:NO target:self action:@selector(moreShare) tags:@[@"999"]];
    self.view.backgroundColor = KWhiteColor;
    self.dataArray = [[NSMutableArray alloc]init];
    self.linkArray = [[NSMutableArray alloc]init];
    self.collArray = [[NSMutableArray alloc]init];
    [self addRefreshView:self.yxTableView];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan1Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan1Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan2Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan2Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan3Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan3Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan4Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan4Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan5Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan5Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"UITableViewCell" bundle:nil] forCellReuseIdentifier:@"UITableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNanType2TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXZhiNanType2TableViewCell"];
    if (@available(iOS 11.0, *)) {self.yxTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {self.automaticallyAdjustsScrollViewInsets=NO;}
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinglunAction)];
      // 添加手势
    [self.pinglunView addGestureRecognizer:aTapGR];
    self.title = [NSString stringWithFormat:@"0%ld/%@",self.selectCellIndex+1,self.selectCellArray[self.selectCellIndex][@"name"]];
}
-(void)requestZhiNanGetCollData{
    //这个是固定的，不随滑动改变,这个请求制作判断是否收藏，不做其他用途
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"1/%@",self.firstSelectId];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
        [weakself.collArray removeAllObjects];
        [weakself.collArray addObjectsFromArray:object];
        [weakself panduanIsColl];
    }];
}
//判断是否收藏过
-(void)panduanIsColl{
    self.title = [NSString stringWithFormat:@"0%ld/%@",self.selectCellIndex+1,self.selectCellArray[self.selectCellIndex][@"name"]];
    NSDictionary * selectItemDic = self.collArray[self.selectCellIndex];
    self.plLbl.text = kGetString(selectItemDic[@"comment_number"]);
    self.plLbl.hidden =   [self.plLbl.text isEqualToString:@"0"];
    self.collLbl.text = kGetString(selectItemDic[@"collect_number"]);
    self.collLbl.hidden = [self.collLbl.text isEqualToString:@"0"];
    if ([userManager loadUserInfo]) {
        self.is_collect = [selectItemDic[@"is_collect"] integerValue] == 1;
        UIImage * likeImage = self.is_collect ? [UIImage imageNamed:@"G收藏已选择"] : [UIImage imageNamed:@"G收藏未选择"] ;
        [self.collImgView setImage:likeImage];
    }
}

-(void)headerRereshing{
  
    [self common1Action];
    if (self.selectCellIndex == 0) {
        [self endRefresh];
    }else{
        self.selectCellIndex -= 1;
        [self requestZhiNanGet];
        [self requestZhiNanGetCollData];
    }
}
-(void)footerRereshing{

    [self common1Action];
    if (self.selectCellIndex == [self.selectCellArray count] - 1) {
        [self endRefresh];
    }else{
        self.selectCellIndex +=1;
        [self requestZhiNanGet];
        [self requestZhiNanGetCollData];
    }
}
-(void)common1Action{
    if (self.whereCome) {[self endRefresh];return;}
    [self panduanIsColl];
    self.selectItemIndex = 0;
}
-(void)endRefresh{
    [self.yxTableView.mj_header endRefreshing];
    [self.yxTableView.mj_footer endRefreshing];
}
//请求最后一个界面的信息
-(void)requestZhiNanGet{
    [QMUITips showLoadingInView:self.view];
    
    NSString * selectFatherId = self.selectCellArray[self.selectCellIndex][@"id"];
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"0/%@",selectFatherId];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        //获取要点击的link文字
        for (NSInteger i = 0 ; i< weakself.dataArray.count; i++) {
            NSArray * smallArray = weakself.dataArray[i];
            for (NSInteger k = 0; k < smallArray.count; k++) {
                NSDictionary * dic = smallArray[k];
                NSInteger obj = [dic[@"obj"] integerValue];
                if (obj == 6) {
                    [weakself.linkArray removeAllObjects];
                    [weakself.linkArray addObjectsFromArray:[dic[@"detail"] split:@";"]];
                }
            }
        }
        [weakself.yxTableView reloadData];
        //用作记录上个界面点击的哪个item，在请求完信息滑动到相对应的item
        //reloadDate会在主队列执行，而dispatch_get_main_queue会等待机会，直到主队列空闲才执行。
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里处理防崩溃，这种几率很小的，但也要做个判断
            if (weakself.selectItemIndex -1 > weakself.dataArray.count) {
                weakself.selectItemIndex = 0;
            }
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:weakself.selectItemIndex];
            [weakself.yxTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
        [weakself endRefresh];
        [QMUITips hideAllTipsInView:weakself.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.section][indexPath.row];
    NSInteger obj = [dic[@"obj"] integerValue];
    if (obj == 1) {
        if ([dic[@"ratio"] integerValue] == 99999) {
                  return 180;
            }else{
                  return [YXZhiNan1Cell jisuanCellHeight:dic] + 20;
        }
    }else if(obj == 2) {
        return  [YXZhiNan2Cell jisuanCellHeight:dic] + 20;
    }else if(obj == 3 || obj == 4) {
        return [dic[@"ratio"] doubleValue] == 0  ?  200 :  (KScreenWidth-30)*[dic[@"ratio"] doubleValue] + 20;
    }else if(obj == 5){
        return  [YXZhiNan5Cell jisuanCellHeight5:dic] + 20;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.section][indexPath.row];
    NSInteger obj = [dic[@"obj"] integerValue];
    if (obj == 1 ) {
        if ([dic[@"ratio"] integerValue] == 99999) {
            NSDictionary * resultDic = [ShareManager stringToDic:dic[@"detail"]];
            YXZhiNanType2TableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNanType2TableViewCell" forIndexPath:indexPath];
            NSString * str = [(NSMutableString *)resultDic[@"cover"] replaceAll:@" " target:@"%20"];
            [cell1.type2Imv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
            cell1.type2Detail.text = resultDic[@"title"];
            cell1.type2Title.text = resultDic[@"sectionTitle"];
            return cell1;
        }else{
            YXZhiNan1Cell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan1Cell" forIndexPath:indexPath];
            [cell1 setCellData:dic];
            return cell1;
        }
      
    }else if(obj == 2) {
        YXZhiNan2Cell * cell2 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan2Cell" forIndexPath:indexPath];
        [cell2 setCellData:dic linkData:self.linkArray];
        
        
        kWeakSelf(self);
        cell2.linkBlock = ^(NSString * indexString) {
            YXZhiNanDetailViewController * vc = [[YXZhiNanDetailViewController alloc]init];
            vc.selectItemIndex = 0;
//            NSInteger index1 = [[indexString split:@"-"][0] integerValue];
            NSInteger index1 = [[indexString split:@"-"][1] integerValue];
            NSInteger index2 = [[indexString split:@"-"][2] integerValue];
            vc.firstSelectId = NSIntegerToNSString(index1);
            
            for (NSDictionary * dic1 in YXPLUS_MANAGER.allOptionArray) {
                if ([dic1[@"id"] integerValue] == index1) {
                      vc.selectCellArray = [[NSMutableArray alloc]initWithArray:dic1[@"child_list"]];
                      for (NSInteger i = 0; i < [dic1[@"child_list"] count]; i++) {
                          if ([dic1[@"child_list"][i][@"id"] integerValue] == index2) {
                              vc.selectCellIndex = i;
                          }
                      }
                }
            }
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        
        
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
    }else if (obj == 6){
        YXZhiNan1Cell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"YXZhiNan1Cell" forIndexPath:indexPath];
        cell1.hidden = YES;
        return cell1;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.section][indexPath.row];
     NSInteger obj = [dic[@"obj"] integerValue];
    NSDictionary * resultDic = [ShareManager stringToDic:dic[@"detail"]];

     if (obj == 1 ) {
         if ([dic[@"ratio"] integerValue] == 99999) {
             YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
             CGFloat h = [YXFirstFindImageTableViewCell cellDefaultHeight:resultDic];
             VC.headerViewHeight = h;
             VC.startDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
             [self.navigationController pushViewController:VC animated:YES];
         }
     }
}


-(void)moreShare{
    NSDictionary * dic = self.selectCellArray[self.selectCellIndex];
    NSString * title = dic[@"name"];
    NSString * desc = dic[@"intro"];
    NSString * cid = dic[@"id"];
    [[ShareManager sharedShareManager] pushShareViewAndDic:@{
        @"type":@"2",@"img":@"",@"desc":desc,@"title":title,@"id":cid,@"thumbImage":dic[@"photo"],@"index":kGetNSInteger(self.selectCellIndex),@"index1":kGetNSInteger([dic[@"id"] integerValue])}];
}
- (IBAction)bottomAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1://收藏
            [self collectAction];
            break;
        case 2://评论
            [self pinglunAction];
            break;
        case 3://分享
            [self moreShare];
            break;
        default:
            break;
    }
}
-(void)pinglunAction{
    if (![userManager loadUserInfo]) {
          KPostNotification(KNotificationLoginStateChange, @NO);
          return;
      }
    NSDictionary * dic = self.selectCellArray[self.selectCellIndex];
    YXZhiNanPingLunViewController * vc = [[YXZhiNanPingLunViewController alloc]init];
    vc.startDic = [NSDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:vc animated:YES];
    
    kWeakSelf(self);
    vc.pinglunBlock = ^(NSString * pinglunString) {
        weakself.plLbl.text = pinglunString;
    };
}

-(void)collectAction{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    NSDictionary * dic = self.selectCellArray[self.selectCellIndex];
    kWeakSelf(self);
    NSString * tagId = kGetString(dic[@"id"]);
    [YXPLUS_MANAGER requestUserShouCangPOST:@{@"obj":@"1",@"target_id":tagId,@"photo":@"",@"tag":@""} success:^(id object) {
        [weakself requestZhiNanGetCollData];
    }];
}
@end
