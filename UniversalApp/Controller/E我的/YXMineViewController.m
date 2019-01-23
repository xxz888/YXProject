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

@interface YXMineViewController (){
    YXMineAllViewController * AllVC;
    YXMineArticleViewController * ArticleVC;
    YXMineImageViewController * ImageVC;
    YXMineFootViewController * FootVC;
}
@property(nonatomic, strong) UserInfo *userInfo;//用户信息

@end

@implementation YXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //头部赋值
    [self setHeaderViewValue];
    //下部四个按钮
    [self setInitCollection];
    
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
    NSArray* names = @[@"全部",@"晒图",@"文章",@"足迹"];
    NSArray* controllers = @[AllVC,ImageVC,ArticleVC,FootVC];
    [self setSegmentControllersArray:controllers title:names defaultIndex:1 top:170+50 view:self.view  ];
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
    self.guanzhuBtn.hidden = NO;
    [self.guanzhuBtn setTitle:@"✓ 已关注" forState:UIControlStateNormal];
    ViewBorderRadius(self.guanzhuBtn, 5, 1,CFontColor1);
    
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

- (IBAction)guanzhuAction:(id)sender {
}
@end
