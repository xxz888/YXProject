//
//  YXMessageThreeDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMessageThreeDetailViewController.h"
#import "YXMessageThreeDetailViewCell.h"
#import "YXMineImageDetailViewController.h"
#import "YXFindImageTableViewCell.h"
#import "YXMineFootDetailViewController.h"
#import "YXFindImageTableViewCell.h"
#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "XHWebImageAutoSize.h"
#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
#import "HGPersonalCenterViewController.h"

@interface YXMessageThreeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * yxTableView;
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXMessageThreeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    [self tableviewCon];
    [self addRefreshView:self.yxTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self commonRequest];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)commonRequest{
    //点赞
    if (self.whereCome == 1) {
        [self dianzanRequest];
    }else if(self.whereCome == 2){
        [self fensiRequest];
    }else if(self.whereCome == 3){
        [self hudongRequest];
    }
}
- (void)headerRereshing{
    [self commonRequest];
}
-(void)footerRereshing{
    [self commonRequest];

}
-(void)dianzanRequest{
    kWeakSelf(self);
    [YX_MANAGER requestGETPraiseHistory:NSIntegerToNSString(self.requestPage) success:^(id object) {
        [weakself commonRespond:object];
    }];
}
-(void)fensiRequest{
    kWeakSelf(self);
    [YX_MANAGER requestGETFansHistory:NSIntegerToNSString(self.requestPage) success:^(id object) {
        [weakself commonRespond:object];
    }];
}
-(void)hudongRequest{
    kWeakSelf(self);
    [YX_MANAGER requestGETCommenHistory:NSIntegerToNSString(self.requestPage) success:^(id object) {
        [weakself commonRespond:object];
    }];
}
-(void)commonRespond:(id)object{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:object];
    [self.yxTableView reloadData];
    [self.yxTableView.mj_header endRefreshing];
    [self.yxTableView.mj_footer endRefreshing];
}
#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)  style:0];
    
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMessageThreeDetailViewCell" bundle:nil] forCellReuseIdentifier:@"YXMessageThreeDetailViewCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whereCome == 3) {
         NSDictionary * dic = self.dataArray[indexPath.row];
         return 190 +  [YXMessageThreeDetailViewCell jisuanGaoDu:dic];
    }else if(self.whereCome == 2){
        return 68;
    }else{
         return 210;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMessageThreeDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMessageThreeDetailViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    [cell.titleImg sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:dic[@"user_photo"]]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    cell.lbl1.text = dic[@"user_name"];
    cell.lbl3.text =  [ShareManager timestampSwitchTime:[dic[@"fans_time"] integerValue] andFormatter:@""];
    cell.userId = dic[@"user_id"];
    cell.tag = indexPath.row;
    NSArray * photoArray = [dic[@"photo"] split:@","];
    NSString * photo = @"";
    if ([photoArray count] > 0) {
        photo = [IMG_URI append:photoArray[0]];
    }
    if ([dic[@"photo"] contains:IMG_OLD_URI]) {
        photo = [IMG_URI append: [dic[@"photo"] split:IMG_OLD_URI][1]];
    }
    [cell.rightImv sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"img_moren"]];

    kWeakSelf(self);
    cell.imgBlock = ^(YXMessageThreeDetailViewCell * cell) {
        [weakself clickUserImageView:kGetString(cell.userId)];
    };
    cell.huifuaction = ^(NSInteger indexRow) {
        NSDictionary * dic = weakself.dataArray[indexRow];
         [weakself dianzanAction:dic];
      };
    cell.lbl1.font = BOLDSYSTEMFONT(14);
    cell.detailLbl.text = dic[@"detail"] ?dic[@"detail"] : dic[@"title"];
    //点赞
    if (self.whereCome == 1) {
        cell.lbl2.text = [ShareManager timestampSwitchTime:[dic[@"praise_time"] integerValue] andFormatter:@""];
        [ShareManager setAllContentAttributed:9 inLabel:cell.cellContentLbl font:SYSTEMFONT(16)];
        cell.cellContentLbl.font =  SYSTEMFONT(16);
        cell.cellContentLbl.text = @"赞了你的帖子";
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:cell.cellContentLbl.text];
        NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
        attchImage.image = [UIImage imageNamed:@"messageDetailZan"];
        attchImage.bounds = CGRectMake(0, -5, 22, 22);
        NSMutableAttributedString * attriStr1 = [[NSMutableAttributedString alloc] initWithString:@"  "];
        NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
        [attriStr insertAttributedString:stringImage atIndex:0];
        [attriStr insertAttributedString:attriStr1 atIndex:1];
        cell.cellContentLbl.attributedText = attriStr;

    }else if(self.whereCome == 2){
        cell.lbl2.text = @"关注了你";
        cell.fensiLbl2.text = [ShareManager timestampSwitchTime:[dic[@"fans_time"] integerValue] andFormatter:@""];
        cell.guanZhuBtn.hidden = cell.fensiLbl2.hidden = NO;
        
        NSInteger tag = [dic[@"is_like"] integerValue];
        [ShareManager setGuanZhuStatus:cell.guanZhuBtn status:tag == 0 alertView:NO];
        ViewRadius(cell.guanZhuBtn, 14);
        NSString * islike = tag == 1 ? @"互相关注" : @"关注";
        if (tag == 1) {
             cell.guanzhuWidth.constant = 80;
         }else{
             cell.guanzhuWidth.constant = 66;
         }
        [cell.guanZhuBtn setTitle:islike forState:UIControlStateNormal];
        cell.gzBlock = ^(YXMessageThreeDetailViewCell * cell) {
            [YX_MANAGER requestLikesActionGET:kGetString(cell.userId) success:^(id object) {
                BOOL is_like = [cell.guanZhuBtn.titleLabel.text isEqualToString:@"关注"] == 1;
                [ShareManager setGuanZhuStatus:cell.guanZhuBtn status:!is_like alertView:YES];
                NSString * islike = is_like ? @"互相关注" : @"关注";
                [cell.guanZhuBtn setTitle:islike forState:UIControlStateNormal];

                if (is_like) {
                    cell.guanzhuWidth.constant = 80;
                }else{
                    cell.guanzhuWidth.constant = 66;
                }
                ViewRadius(cell.guanZhuBtn, 14);
            }];
        };

    }else if(self.whereCome == 3){
        cell.huifuBtn.hidden = NO;
        [ShareManager setAllContentAttributed:9 inLabel:cell.cellContentLbl font:SYSTEMFONT(16)];
        cell.cellContentLbl.font =  SYSTEMFONT(16);
        cell.cellContentLbl.text = dic[@"comment"];
        cell.lbl2.text = [ShareManager timestampSwitchTime:[dic[@"comment_time"] integerValue] andFormatter:@""];
        cell.cellContentLblHeight.constant = [YXMessageThreeDetailViewCell jisuanGaoDu:dic];
    }
    return cell;
}
#pragma mark ========== 头像点击 ==========
-(void)clickUserImageView:(NSString *)userId{
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    if ([kGetString(userInfo[@"id"]) isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 3;
        return;
    }

    HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
    mineVC.userId = userId;
    mineVC.whereCome = YES;    //  YES为其他人 NO为自己
    [self.navigationController pushViewController:mineVC animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    switch (self.whereCome) {
        case 1:
            [self dianzanAction:dic];
            break;
        case 2:
            [self fensiAction:dic];
            break;
        case 3:
            [self dianzanAction:dic];
            break;
        default:
            break;
    }
}
-(void)dianzanAction:(NSDictionary *)dic{
    NSString * post_id = kGetString(dic[@"post_id"]);
    NSString * post_type = kGetString(dic[@"post_type"]);
    kWeakSelf(self);
    if ([post_type isEqualToString:@"1"]) {
        [YX_MANAGER requestget_post_by_id:post_id success:^(id object) {
            [weakself jumpAction:post_type dic:object];
        }];
    }else if ([post_type isEqualToString:@"2"]){
        [YX_MANAGER requestget_track_by_id:post_id success:^(id object) {
            [weakself jumpAction:post_type dic:object];
        }];
    }else if ([post_type isEqualToString:@"3"]){
        [YX_MANAGER requestget_question_by_id:post_id success:^(id object) {
            [weakself jumpAction:post_type dic:object];
        }];
    }else if ([post_type isEqualToString:@"4"]){
        [YX_MANAGER requestget_cigar_by_id:post_id success:^(id object) {
            UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
            YXHomeXueJiaPinPaiLastDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiLastDetailViewController"];
            VC.startDic = [NSMutableDictionary dictionaryWithDictionary:object];
            [VC.startDic setValue:@"" forKey:@"cigar_brand"];
            weakself.whereCome = YES;
                [self.navigationController pushViewController:VC animated:YES];
        }];
    }
    
}
-(void)fensiAction:(NSDictionary *)dic{
    
}
-(void)hudongAction:(NSDictionary *)dic{
    
}

-(void)jumpAction:(NSString *)tagString dic:(NSDictionary *)dic{
    NSInteger tag = [tagString integerValue];
    if (tag == 1) {//晒图
        YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString * url = dic[@"photo1"];
        CGFloat imageHeight = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
        VC.height = imageHeight;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 3){//问答
        YXHomeXueJiaQuestionDetailViewController * VC = [[YXHomeXueJiaQuestionDetailViewController alloc]init];
//        VC.moment = [ShareManager setTestInfo:dic];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 2){//足迹
        YXMineFootDetailViewController * VC = [[YXMineFootDetailViewController alloc]init];
        NSString * url = dic[@"pic1"];
        CGFloat imageHeight = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        VC.height = imageHeight;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
