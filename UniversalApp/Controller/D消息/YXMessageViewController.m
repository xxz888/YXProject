//
//  YXMessageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMessageViewController.h"
#import "YXMessageThreeDetailViewController.h"

@interface YXMessageViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic) BOOL isCanBack;
@end

@implementation YXMessageViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
#pragma mark -- 禁用边缘返回
-(void)forbiddenSideBack{
    self.isCanBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}
#pragma mark --恢复边缘返回
- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我的消息";
    self.view.backgroundColor = YXRGBAColor(239, 239, 239);
    
    [self setUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNewMessageNumeber];

}
-(void)setUI{
    self.zanjb.layer.masksToBounds = YES;
    self.zanjb.layer.cornerRadius = self.zanjb.frame.size.width / 2.0;
    
    self.fensijb.layer.masksToBounds = YES;
    self.fensijb.layer.cornerRadius = self.fensijb.frame.size.width / 2.0;
    
    self.hdjb.layer.masksToBounds = YES;
    self.hdjb.layer.cornerRadius = self.hdjb.frame.size.width / 2.0;
    
    //view添加点击事件
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.view1.tag = 1001;
    [self.view1 addGestureRecognizer:tapGesturRecognizer1];
    
    UITapGestureRecognizer *tapGesturRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.view2.tag = 1002;
    [self.view2 addGestureRecognizer:tapGesturRecognizer2];
    
    UITapGestureRecognizer *tapGesturRecognizer3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.view3.tag = 1003;
    [self.view3 addGestureRecognizer:tapGesturRecognizer3];
}
-(void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    YXMessageThreeDetailViewController * VC = [[YXMessageThreeDetailViewController alloc]init];
    switch (tag) {
        case 1001:
            VC.title = @"点赞消息";
            VC.whereCome = 1;
            self.zanjb.hidden = YES;
            break;
        case 1002:
            VC.title = @"新增粉丝";
            VC.whereCome = 2;
            self.fensijb.hidden = YES;
            break;
        case 1003:
            VC.title = @"评论互动";
            VC.whereCome = 3;
            self.hdjb.hidden = YES;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)getNewMessageNumeber{
    kWeakSelf(self);
    [YX_MANAGER requestGETNewMessageNumber:@"" success:^(id object) {
        weakself.zanjb.text = kGetString(object[@"praise_number"]);
        weakself.fensijb.text = kGetString(object[@"fans_number"]);
        weakself.hdjb.text = kGetString(object[@"comment_number"]);
        
        weakself.zanjb.hidden = [weakself.zanjb.text isEqualToString:@"0"];
        weakself.fensijb.hidden = [weakself.fensijb.text isEqualToString:@"0"];
        weakself.hdjb.hidden = [weakself.hdjb.text isEqualToString:@"0"];
     
    }];
}




@end
