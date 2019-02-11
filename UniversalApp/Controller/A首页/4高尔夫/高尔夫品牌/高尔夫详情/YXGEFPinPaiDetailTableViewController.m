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
#import "YXGEFPinPaiLastDetailViewController.h"

#define TYPE_QIU_JU @"开球木杆"
#define TYPE_QIU_DAO_MU_GAN @"球道木杆"
#define TYPE_TIE_GAN @"铁杆"
#define TYPE_WA_QI_GAN @"挖起杆"
#define TYPE_TUI_GAN @"推杆"
#define TYPE_GAO_ER_FU @"高尔夫"


@interface YXGEFPinPaiDetailTableViewController ()<UITableViewDelegate,UITableViewDataSource,ClickGolfLikeBtnDelegate,ClickGuanZhuBtnDelegate>{
    UIImage * _selImage;
    UIImage * _unImage;
}
@property(nonatomic)YXGEPPinPaiDetailHeaderView * headerView;
@property (nonatomic,copy) NSMutableDictionary * parDic;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSArray * segmentArray;

@end
@implementation YXGEFPinPaiDetailTableViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    _parDic = [[NSMutableDictionary alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _segmentArray = @[TYPE_QIU_JU,TYPE_QIU_DAO_MU_GAN,TYPE_TIE_GAN,TYPE_WA_QI_GAN,TYPE_TUI_GAN,TYPE_GAO_ER_FU];
    _selImage = [UIImage imageNamed:@"Zan"];
    _unImage = [UIImage imageNamed:@"UnZan"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXGEFPinPaiDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXGEFPinPaiDetailTableViewCell"];
    [self requestGolfList:TYPE_QIU_JU page:1];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)requestGolfList:(NSString *)type page:(NSInteger)page{
    kWeakSelf(self);
    
    
    [_parDic removeAllObjects];
    [_parDic setValue:@([self.dicStartData[@"id"] intValue]) forKey:@"brand_id"];
    [_parDic setValue:@(1) forKey:@"page"];
    [_parDic setValue:@(1) forKey:@"_class"];
    [_parDic setValue:type forKey:@"type_"];
    [YX_MANAGER requestGolf_productPOST:_parDic success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}

-(void)initData{

    NSDictionary * cellData = self.dicStartData;
    self.title = cellData[@"ch_name"];
    NSString * str = [(NSMutableString *)cellData[@"logo"] replaceAll:@" " target:@"%20"];
    [self.headerView.section1ImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.headerView.section1ImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.headerView.section1TextView.text = kGetString(cellData[@"intro"]);
    self.headerView.section1TitleLbl.text = [NSString stringWithFormat:@"%@/%@",cellData[@"brand_name"],cellData[@"ch_name"]];
    ViewBorderRadius(self.headerView.section1GuanZhuBtn, 5, 1, self.headerView.section1GuanZhuBtn.titleLabel.textColor);
    self.headerView.section1countLbl.text = [kGetString(cellData[@"like_number"]) append:@" 人关注"];
    BOOL isGuanZhu = self.dicData[@"is_like"];
    self.headerView.delegate = self;
    self.headerView.segmentDelegate = self;
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
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXGEFPinPaiDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXGEFPinPaiDetailTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.delegate = self;
    cell.gefTitleLbl.text = dic[@"product_name"];
    cell.gnPriceLbl.text = kGet2fDouble([dic[@"price_CN"] doubleValue]);
    cell.mgPriceLbl.text = kGet2fDouble([dic[@"price_USA"] doubleValue]);
    cell.golf_id = kGetString(dic[@"id"]);
    if ([dic[@"photo_list"] count] > 0) {
        NSString * str = [(NSMutableString *)dic[@"photo_list"][0][@"photo_url"] replaceAll:@" " target:@"%20"];
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    
    [cell.likeBtn setBackgroundImage:[dic[@"is_collect"] integerValue] == 1 ? _selImage:_unImage forState:UIControlStateNormal];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXGEFPinPaiLastDetailViewController * VC = [[YXGEFPinPaiLastDetailViewController alloc]init];
    VC.dicStartData = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 收藏按钮 ==========
-(void)clickLikeBtn:(BOOL)isZan golf_id:(NSString *)golf_id likeBtn:(UIButton *)likeBtn{
    kWeakSelf(self);
    if ([userManager loadUserInfo]) {
        [YX_MANAGER requestGolf_product_collect:golf_id success:^(id object) {
                [weakself requestGolfList:TYPE_QIU_JU page:1];
//            [likeBtn setBackgroundImage:isZan ? _selImage:_unImage forState:UIControlStateNormal];
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
#pragma mark ========== segment点击事件 ==========
-(void)clickSegmentAction:(NSInteger)segmentIndex{
    [self requestGolfList:_segmentArray[segmentIndex] page:1];
}
@end
