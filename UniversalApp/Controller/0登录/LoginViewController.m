//
//  LoginViewController.m
//  MiAiApp
//  17613691277 guojing
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AVFoundation/AVFoundation.h>
#import "UIButton+CountDown.h"
#import "UDPManage.h"
#import "YXBindPhoneViewController.h"
#import "YXLoginXieYiViewController.h"

@interface LoginViewController ()
//1 播放器
@property (strong, nonatomic) AVPlayer *player;
- (IBAction)btn1Action:(id)sender;
- (IBAction)btn2Action:(id)sender;
@property(nonatomic,strong)QMUIButton * button;
@end

@implementation LoginViewController
#pragma mark - 1 viewWillAppear 就进行播放
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //视频播放
    //[self.player play];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.phoneTf.layer.masksToBounds = YES;
    self.phoneTf.layer.cornerRadius = 3;
    
    self.codeTf.layer.masksToBounds = YES;
    self.codeTf.layer.cornerRadius = 3;
    YYLabel *snowBtn = [[YYLabel alloc] initWithFrame:CGRectMake(0, 200, 150, 60)];
    snowBtn.text = @"微信登录";
    snowBtn.font = SYSTEMFONT(20);
    snowBtn.textColor = KWhiteColor;
    snowBtn.backgroundColor = CNavBgColor;
    snowBtn.textAlignment = NSTextAlignmentCenter;
    snowBtn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    snowBtn.centerX = KScreenWidth/2;
    
    kWeakSelf(self);
    snowBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //        [MBProgressHUD showTopTipMessage:NSStringFormat(@"%@马上开始",str) isWindow:YES];
        
        [weakself WXLogin];
    };
    
    //[self.view addSubview:snowBtn];
    
    YYLabel *snowBtn2 = [[YYLabel alloc] initWithFrame:CGRectMake(0, 300, 150, 60)];
    snowBtn2.text = @"QQ登录";
    snowBtn2.font = SYSTEMFONT(20);
    snowBtn2.textColor = KWhiteColor;
    snowBtn2.backgroundColor = KRedColor;
    snowBtn2.textAlignment = NSTextAlignmentCenter;
    snowBtn2.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    snowBtn2.centerX = KScreenWidth/2;
    
    snowBtn2.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //        [MBProgressHUD showTopTipMessage:NSStringFormat(@"%@马上开始",str) isWindow:YES];
        
        [weakself QQLogin];
    };
    
    //[self.view addSubview:snowBtn2];
    
    YYLabel *skipBtn = [[YYLabel alloc] initWithFrame:CGRectMake(0, 400, 150, 60)];
    skipBtn.text = @"跳过登录";
    skipBtn.font = SYSTEMFONT(20);
    skipBtn.textColor = KBlueColor;
    skipBtn.backgroundColor = KClearColor;
    skipBtn.textAlignment = NSTextAlignmentCenter;
    skipBtn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    skipBtn.centerX = KScreenWidth/2;
    
    skipBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //        [MBProgressHUD showTopTipMessage:NSStringFormat(@"%@马上开始",str) isWindow:YES];
        
        [weakself skipAction];
    };
    
    //[self.view addSubview:skipBtn];
    
    ViewBorderRadius(self.getMes_codeBtn, 5, 1, A_COlOR);
    [self.getMes_codeBtn addTarget:self action:@selector(getSms_CodeAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)WXLogin{
    kWeakSelf(self);
    [userManager login:kUserLoginTypeWeChat completion:^(BOOL success, NSString *des) {
        if (success) {
            [weakself closeViewAAA];
        }else{
            YXBindPhoneViewController * VC = [[YXBindPhoneViewController alloc]init];
            VC.title = @"绑定手机号";
            RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
            VC.bindBlock = ^{
                [weakself closeViewAAA];
            };
            VC.whereCome = NO;
            VC.unique_id = des;
            [weakself presentViewController:nav animated:YES completion:nil];
        }
    }];
}
-(void)QQLogin{
    kWeakSelf(self);
    [userManager login:kUserLoginTypeQQ completion:^(BOOL success, NSString *des) {
        if (success) {
            [weakself closeViewAAA];
        }else{
            YXBindPhoneViewController * VC = [[YXBindPhoneViewController alloc]init];
            VC.title = @"绑定手机号";
            RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
            VC.bindBlock = ^{
                [weakself closeViewAAA];
            };
            VC.whereCome = NO;
            VC.unique_id = des;
            [weakself presentViewController:nav animated:YES completion:nil];
        }
    }];
}
-(void)closeViewAAA{
    UIViewController *controller = self;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:NO completion:^{
        
        
        if ([userManager loadUserInfo]) {
            [QMUITips showSucceed:@"登录成功"];
            [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
        }else{
            [QMUITips showSucceed:@"绑定成功,请重新登录"];
            KPostNotification(KNotificationLoginStateChange, @NO);
        }
        
        
        


    }];
}

-(void)skipAction{
    KPostNotification(KNotificationLoginStateChange, @YES);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 懒加载AVPlayer
- (AVPlayer *)player
{
    if (!_player) {
        //1 创建一个播放item
        NSString *path = [[NSBundle mainBundle]pathForResource:@"register_guide_video.mp4" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
        // 2 播放的设置
        _player = [AVPlayer playerWithPlayerItem:playItem];
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;// 永不暂停
        // 3 将图层嵌入到0层
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        [self.view.layer insertSublayer:layer atIndex:0];
        // 4 播放到头循环播放
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _player;
}

- (IBAction)btn1Action:(id)sender {
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    YXLoginXieYiViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXLoginXieYiViewController"];
    VC.type = @"1";
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)btn2Action:(id)sender {
    UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    YXLoginXieYiViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXLoginXieYiViewController"];
    VC.type = @"2";
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)loginAction:(id)sender {
    kWeakSelf(self);
    [YX_MANAGER requestLoginPOST:@{@"mobile":self.phoneTf.text,@"sms_code":self.codeTf.text} success:^(id object) {
            [userManager login:kUserLoginTypePwd params:object completion:^(BOOL success, NSString *des) {
                [weakself dismissViewControllerAnimated:YES completion:nil];
                [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
                [QMUITips showSucceed:@"登录成功"];
            }];
   
    }];
}
- (IBAction)closeLoginView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    
    }];


    
}
- (void)getSms_CodeAction{
    if (self.phoneTf.text.length <= 10) {
        [QMUITips showError:@"请输入正确的手机号"];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestSmscodeGET:[self.phoneTf.text append:@"/1/"] success:^(id object) {
            [QMUITips showSucceed:@"验证码发送成功" inView:self.view hideAfterDelay:2];
            [weakself.getMes_codeBtn startWithTime:180
                                         title:@"点击重新获取"
                                countDownTitle:@"s"
                                     mainColor:C_COLOR
                                    countColor:C_COLOR];
    }];
    
}
#pragma mark - 视频播放结束 触发
- (void)playToEnd
{
    // 重头再来
    [self.player seekToTime:kCMTimeZero];
}

- (IBAction)wxLoginAction:(id)sender {
    [self WXLogin];
}
- (IBAction)qqLoginAction:(id)sender {
    [self QQLogin];

}
@end
