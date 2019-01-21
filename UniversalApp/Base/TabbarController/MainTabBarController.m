//
//  MainTabBarController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "MainTabBarController.h"

#import "RootNavigationController.h"
#import "HomeViewController.h"
#import "WaterFallListViewController.h"
#import "PersonListViewController.h"
#import "MakeFriendsViewController.h"
#import "MsgViewController.h"
#import "MineViewController.h"
#import "ToolDemoViewController.h"
#import "DraggingCardViewController.h"
#import "UITabBar+CustomBadge.h"
#import "XYTabBar.h"

#import "YXHomeViewController.h"
#import "YXFindViewController.h"
#import "YXMessageViewController.h"
#import "YXPublishViewController.h"
#import "YXMineViewController.h"
#import "TBTabBar.h"
#import "VTingSeaPopView.h"
#import "SDTimeLineTableViewController.h"

#import "YXPublishImageViewController.h"
#import "YXPublishArticleViewController.h"
@interface MainTabBarController ()<UITabBarControllerDelegate,VTingPopItemSelectDelegate> {
    NSMutableArray *images;
    NSMutableArray *titles;
    NSMutableArray *titlesTag;
    
    VTingSeaPopView *pop;
}

@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC

@end

@implementation MainTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
    
    // 创建tabbar中间的tabbarItem
    [self setUpMidelTabbarItem];
}

#pragma mark -创建tabbar中间的tabbarItem

- (void)setUpMidelTabbarItem {
    images = [NSMutableArray array];
    titles = [NSMutableArray arrayWithObjects:@"晒图",@"足迹",@"文章",nil];
    titlesTag =  [NSMutableArray arrayWithObjects:@"定格美好瞬间",@"记录品鉴足迹",@"分享你的故事",nil];
    for (int i = 0; i<3; i++) {
        if (i<3) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]]];
        }else{
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"remind"]]];
        }
    }
    TBTabBar *tabBar = [[TBTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    
    __weak typeof(self) weakSelf = self;
    [tabBar setDidClickPublishBtn:^{
        pop = [[VTingSeaPopView alloc] initWithButtonBGImageArr:images andButtonBGT:titles titlsTag:titlesTag];
        //依次遍历self.view中的所有子视图
        for(id tmpView in [self.view subviews]){
            if([tmpView isKindOfClass:[VTingSeaPopView class]]){
                VTingSeaPopView * seaPopView = (VTingSeaPopView *)tmpView;
                    [seaPopView removeFromSuperview];
                    break;
            }
        }
        [self.view addSubview:pop];
        pop.delegate = weakSelf;
        [pop show];
        
    }];
    
}
#pragma mark delegate
-(void)itemDidSelected:(NSInteger)index {
    NSLog(@"点击了%ld:item",index);
    __weak typeof(self) weakSelf = self;
    UIStoryboard * stroryBoard3 = [UIStoryboard storyboardWithName:@"YXPublish" bundle:nil];

    if (index == 0) {//晒图
        YXPublishImageViewController * publishVC = [stroryBoard3 instantiateViewControllerWithIdentifier:@"YXPublishImageViewController"];
        [weakSelf presentViewController:publishVC animated:YES completion:nil];
    }else if (index == 2){//文章
        YXPublishArticleViewController * publishVC = [stroryBoard3 instantiateViewControllerWithIdentifier:@"YXPublishArticleViewController"];
        [weakSelf presentViewController:publishVC animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[XYTabBar new] forKey:@"tabBar"];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
}

#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
//    HomeViewController *homeVC = [[HomeViewController alloc]init];
//    WaterFallListViewController *homeVC = [WaterFallListViewController new];
//    PersonListViewController *homeVC = [[PersonListViewController alloc]init];
    
    //[[SDTimeLineTableViewController alloc]init]
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
    YXHomeViewController * homeVC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeViewController"];

    [self setupChildViewController:homeVC title:@"首页" imageName:@"icon_tabbar_homepage" seleceImageName:@"icon_tabbar_homepage_selected"];
    
//    MakeFriendsViewController *makeFriendVC = [[MakeFriendsViewController alloc]init];
//    ToolDemoViewController *makeFriendVC = [[ToolDemoViewController alloc]init];
    UIStoryboard * stroryBoard2 = [UIStoryboard storyboardWithName:@"YXFind" bundle:nil];
    YXFindViewController * findVC = [stroryBoard2 instantiateViewControllerWithIdentifier:@"YXFindViewController"];
    [self setupChildViewController:findVC title:@"发现" imageName:@"icon_tabbar_onsite" seleceImageName:@"icon_tabbar_onsite_selected"];
    
//    MsgViewController *msgVC = [[MsgViewController alloc]init];
//    DraggingCardViewController *msgVC = [DraggingCardViewController new];

    
    
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMessage" bundle:nil];
    YXMessageViewController * messageVC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMessageViewController"];
    [self setupChildViewController:messageVC title:@"发现" imageName:@"icon_tabbar_merchant_normal" seleceImageName:@"icon_tabbar_merchant_selected"];
    
    //   MineViewController *mineVC = [[MineViewController alloc]init];

    UIStoryboard * stroryBoard5 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    YXMineViewController * mineVC = [stroryBoard5 instantiateViewControllerWithIdentifier:@"YXMineViewController"];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"icon_tabbar_mine" seleceImageName:@"icon_tabbar_mine_selected"];
    self.viewControllers = _VCS;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KBlackColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CNavBgColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateSelected];
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
//    [self addChildViewController:nav];
    [_VCS addObject:nav];
    
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 3 && ![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}

-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    if (isShow) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:index];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:index];
    }
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
    if([item.title isEqualToString:@"发现"])
    {
        // 也可以判断标题,然后做自己想做的事<img alt="得意" src="http://static.blog.csdn.net/xheditor/xheditor_emot/default/proud.gif" />
    }
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
