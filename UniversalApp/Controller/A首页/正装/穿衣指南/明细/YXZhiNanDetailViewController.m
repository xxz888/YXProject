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
    [self requestZhiNanGet];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)requestStartZhiNanGet{
    if ([self.startArray[0][@"father_id"] integerValue] == 0) {
        return;
    }
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"1/%@",self.startArray[0][@"father_id"]];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
        weakself.startArray = [weakself commonAction:object dataArray:weakself.startArray];
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"weight" ascending:YES]];
          [weakself.startArray sortUsingDescriptors:sortDescriptors];
        [weakself panduanIsColl];
        [YXPLUS_MANAGER requestAll_optionGet:@"" success:^(id object) {
            [weakself.allOptionArray removeAllObjects];
            [weakself.allOptionArray addObjectsFromArray:object];
        }];
    }];
}
-(void)panduanIsColl{
    self.title = [NSString stringWithFormat:@"0%ld/%@",self.bigIndex+1,kGetString(self.startArray[self.bigIndex][@"name"])];
    self.plLbl.text = kGetString(self.startArray[self.bigIndex][@"comment_number"]);
    self.collLbl.text = kGetString(self.startArray[self.bigIndex][@"collect_number"]);

    if ([userManager loadUserInfo]) {
        self.is_collect = [self.startArray[self.bigIndex][@"is_collect"] integerValue] == 1;
        UIImage * likeImage = self.is_collect ? [UIImage imageNamed:@"收藏选择"] : [UIImage imageNamed:@"收藏未选择"] ;
        [self.collImgView setImage:likeImage];
    }
}
-(void)headerRereshing{
    if ([self.startArray[0][@"father_id"] integerValue] == 0) {
        [self endRefresh];
        return;
    }
    self.smallIndex = 0;
    if (self.bigIndex == 0) {
        [self endRefresh];
    }else{
        self.bigIndex -= 1;
        [self requestZhiNanGet];
    }
}
-(void)footerRereshing{
    if ([self.startArray[0][@"father_id"] integerValue] == 0) {
        [self endRefresh];
        return;
    }
    self.smallIndex = 0;
        if (self.bigIndex == [self.startArray count] - 1) {
            [self endRefresh];
        }else{
            self.bigIndex +=1;
            [self requestZhiNanGet];
        }
}
-(void)endRefresh{
    [self.yxTableView.mj_header endRefreshing];
    [self.yxTableView.mj_footer endRefreshing];
}
-(void)requestZhiNanGet{
    [QMUITips showLoadingInView:self.view];
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"0/%@",self.startArray[self.bigIndex][@"id"]];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
            [weakself.dataArray removeAllObjects];
            [weakself.dataArray addObjectsFromArray:object];
        
        
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
        
   
        
        
            [weakself endRefresh];
            [weakself panduanIsColl];
            [QMUITips hideAllTipsInView:weakself.view];
        
        
            [weakself.yxTableView reloadData];
        
        
        
        // reloadDate会在主队列执行，而dispatch_get_main_queue会等待机会，直到主队列空闲才执行。
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.dataArray.count > weakself.smallIndex) {
                    if ([weakself.dataArray[weakself.smallIndex] count] != 0 && weakself.dataArray.count > weakself.smallIndex) {
                            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:weakself.smallIndex];
                            [weakself.yxTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        }
            }
        
         
        });
        
        
            [weakself requestStartZhiNanGet];
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
            vc.smallIndex = 0;
            NSInteger index1 = [[indexString split:@"-"][0] integerValue];
            NSInteger index2 = [[indexString split:@"-"][1] integerValue];
            NSInteger index3 = [[indexString split:@"-"][2] integerValue];
            for (NSDictionary * dic1 in weakself.allOptionArray) {
                if ([dic1[@"id"] integerValue] == index1) {
                    for (NSDictionary * dic2 in dic1[@"child_list"]) {
                        if ([dic2[@"id"] integerValue] == index2) {
                            vc.startArray = [[NSMutableArray alloc]initWithArray:dic2[@"child_list"]];
                            for (NSInteger i = 0; i < [dic2[@"child_list"] count]; i++) {
                                if ([dic2[@"child_list"][i][@"id"] integerValue] == index3) {
                                    vc.bigIndex = i;
                                }
                            }
                        }
                    }
                }
            }
            vc.smallIndex = 0;
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
//初始化UI
-(void)setVCUI{
    self.bottomViewHeight.constant = AxcAE_IsiPhoneX ? 90 : 60;
    [self addNavigationItemWithImageNames:@[@"更多"] isLeft:NO target:self action:@selector(moreShare) tags:@[@"999"]];
    self.view.backgroundColor = KWhiteColor;
    self.dataArray = [[NSMutableArray alloc]init];
    self.linkArray = [[NSMutableArray alloc]init];

    self.allOptionArray = [[NSMutableArray alloc]init];

    [self addRefreshView:self.yxTableView];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan1Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan1Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan2Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan2Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan3Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan3Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan4Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan4Cell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNan5Cell" bundle:nil] forCellReuseIdentifier:@"YXZhiNan5Cell"];
     [self.yxTableView registerNib:[UINib nibWithNibName:@"UITableViewCell" bundle:nil] forCellReuseIdentifier:@"UITableViewCell"];
         [self.yxTableView registerNib:[UINib nibWithNibName:@"YXZhiNanType2TableViewCell" bundle:nil] forCellReuseIdentifier:@"YXZhiNanType2TableViewCell"];
    
    
    if (@available(iOS 11.0, *)) {
        
        //ios 11以上
        
        self.yxTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        //ios 11以下
        
        self.automaticallyAdjustsScrollViewInsets=NO;
        
    }
}

-(void)moreShare{
    NSDictionary * dic = self.startArray[self.bigIndex];
    NSString * title = dic[@"name"];
    NSString * desc = dic[@"intro"];
    NSString * cid = dic[@"id"];
    [[ShareManager sharedShareManager] pushShareViewAndDic:@{
        @"type":@"2",@"img":@"",@"desc":desc,@"title":title,@"id":cid,@"thumbImage":dic[@"photo"],@"index":kGetNSInteger(self.startIndex),@"index1":kGetNSInteger([dic[@"id"] integerValue])}];
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
    YXZhiNanPingLunViewController * vc = [[YXZhiNanPingLunViewController alloc]init];
    vc.startDic = [NSDictionary dictionaryWithDictionary:self.startArray[self.bigIndex]];
    vc.startId = self.startArray[self.bigIndex][@"id"];
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
    kWeakSelf(self);
    NSString * tagId = kGetString(self.startArray[self.bigIndex][@"id"]);
    [YXPLUS_MANAGER requestCollect_optionGet:[@"3/" append:tagId] success:^(id object) {
        [weakself requestStartZhiNanGet];
//        UIImage * likeImage = weakself.is_collect ? [UIImage imageNamed:@"收藏未选择"] : [UIImage imageNamed:@"收藏选择"] ;
//        [weakself.collImgView setImage:likeImage];
//        weakself.is_collect = !weakself.is_collect;
    }];
}
@end
