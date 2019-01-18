//
//  YXGEFPinPaiDetailTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/17.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXGEFPinPaiDetailTableViewController.h"
#import "YXHomeXueJiaDetailTableViewCell.h"
#import "CatZanButton.h"
#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
#import "YXGEPPinPaiDetailHeaderView.h"
#import "YXGEFPinPaiDetailTableViewCell.h"

@interface YXGEFPinPaiDetailTableViewController ()<UITableViewDelegate,UITableViewDataSource,ClickLikeBtnDelegate,ClickGuanZhuBtnDelegate>{
    UIImage * _selImage;
    UIImage * _unImage;
}
@property(nonatomic)YXGEPPinPaiDetailHeaderView * headerView;
@property (nonatomic,copy) NSMutableDictionary * parDic;
@end
@implementation YXGEFPinPaiDetailTableViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    _parDic = [[NSMutableDictionary alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXGEFPinPaiDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXGEFPinPaiDetailTableViewCell"];
    [self requestGolfList:_parDic];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)requestGolfList:(NSMutableDictionary *)dic{
    
    [_parDic setValue:@([self.dicStartData[@"id"] intValue]) forKey:@"brand_id"];
    [_parDic setValue:@(1) forKey:@"page"];
    [_parDic setValue:@(1) forKey:@"_class"];
    [_parDic setValue:@"开球木杆" forKey:@"type_"];
    [YX_MANAGER requestGolf_productPOST:_parDic success:^(id object) {
        
    }];
}

-(void)initData{
    _selImage = [UIImage imageNamed:@"Zan"];
    _unImage = [UIImage imageNamed:@"UnZan"];
    NSDictionary * cellData = self.dicStartData;
    self.title = cellData[@"ch_name"];
    [self.headerView.section1ImageView sd_setImageWithURL:[NSURL URLWithString:cellData[@"logo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.headerView.section1ImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.headerView.section1TextView.text = kGetString(cellData[@"intro"]);
    self.headerView.section1TitleLbl.text = [NSString stringWithFormat:@"%@/%@",cellData[@"brand_name"],cellData[@"ch_name"]];
    ViewBorderRadius(self.headerView.section1GuanZhuBtn, 5, 1, self.headerView.section1GuanZhuBtn.titleLabel.textColor);
    self.headerView.section1countLbl.text = [kGetString(cellData[@"like_number"]) append:@" 人关注"];
    BOOL isGuanZhu = self.dicData[@"is_like"];
    self.headerView.delegate = self;
    [ShareManager setGuanZhuStatus:self.headerView.section1GuanZhuBtn status:isGuanZhu];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXGEPPinPaiDetailHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    [self initData];
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 480;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXGEFPinPaiDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXGEFPinPaiDetailTableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark ========== 收藏按钮 ==========
-(void)clickLikeBtn:(BOOL)isZan cigar_id:(NSString *)cigar_id likeBtn:(nonnull UIButton *)likeBtn{
    kWeakSelf(self);
    if ([userManager loadUserInfo]) {
        
        [YX_MANAGER requestGolf_product_collect:@{@"id":@""} success:^(id object) {
            [likeBtn setBackgroundImage:isZan ? _selImage:_unImage forState:UIControlStateNormal];
        }];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}
#pragma mark ========== 关注按钮 ==========
-(void)clickGuanZhuAction:(UIButton *)btn{
    kWeakSelf(self);
    if ([userManager loadUserInfo]) {
        [YX_MANAGER requestGolf_brand_like:kGetString(self.dicStartData[@"id"]) success:^(id object) {
            BOOL isGuanZhu = weakself.dicData[@"is_like"];
            [ShareManager setGuanZhuStatus:weakself.headerView.section1GuanZhuBtn status:!isGuanZhu];
        }];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
  
}
@end
