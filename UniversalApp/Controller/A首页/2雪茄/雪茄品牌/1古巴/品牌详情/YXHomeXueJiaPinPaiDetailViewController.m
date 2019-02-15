//
//  YXHomeXueJiaPinPaiDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/7.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiDetailViewController.h"
#import "YXHomeXueJiaDetailTableViewCell.h"
#import "CatZanButton.h"
#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
#import "YXPublishFootViewController.h"
@interface YXHomeXueJiaPinPaiDetailViewController()<ClickLikeBtnDelegate>{
    UIImage * _selImage;
    UIImage * _unImage;
}

@end
@implementation YXHomeXueJiaPinPaiDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    [self initData];
}
-(void)initData{
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaDetailTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法

    
    
    _selImage = [UIImage imageNamed:@"Zan"];
    _unImage = [UIImage imageNamed:@"UnZan"];

    NSDictionary * cellData = self.dicStartData;
    self.title = cellData[@"cigar_brand"];
    
    
    NSString * str = [(NSMutableString *)cellData[@"photo"] replaceAll:@" " target:@"%20"];
    [self.section1ImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.section1ImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.section1TextView.text = kGetString(cellData[@"intro"]);
    self.section1TitleLbl.text = [NSString stringWithFormat:@"%@/%@",cellData[@"sort"],cellData[@"cigar_brand"]];

    ViewBorderRadius(self.section1GuanZhuBtn, 5, 1, self.section1GuanZhuBtn.titleLabel.textColor);
    
    
    
    
    
    //用的不是一个字典的东西
    self.section1countLbl.text = [kGetString(self.dicStartData[@"concern_number"]) append:@" 人关注"];
    BOOL isGuanZhu = [self.dicStartData[@"is_concern"] integerValue] == 1;
    [ShareManager setGuanZhuStatus:self.section1GuanZhuBtn status:!isGuanZhu];
    

}




//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return [self.dicData[@"data"] count];//商品颜色的数组
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        NSDictionary * cellData = self.dicData[@"data"][indexPath.row];
        YXHomeXueJiaDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.delegate = self;

        NSString * url = [cellData[@"photo_list"] count] > 0 ? cellData[@"photo_list"][0][@"photo_url"] : @"";
        NSString * str = [(NSMutableString *)url replaceAll:@" " target:@"%20"];
        [cell.section2ImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        cell.whereCome = self.whereCome;
        cell.section2TitleLbl.text = cellData[@"cigar_name"];
        cell.section2Lbl1.text = kGetString(cellData[@"ring_gauge"]) ;
        cell.section2Lbl2.text = kGetString(cellData[@"length"]);
        cell.section2Lbl3.text = kGetString(cellData[@"shape"]);
        cell.section2Lbl4.text = [kGetString(cellData[@"price_box_china"]) append:@"元"];
        cell.section2Lbl5.text = [kGetString(cellData[@"price_single_china"]) append:@"元/支"];
        cell.section2Lbl6.text = [NSString stringWithFormat:@"%@/盒(%@支)",cellData[@"price_box_china"],cellData[@"box_size"]];
        cell.cigar_id = kGetString(cellData[@"id"]);
        //yes为足迹进来 no为正常进入  足迹进来
        cell.stackView1.hidden = cell.likeBtn.hidden = cell.zanCountLbl.hidden = self.whereCome;
        [cell.likeBtn setBackgroundImage:[cellData[@"is_collect"] integerValue] == 1  || !cellData[@"is_collect"] ? _selImage:_unImage forState:UIControlStateNormal];
        cell.zanCountLbl.text = kGetString(cellData[@"collect_number"]);
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == 1) {
        //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
        return self.whereCome ? 130 : 185;
    }
    //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
    return self.whereCome ? 0 : [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        
         //yes为足迹进来 no为正常进入
        if (self.whereCome) {
            UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"YXPublish" bundle:nil];
             YXPublishFootViewController * footVC = [stroryBoard3 instantiateViewControllerWithIdentifier:@"YXPublishFootViewController"];
            footVC.cigar_id = kGetString(self.dicData[@"data"][indexPath.row][@"id"]);
            [self.navigationController pushViewController:footVC animated:YES];

        }else{
            UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
            YXHomeXueJiaPinPaiLastDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiLastDetailViewController"];
            VC.startDic = [NSMutableDictionary dictionaryWithDictionary:self.dicData[@"data"][indexPath.row]];
            [VC.startDic setValue:self.title forKey:@"cigar_brand"];
            
            [self.navigationController pushViewController:VC animated:YES];
        }

    }
}
#pragma mark ========== 关注作者的方法 ==========
- (IBAction)section1GuanZhuAction:(id)sender {
    if ([userManager loadUserInfo]) {
        [self requestMy_concern_cigar];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}
#pragma mark ========== 点赞按钮 ==========
-(void)clickLikeBtn:(BOOL)isZan cigar_id:(NSString *)cigar_id likeBtn:(nonnull UIButton *)likeBtn{
    kWeakSelf(self);
    if ([userManager loadUserInfo]) {
        [YX_MANAGER requestCollect_cigarPOST:@{@"cigar_id":cigar_id} success:^(id object) {
            [likeBtn setBackgroundImage:isZan ? _selImage:_unImage forState:UIControlStateNormal];
            [weakself requestCigar_brand_details];
        }];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}
#pragma mark ========== 重新请求详情 ==========
-(void)requestCigar_brand_details{
    kWeakSelf(self);
    [YX_MANAGER requestCigar_brand_detailsPOST:@{@"cigar_brand_id":kGetString(self.dicStartData[@"id"])} success:^(id object) {
        weakself.dicData = [NSMutableDictionary dictionaryWithDictionary:object];
        [weakself.tableView reloadData];
    }];
}
#pragma mark ========== 请求是否关注 ==========
-(void)requestMy_concern_cigar{
    kWeakSelf(self);
    NSDictionary * cellData = self.dicStartData;
    [YX_MANAGER requestMy_concern_cigarPOST:@{@"cigar_brand_id":cellData[@"id"]} success:^(id object) {
        BOOL isGuanZhu = [weakself.dicData[@"is_concern"] integerValue] == 1;
        [ShareManager setGuanZhuStatus:weakself.section1GuanZhuBtn status:isGuanZhu];
    }];
}

@end
