//
//  YXMineQianMingViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/2.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXMineQianMingViewController.h"

@interface YXMineQianMingViewController ()<QMUITextViewDelegate>
@property(nonatomic,strong) QMUITextView *textView;

@end

@implementation YXMineQianMingViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kRGBA(245, 245, 245, 1);
    self.textView = [[QMUITextView alloc] init];
    self.textView.frame = CGRectMake(0, 0, KScreenWidth, self.qianmingView.frame.size.height);
    self.textView.delegate = self;
    self.textView.placeholder = @"填写个人签名";
    self.textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(14),
                                       NSForegroundColorAttributeName: kRGBA(53, 60, 70, 1),
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
    // 限制可输入的字符长度
    self.textView.maximumTextLength = 25;
    // 限制输入框自增高的最大高度
    self.textView.maximumHeight = 200;
    [self.qianmingView addSubview:self.textView];
    

}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAction:(id)sender {
    self.qianmingblock(self.textView.text);
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.textCount.text = [NSString stringWithFormat:@"%ld",self.textView.text.length+1];
    return YES;
}
@end
