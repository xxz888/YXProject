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
    
    
    /*
     *   controllers长度和names长度必须一致，否则将会导致cash
     *   segmentController在一个屏幕里最多显示6个按钮，如果超过6个，将会自动开启滚动功能，如果不足6个，按钮宽度=父view宽度/x  (x=按钮个数)
     */
    ZXSegmentController* segmentController = [[ZXSegmentController alloc] initWithControllers:controllers
                                                                               withTitleNames:names
                                                                             withDefaultIndex:1
                                                                               withTitleColor:[UIColor grayColor]
                                                                       withTitleSelectedColor:YXRGBAColor(88, 88, 88)
                                                                              withSliderColor:YXRGBAColor(88, 88, 88)];
    [self addChildViewController:(self.segmentController = segmentController)];
    [self.view addSubview:segmentController.view];
    [segmentController didMoveToParentViewController:self];
    [self createAutolayout];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [segmentController scrollToIndex:1 animated:YES];
}
- (void)createAutolayout{
    /*
     高度自由化的布局，可以根据需求，把segmentController布局成你需要的样子.(面对不同的场景，设置不同的top距离)
     */
    [self.segmentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(260);
        make.left.right.bottom.mas_equalTo(0);
    }];
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
