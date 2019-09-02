//
//  YXMessageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMessageViewController.h"
#import "YXMessageThreeDetailViewController.h"
#import <UMAnalytics/MobClick.h>

@interface YXMessageViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic) BOOL isCanBack;
@end

@implementation YXMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我的消息";
    

    
    [self setUI];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getNewMessageNumeber];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
-(void)setUI{
    
    

    ViewBorderRadius(self.zanjb, 8, 1, KWhiteColor);
    ViewBorderRadius(self.fensijb, 8, 1, KWhiteColor);
    ViewBorderRadius(self.hdjb, 8, 1, KWhiteColor);
    
    
    
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
    [self addShadowToView:self.stackView withColor:kRGBA(102, 102, 102, 0.3)];
    ViewBorderRadius(self.tuisongBtn, 2, 1, kRGBA(10, 36, 51, 1));
    
    ViewBorderRadius(self.yiduBtn, 11, 1, kRGBA(238, 238, 238, 1));
    
    
    
//    UIImage    * btnImage = [UIImage imageNamed:@"messageqingchu.png"];// 11*6
//    CGFloat    imageWidth = 12;
//    CGFloat    space = 1;// 图片和文字的间距
//    CGFloat    titleWidth = [@"一键清除" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}].width;
//    [self.yiduBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0, (imageWidth+space*0.5))];
//    [self.yiduBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];

}
/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    
    //    _imageView.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    
    
    //   theView.layer.masksToBounds = YES;
    theView.layer.cornerRadius = 5;
    
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




- (IBAction)tuisongAction:(id)sender {
}
@end
