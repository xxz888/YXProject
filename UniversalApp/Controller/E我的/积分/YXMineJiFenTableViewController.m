//
//  YXMineJiFenTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/8/30.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineJiFenTableViewController.h"
#import "YXMineJiFenHistoryViewController.h"
#import "YXMineQianDaoView.h"
#import "YXMineChouJiangViewController.h"
#import "YXHomeEditPersonTableViewController.h"
#import "YXMineYaoQingWebViewController.h"
#import "YXJiFenShopViewController.h"
@interface YXMineJiFenTableViewController ()
@property(nonatomic,strong)NSMutableArray * sign_Array;
@end

@implementation YXMineJiFenTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVCUI];
    
    [self requestData];
}
-(void)requestData{
    
    kWeakSelf(self);
    [YX_MANAGER requestGetFind_My_user_Info:@"" success:^(id object) {
        weakself.jifenNumLbl.text= [@"积分:" append:kGetNSInteger([object[@"wallet"][@"integral"] integerValue])];
           [weakself.accImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:object[@"photo"]]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
        weakself.accImv.layer.masksToBounds = YES;
        weakself.accImv.layer.cornerRadius = self.accImv.frame.size.width / 2.0;
    }];
    
    
    
    [YX_MANAGER requestUsersSign_in_List:@{} success:^(id object) {
        [weakself.sign_Array removeAllObjects];
        [weakself.sign_Array addObjectsFromArray:object[@"data"]];
        weakself.lianxuqiandaoLbl.text = kGetString(object[@"day_number"]);
        //判断今天是否已经签到
        NSString * currDayTime = [ShareManager getCurrentDay];
        for (NSDictionary * dic in weakself.sign_Array) {
            if([dic[@"sign_in_date"] isEqualToString:currDayTime]){
                [weakself.qiandaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
                [weakself.qiandaoBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                [weakself.qiandaoBtn setBackgroundColor:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0]];
                weakself.qiandaoBtn.userInteractionEnabled = NO;
                
               [weakself.finish3 setTitle:@"已完成" forState:UIControlStateNormal];
                      [weakself.finish3 setTitleColor:kRGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
                      [weakself.finish3 setBackgroundColor:kRGBA(245, 245, 245, 1.0)];
                ViewBorderRadius(weakself.finish3, 4, 0, KClearColor);
                weakself.finish3.userInteractionEnabled = NO;
            }
        }
        [weakself get7Days];
    }];
    
    [self get7Days];

}
-(void)get7Days{
    
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 3; i < 8; i++) {
        NSDate *currentDate = [NSDate date];
        NSDate *appointDate;    // 指定日期声明
        NSTimeInterval oneDay = 24 * 60 * 60;  // 一天一共有多少秒
        appointDate = [currentDate initWithTimeIntervalSinceNow: -(oneDay * i)];
        appointDate = [currentDate initWithTimeIntervalSinceNow: (oneDay * i)];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:appointDate];
        
        [dayArray addObject:strDate];
    }
    self.day3.text = dayArray[0];
    self.day4.text = dayArray[1];
    self.day5.text = dayArray[2];
    self.day6.text = dayArray[3];
    self.day7.text = dayArray[4];

    
}
-(void)setVCUI{
    self.accImv.layer.masksToBounds = YES;
    self.accImv.layer.cornerRadius = self.accImv.frame.size.width / 2.0;
    ViewRadius(self.qiandaoBtn, 12);
    [self.qiandaoBtn setBackgroundColor:kRGBA(10, 36, 54, 1)];
    ViewRadius(self.qiandaoView, 5);
    
    ViewBorderRadius(self.finish1, 2, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish2, 2, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish3, 2, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish4, 2, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish5, 2, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish6, 2, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish7, 2, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish8, 2, 1, kRGBA(10, 36, 54, 1));
    ViewBorderRadius(self.finish9, 2, 1, kRGBA(10, 36, 54, 1));
    
    self.sign_Array = [[NSMutableArray alloc]init];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)qiandaoAction:(id)sender {
    
    kWeakSelf(self);
    [YX_MANAGER requestUsersSign_in_Action:@"" success:^(id object) {
        [weakself.qiandaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
        [weakself.qiandaoBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [weakself.qiandaoBtn setBackgroundColor:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0]];
        weakself.qiandaoBtn.userInteractionEnabled = NO;
        
        [weakself.finish3 setTitle:@"已完成" forState:UIControlStateNormal];
        [weakself.finish3 setTitleColor:kRGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
        [weakself.finish3 setBackgroundColor:kRGBA(245, 245, 245, 1.0)];
        weakself.finish3.userInteractionEnabled = NO;
        ViewBorderRadius(weakself.finish3, 4, 0, KClearColor);

        [weakself handleShowContentView];
        
        
    }];
    

 

}
- (IBAction)jifenHistoryAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXMineJiFenHistoryViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineJiFenHistoryViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}






- (void)handleShowContentView {
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXMineQianDaoView" owner:self options:nil];
    YXMineQianDaoView * contentView = [nib objectAtIndex:0];
    contentView.frame = CGRectMake(20, 110, KScreenWidth-40, 403);
    contentView.backgroundColor = KClearColor;
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
//    modalViewController.contentViewMargins = UIEdgeInsetsMake(0, modalViewController.view.frame.size.width/2, 0, 0);
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (IBAction)jifenshangchengAction:(id)sender {
    kWeakSelf(self);
    YXJiFenShopViewController * vc = [[YXJiFenShopViewController alloc]init];
        [YXPLUS_MANAGER requestIntegral_Commodity_recommendGet:@"" success:^(id object) {
            vc.lunboArray = [[NSMutableArray alloc]initWithArray:object[@"data"]];
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
}

- (IBAction)finishAllAction:(UIButton *)btn{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    switch (btn.tag) {
        case 101://首次完善个人主页
        {
            
            NSDictionary * userInfo = userManager.loadUserAllInfo;
            kWeakSelf(self);
            [YX_MANAGER requestGetFind_user_id:kGetString(userInfo[@"id"]) success:^(id object) {
                YXHomeEditPersonTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXHomeEditPersonTableViewController"];
                VC.userInfoDic = [NSDictionary dictionaryWithDictionary:object];
                [weakself.navigationController pushViewController:VC animated:YES];            }];
        
        }
            break;
        case 102://邀请好友注册
        {
            YXMineYaoQingWebViewController * vc = [[YXMineYaoQingWebViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 103://每日签到
            
            break;
        case 104://每日新增粉丝
        case 105://每日新增关注
        case 106://每条内容被喜欢10次
        case 107://图片加精
        case 108://视频加精
        case 109://文章加精
            self.navigationController.tabBarController.selectedIndex = 1;
            break;
        default:
            break;
    }
    
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint offset = tableV.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    tableV.contentOffset = offset;
//}
@end
