//
//  YXMineYiJianFanKuiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/8/29.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineYiJianFanKuiViewController.h"

@interface YXMineYiJianFanKuiViewController ()<QMUITextViewDelegate>
@property(nonatomic,strong) QMUITextView *textView;
@end

@implementation YXMineYiJianFanKuiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.textView = [[QMUITextView alloc] init];
    self.textView.frame = CGRectMake(0, 0, KScreenWidth, self.yijianView.frame.size.height);
    self.textView.delegate = self;
    self.textView.placeholder = @"请简要描述您的问题和意见，以便我们提供更好的帮助";
    self.textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(14),
                                       NSForegroundColorAttributeName: kRGBA(53, 60, 70, 1),
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
    // 限制可输入的字符长度
    self.textView.maximumTextLength = 100;
    
    // 限制输入框自增高的最大高度
    self.textView.maximumHeight = 200;
    
//    self.textView.layer.borderWidth = PixelOne;
//    self.textView.layer.borderColor = UIColorSeparator.CGColor;
//    self.textView.layer.cornerRadius = 4;
    [self.yijianView addSubview:self.textView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
