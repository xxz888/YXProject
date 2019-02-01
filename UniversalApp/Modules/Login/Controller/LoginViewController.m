//
//  LoginViewController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AVFoundation/AVFoundation.h>
#import "UIButton+CountDown.h"

@interface LoginViewController ()
//1 播放器
@property (strong, nonatomic) AVPlayer *player;
@property(nonatomic,strong)QMUIButton * button;
@end

@implementation LoginViewController
#pragma mark - 1 viewWillAppear 就进行播放
- (void)viewWillAppear:(BOOL)animated
{
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
    
    self.getMes_codeBtn.backgroundColor = [UIColor colorWithRed:84 / 255.0 green:180 / 255.0 blue:98 / 255.0 alpha:1.0f];
    [self.getMes_codeBtn addTarget:self action:@selector(getSms_CodeAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)WXLogin{
    [userManager login:kUserLoginTypeWeChat completion:^(BOOL success, NSString *des) {
        if (success) {
            DLog(@"登录成功");
        }else{
            DLog(@"登录失败：%@", des);
        }
    }];
}
-(void)QQLogin{
    [userManager login:kUserLoginTypeQQ completion:^(BOOL success, NSString *des) {
        if (success) {
            DLog(@"登录成功");
        }else{
            DLog(@"登录失败：%@", des);
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
- (IBAction)loginAction:(id)sender {
    kWeakSelf(self);
    [YX_MANAGER requestLoginPOST:@{@"mobile":self.phoneTf.text,@"sms_code":self.codeTf.text} success:^(id object) {
            [userManager login:kUserLoginTypePwd params:object completion:^(BOOL success, NSString *des) {
                [weakself dismissViewControllerAnimated:YES completion:nil];
                [QMUITips showSucceed:@"登录成功" inView:self.view hideAfterDelay:2];
                [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
            }];
   
    }];
}
- (IBAction)closeLoginView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [[AppDelegate shareAppDelegate].mainTabBar setSelectedIndex:0];
    }];


    
}
- (void)getSms_CodeAction{
    [YX_MANAGER requestSmscodeGET:self.phoneTf.text success:^(id object) {
            [QMUITips showSucceed:@"验证码发送成功" inView:self.view hideAfterDelay:2];
            [self.getMes_codeBtn startWithTime:180
                                         title:@"点击重新获取"
                                countDownTitle:@"s"
                                     mainColor:[UIColor colorWithRed:84 / 255.0 green:180 / 255.0 blue:98 / 255.0 alpha:1.0f]
                                    countColor:[UIColor colorWithRed:84 / 255.0 green:180 / 255.0 blue:98 / 255.0 alpha:1.0f]];
    }];
    
}
#pragma mark - 视频播放结束 触发
- (void)playToEnd
{
    // 重头再来
    [self.player seekToTime:kCMTimeZero];
}

- (IBAction)wxLoginAction:(id)sender {
     [QMUITips showInfo:SHOW_FUTURE_DEV inView:self.view hideAfterDelay:1];
}
- (IBAction)qqLoginAction:(id)sender {
    [QMUITips showInfo:SHOW_FUTURE_DEV inView:self.view hideAfterDelay:1];
}
@end
