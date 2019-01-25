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

@interface YXMineViewController () <UITableViewDelegate,UITableViewDataSource>{
    YXMineAllViewController * AllVC;
    YXMineArticleViewController * ArticleVC;
    YXMineImageViewController * ImageVC;
    YXMineFootViewController * FootVC;
    NSArray * titleArray;
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
-(void)requestGuanZhuAndFenSiCount{
    kWeakSelf(self);
    [YX_MANAGER requestLikesGET:@"4" success:^(id object) {
        weakself.guanzhuCountLbl.text = object;
    }];
    [YX_MANAGER requestLikesGET:@"5" success:^(id object) {
        weakself.fensiCountLbl.text = object;
    }];
}
-(void)setInitCollection{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    
    if (!AllVC) {
        AllVC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineAllViewController"];
    }
    if (!ArticleVC) {
        ArticleVC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineArticleViewController"];
    }
    
    if (!ImageVC) {
        ImageVC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineImageViewController"];
    }
    if (!FootVC) {
        FootVC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineFootViewController"];
    }
//    NSArray* names = @[@"全部",@"晒图",@"文章",@"足迹"];
    NSArray* names = @[@"晒图",@"文章"];

    NSArray* controllers = @[ImageVC,ArticleVC];
    [self setSegmentControllersArray:controllers title:names defaultIndex:0 top:170+50 view:self.view ];
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
    

    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentViewMargins = UIEdgeInsetsMake(0, modalViewController.view.frame.size.width/2.5, 0, 0);
    modalViewController.contentView = self.yxTableView;
    [modalViewController showWithAnimated:YES completion:nil];
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
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
@end
