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
#import "YXFindViewController.h"
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


@end

@implementation YXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //头部赋值
    [self setHeaderViewValue];
    //下部四个按钮
    [self setInitCollection];
    [self setLayoutCol];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次进入界面刷新关注和粉丝数量
    [self requestGuanZhuAndFenSiCount];
}
#pragma mark ========== 关注粉丝贴数列表 ==========
-(void)requestGuanZhuAndFenSiCount{
    kWeakSelf(self);
    [YX_MANAGER requestLikesGET:@"4" success:^(id object) {
        weakself.guanzhuCountLbl.text = kGetString(object[@"like_number"]);
        weakself.fensiCountLbl.text = kGetString(object[@"fans_number"]);
        weakself.tieshuCountLbl.text = kGetString(object[@"pubulish_number"]);
    }];
}
-(void)setInitCollection{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXFindViewController * findVC = [[YXFindViewController alloc]init];
    findVC.whereCome = YES;
    findVC.view.frame = CGRectMake(5, 160, KScreenWidth-10, kScreenHeight-170);
    [self addChildViewController:findVC];
    [self.view insertSubview:findVC.view atIndex:0];
}

-(void)setHeaderViewValue{
    self.userInfo = curUser;

    [self.mineImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.photo] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.mineImageView.layer.masksToBounds = YES;
    self.mineImageView.layer.cornerRadius = self.mineImageView.frame.size.width / 2.0;
    self.navigationController.title = self.userInfo.username;
    self.mineTitle.text = self.userInfo.username;
    
//    self.mineAdress.text = [[self.userInfo.province append:@"  "] append:self.userInfo.country];
//    self.mineAdress.text = [self.mineAdress.text isEqualToString:@""] ? @"浙江 杭州":self.mineAdress.text;
    
    self.mineAdress.text = @"浙江 杭州";
    ViewBorderRadius(self.guanzhuBtn, 5, 1,CFontColor1);
    ViewBorderRadius(self.editPersonBtn, 5, 1, CFontColor1);

    [self addNavigationItemWithImageNames:@[@"菜单"] isLeft:NO target:self action:@selector(handleShowContentView) tags:nil];
}
-(void)caidanClick{
    [self setLayoutCol];
}
-(void)requestLikesGuanzhu{
    kWeakSelf(self);
    [YX_MANAGER requestLikesGET:@"1" success:^(id object) {
        weakself.guanzhuCountLbl.text = [NSString stringWithFormat:@"%lu",[object count]];
    }];
}

- (IBAction)fensiAction:(id)sender {
    
}
- (IBAction)tieshuAction:(id)sender {

}
- (void)handleShowContentView {
    
    if (!_modalViewController) {
        _modalViewController = [[QMUIModalPresentationViewController alloc] init];
    }
    _modalViewController.contentViewMargins = UIEdgeInsetsMake(0, _modalViewController.view.frame.size.width/2.5, 0, 0);
    _modalViewController.contentView = self.yxTableView;
    [_modalViewController showWithAnimated:YES completion:nil];
    [self.yxTableView reloadData];
}
- (IBAction)editPersonAction:(id)sender {
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXHomeEditPersonTableViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXHomeEditPersonTableViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)guanzhuAction:(id)sender {
}










-(void)setLayoutCol{
    CGRect frame = CGRectMake(0, 0, KScreenWidth/1.5, KScreenHeight);
    self.yxTableView = [[UITableView alloc]initWithFrame:frame style:0];
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
    titleArray = @[@"更多",@"我的草稿",@"发现好友",@"我的关注收藏",@"我的点赞",@"我的评论",@"设置"];
    self.yxTableView.backgroundColor = UIColorWhite;
    self.yxTableView.layer.cornerRadius = 6;
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource = self;
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = KScreenHeight-titleArray.count * 50;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
}
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
    }else if (indexPath.row == 3) {
        YXMineMyCollectionViewController * VC = [[YXMineMyCollectionViewController alloc]init];
        VC.dicData = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"dicData"]];
        VC.dicStartData = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"dicStartData"]];
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
