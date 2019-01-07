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
@interface YXHomeXueJiaPinPaiDetailViewController()<ClickLikeBtnDelegate>{
    UIImage * _selImage;
    UIImage * _unImage;
}

@end
@implementation YXHomeXueJiaPinPaiDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaDetailTableViewCell"];
    
    [self initData];

}
-(void)initData{
    
    _selImage = [UIImage imageNamed:@"Zan"];
    _unImage = [UIImage imageNamed:@"UnZan"];

    NSDictionary * cellData = self.dicStartData;
    self.title = cellData[@"cigar_brand"];
    
    [self.section1ImageView sd_setImageWithURL:[NSURL URLWithString:cellData[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.section1ImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.section1TextView.text = kGetString(cellData[@"intro"]);
    self.section1TitleLbl.text = [NSString stringWithFormat:@"%@/%@",cellData[@"sort"],cellData[@"cigar_brand"]];

    ViewBorderRadius(self.section1GuanZhuBtn, 5, 1, self.section1GuanZhuBtn.titleLabel.textColor);
    
    
    
    
    
    //用的不是一个字典的东西
    self.section1countLbl.text = [kGetString(self.dicData[@"concern_number"]) append:@" 人关注"];
    UIColor * color1 = [UIColor darkGrayColor];
    if ([self.dicData[@"is_concern"] integerValue] == 1) {
        [self.section1GuanZhuBtn setTitle:@"✓ 已关注" forState:UIControlStateNormal];
        [self.section1GuanZhuBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [self.section1GuanZhuBtn setBackgroundColor:color1];
        ViewBorderRadius(self.section1GuanZhuBtn, 5, 1, color1);
    }else{
        [self.section1GuanZhuBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.section1GuanZhuBtn setTitleColor:color1 forState:UIControlStateNormal];
        ViewBorderRadius(self.section1GuanZhuBtn, 5, 1, color1);
    }
    

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
        [cell.section2ImageView sd_setImageWithURL:[NSURL URLWithString:cellData[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
//        [cell.section2ImageView setContentMode:UIViewContentModeScaleAspectFit];
        cell.section2TitleLbl.text = cellData[@"cigar_name"];
        cell.section2Lbl1.text = kGetString(cellData[@"ring_gauge"]) ;
        cell.section2Lbl2.text = kGetString(cellData[@"length"]);
        cell.section2Lbl3.text = kGetString(cellData[@"shape"]);
        cell.section2Lbl4.text = [kGetString(cellData[@"price_box_china"]) append:@"元"];
        cell.section2Lbl5.text = [kGetString(cellData[@"price_single_china"]) append:@"元/支"];
        cell.section2Lbl6.text = [NSString stringWithFormat:@"%@元/盒\n(%@)支",cellData[@"price_box_china"],cellData[@"box_size"]];
        cell.cigar_id = kGetString(cellData[@"id"]);
        
        [cell.likeBtn setBackgroundImage:[cellData[@"is_collect"] integerValue] == 1 ? _selImage:_unImage forState:UIControlStateNormal];
        
        cell.delegate = self;
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(void)setLayoutCol:(YXHomeXueJiaDetailTableViewCell *)cell{
    kWeakSelf(self);
    CatZanButton *zanBtn=[[CatZanButton alloc] init];
    [zanBtn setCenter:cell.center];

    [cell addSubview:zanBtn];
//    zanBtn.frame = CGRectMake(0, 0, 30, 30);
    [zanBtn setType:CatZanButtonTypeFirework];
    [zanBtn setClickHandler:^(CatZanButton *zanButton) {
      
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 250;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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
    [YX_MANAGER requestCigar_brand_detailsPOST:@{@"cigar_brand":self.title} success:^(id object) {
        weakself.dicData = [NSMutableDictionary dictionaryWithDictionary:object];
        [weakself.tableView reloadData];
    }];
}
#pragma mark ========== 请求是否关注 ==========
-(void)requestMy_concern_cigar{
    kWeakSelf(self);
    NSDictionary * cellData = self.dicStartData;

    [YX_MANAGER requestMy_concern_cigarPOST:@{@"cigar_brand":self.title,@"photo":cellData[@"photo"]} success:^(id object) {
        UIColor * color1 = [UIColor darkGrayColor];

        if ([weakself.section1GuanZhuBtn.titleLabel.text isEqualToString:@"关注"]) {
            [weakself.section1GuanZhuBtn setTitle:@"✓ 已关注" forState:UIControlStateNormal];
            [weakself.section1GuanZhuBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
            [weakself.section1GuanZhuBtn setBackgroundColor:color1];
            ViewBorderRadius(weakself.section1GuanZhuBtn, 5, 1, color1);
        }else{
            [weakself.section1GuanZhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            [weakself.section1GuanZhuBtn setTitleColor:color1 forState:UIControlStateNormal];
            ViewBorderRadius(weakself.section1GuanZhuBtn, 5, 1, color1);
        }

    }];
}
@end
