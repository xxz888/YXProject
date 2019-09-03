//
//  LoginViewController.m
//  MiAiApp
//  17613691277 guojing
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIButton+CountDown.h"
#import "UDPManage.h"
#import "YXBindPhoneViewController.h"
#import "YXLoginXieYiViewController.h"
#import "SocketRocketUtility.h"
@interface LoginViewController ()<UITextFieldDelegate>
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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.codeTf.delegate = self;
    [self.codeTf addTarget:self action:@selector(changeCodeAction) forControlEvents:UIControlEventAllEvents];
    self.loginBtn.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
    self.loginBtn.userInteractionEnabled = NO;
    [self.getMes_codeBtn addTarget:self action:@selector(getSms_CodeAction) forControlEvents:UIControlEventTouchUpInside];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getSms_CodeAction{
    if (self.phoneTf.text.length <= 10) {
        [QMUITips showError:@"请输入正确的手机号"];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestSmscodeGET:[self.phoneTf.text append:@"/1/"] success:^(id object) {
            [QMUITips showSucceed:@"验证码发送成功" inView:weakself.view hideAfterDelay:2];
            [weakself.getMes_codeBtn startWithTime:180
                                         title:@"点击重新获取"
                                countDownTitle:@"s"
                                     mainColor:KClearColor
                                    countColor:KClearColor];
    }];
}
-(void)changeCodeAction{
    if (self.codeTf.text.length >= 6) {
        self.loginBtn.backgroundColor = [UIColor colorWithRed:10/255.0 green:36/255.0 blue:54/255.0 alpha:1.0];
        self.loginBtn.userInteractionEnabled = YES;
    }else{
        self.loginBtn.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
        self.loginBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 视频播放结束 触发
- (void)playToEnd
{
    // 重头再来
    [self.player seekToTime:kCMTimeZero];
}

- (IBAction)weiboLoginAction:(id)sender {
    [userManager LoginVCCommonAction:self type:kUserLoginTypeWeiBo];
}
- (IBAction)wxLoginAction:(id)sender {
    [userManager LoginVCCommonAction:self type:kUserLoginTypeWeChat];
}
- (IBAction)qqLoginAction:(id)sender {
    [userManager LoginVCCommonAction:self type:kUserLoginTypeQQ];
}
@end
