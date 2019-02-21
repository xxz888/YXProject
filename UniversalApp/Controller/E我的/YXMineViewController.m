//
//  YXMineViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>
#import "YXMineAllViewController.h"
#import "YXMineArticleViewController.h"
#import "YXMineImageViewController.h"
#import "YXMineFootViewController.h"
#import "YXHomeEditPersonTableViewController.h"
#import "YXMineMyCollectionViewController.h"
#import "YXMinePingLunViewController.h"
#import "YXMineSettingTableViewController.h"
#import "YXMineMyCaoGaoViewController.h"
#import "YXMineMyDianZanViewController.h"
#import "YXMineFenSiViewController.h"
#import "YXMineGuanZhuViewController.h"
#import "YXMineAllViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineViewController () <UITableViewDelegate,UITableViewDataSource>{
    YXMineAllViewController * AllVC;
    YXMineArticleViewController * ArticleVC;
    YXMineImageViewController * ImageVC;
    YXMineFootViewController * FootVC;
    NSArray * titleArray;
     QMUIModalPresentationViewController * _modalViewController;
    
}
@property(nonatomic, strong) UserInfo *userInfo;//用户信息
@property (strong, nonatomic) UITableView *yxTableView;
@property(nonatomic, strong) NSDictionary *userInfoDic;//用户信息


@end

@implementation YXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UI赋值
    [self setViewUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次进入界面请求数据
    [self setViewData];
}
#pragma mark ========== UI界面 ==========
-(void)setViewUI{
    self.navigationItem.title = @"我的";

    NSArray * menuArray = nil;
    if (self.whereCome) {
        self.guanzhuBtn.hidden = NO;
        self.editPersonBtn.hidden = YES;
    }else{
        menuArray = @[@"菜单"];
        self.guanzhuBtn.hidden = YES;
        self.editPersonBtn.hidden = NO;
        [self setLayoutCol];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addNavigationItemWithImageNames:menuArray isLeft:NO target:self action:@selector(handleShowContentView) tags:nil];
    self.mineImageView.layer.masksToBounds = YES;
    self.mineImageView.layer.cornerRadius = self.mineImageView.frame.size.width / 2.0;
    ViewBorderRadius(self.guanzhuBtn, 5, 1,CFontColor1);
    ViewBorderRadius(self.editPersonBtn, 5, 1, CFontColor1);
    [self setSegmentControllerUI];
}
-(void)setSegmentControllerUI{
    UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXMineImageViewController * imageVC = [[YXMineImageViewController alloc]init];
    imageVC.userId = self.userId;

    YXMineArticleViewController * articleVC = [stroryBoard instantiateViewControllerWithIdentifier:@"YXMineArticleViewController"];
    articleVC.userId = self.userId;
    
    YXMineAllViewController * AllVC = [[YXMineAllViewController alloc]init];
    AllVC.userId = self.userId;
    
    YXMineFootViewController * footVC = [[YXMineFootViewController alloc]init];
    footVC.userId = self.userId;
    [self setSegmentControllersArray:@[AllVC,imageVC,footVC] title:@[@"全部",@"晒图",@"足迹"] defaultIndex:0 top:140 view:self.view];
}
#pragma mark ========== 数据 ==========
-(void)setViewData{
    kWeakSelf(self);
    //  YES为其他人 NO为自己
    if (self.whereCome) {
        [YX_MANAGER requestGetUserothers:self.userId success:^(id object) {
            [weakself personValue:object];
        }];
     
    }else{
        self.userInfo = curUser;
        [YX_MANAGER requestGetFind_user_id:user_id_BOOL ? self.userId : self.userInfo.id success:^(id object) {
            [weakself personValue:object];
        }];
        [YX_MANAGER requestLikesGET:@"4" success:^(id object) {
            weakself.guanzhuCountLbl.text = kGetString(object[@"like_number"]);
            weakself.fensiCountLbl.text = kGetString(object[@"fans_number"]);
            weakself.tieshuCountLbl.text = kGetString(object[@"pubulish_number"]);
        }];
    }
}
-(void)personValue:(id)object{
    NSString * str = [(NSMutableString *)object[@"photo"] replaceAll:@" " target:@"%20"];
    [self.mineImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.navigationItem.title = kGetString(object[@"username"]);
    self.mineTitle.text =kGetString(object[@"username"]);
    self.mineAdress.text = kGetString(object[@"site"]);
    self.guanzhuCountLbl.text = kGetString(object[@"likes_number"]);
    self.fensiCountLbl.text = kGetString(object[@"fans_number"]);
    self.tieshuCountLbl.text = kGetString(object[@"publish_number"]);
    NSInteger tag = [object[@"is_like"] integerValue];
    NSString * islike = tag == 1 ? @"互相关注" : tag == 2 ? @"已关注" : @"关注";
    [self.guanzhuBtn setTitle:islike forState:UIControlStateNormal];
    self.userInfoDic = [NSDictionary dictionaryWithDictionary:object];
}
- (IBAction)guanzhuOtherAction:(id)sender {
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestLikesActionGET:self.userId success:^(id object) {
        BOOL is_like = [weakself.guanzhuBtn.titleLabel.text isEqualToString:@"关注"] == 1;
        [QMUITips showSucceed:is_like ?@"关注成功": @"已取消关注" inView:weakself.view hideAfterDelay:2];
        [ShareManager setGuanZhuStatus:weakself.guanzhuBtn status:!is_like];
    }];
}
#pragma mark ========== 关注按钮 ==========
- (IBAction)guanzhuAction:(id)sender{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXMineGuanZhuViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineGuanZhuViewController"];
    VC.userId = self.userId;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 粉丝按钮 ==========
- (IBAction)fensiAction:(id)sender {
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXMineFenSiViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineFenSiViewController"];
    VC.userId = self.userId;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 贴数按钮 ==========
- (IBAction)tieshuAction:(id)sender {

}
#pragma mark ========== 点击菜单按钮的方法 ==========
- (void)handleShowContentView {
    if (!_modalViewController) {
        _modalViewController = [[QMUIModalPresentationViewController alloc] init];
    }
    _modalViewController.contentViewMargins = UIEdgeInsetsMake(0, _modalViewController.view.frame.size.width/2.5, 0, 0);
    _modalViewController.contentView = self.yxTableView;
    [_modalViewController showWithAnimated:YES completion:nil];
    [self.yxTableView reloadData];
}
#pragma mark ========== 编辑个人资料 ==========
- (IBAction)editPersonAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXHomeEditPersonTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXHomeEditPersonTableViewController"];
    VC.userInfoDic = [NSDictionary dictionaryWithDictionary:self.userInfoDic];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 右上角菜单按钮 ==========
-(void)setLayoutCol{
    CGRect frame = CGRectMake(0,AxcAE_IsiPhoneX ? kTopHeight : 0, KScreenWidth/1.5, AxcAE_IsiPhoneX ? KScreenHeight - kTopHeight :KScreenHeight);
    self.yxTableView = [[UITableView alloc]initWithFrame:frame style:1];
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
    titleArray = @[@"更多",@"我的草稿",@"发现好友",@"我的收藏",@"我的点赞",@"我的点评",@"设置"];
    self.yxTableView.backgroundColor = UIColorWhite;
    self.yxTableView.layer.cornerRadius = 6;
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource = self;
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = KScreenHeight-titleArray.count * 50;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
}
#pragma mark ========== 菜单view的方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return KScreenHeight-titleArray.count * 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    if (indexPath.row != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    UIImage * icon =[UIImage imageNamed:titleArray[indexPath.row]];
    CGSize itemSize = CGSizeMake(25, 25);//固定图片大小为36*36
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);//*1
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();//*2
    UIGraphicsEndImageContext();//*3
    cell.textLabel.text =titleArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1){
        YXMineMyCaoGaoViewController * VC = [[YXMineMyCaoGaoViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if(indexPath.row == 2){
        [QMUITips showInfo:SHOW_FUTURE_DEV inView:self.view hideAfterDelay:1];
    }
    else if (indexPath.row == 3) {
        YXMineMyCollectionViewController * VC = [[YXMineMyCollectionViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 4){
        YXMineMyDianZanViewController * VC = [[YXMineMyDianZanViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 5){
        YXMinePingLunViewController * VC = [[YXMinePingLunViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 6){
        UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
        YXMineSettingTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineSettingTableViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    [_modalViewController hideWithAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
