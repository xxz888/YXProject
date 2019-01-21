//
//  YXPublishImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishImageTableViewCell.h"
//#import <AMapLocationKit/AMapLocationKit.h>
@interface YXPublishImageTableViewCell (){
    QMUITextField *textField;
}
@end

@implementation YXPublishImageTableViewCell
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewRadius(self.xinhuatiBtn, 3);
    ViewRadius(self.moreBtn, 3);
    
    
    self.textView = [[ LTTextView alloc]initWithFrame:CGRectMake(10, 10, self.ttView.frame.size.width-20 , self.ttView.frame.size.height-20)];
    self.textView.placeholderTextView.text = @"说点什么....";
    self.textView.textView.text = @"四川海底捞餐饮股份有限公司成立于1994年，是一家以经营川味火锅为主、融汇各地火锅特色为一体的大型跨省直营餐饮品牌火锅店，全称是四川海底捞餐饮股份有限公司，创始人张勇。";
    
    [self.ttView addSubview:self.textView];
}

//新话题
- (IBAction)xinhuatiAction:(id)sender {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(50, 20, 30, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    
    textField = [[QMUITextField alloc] initWithFrame:CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, 36)];
    textField.placeholder = @"请输入新话题";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = UIFontMake(16);
    [contentView addSubview:textField];
    [textField becomeFirstResponder];
    
    UIButton *btn = [UIButton buttonWithType:0];
    ViewBorderRadius(btn, 4, 1, [UIColor darkGrayColor]);
    [btn setTitleColor:[UIColor darkGrayColor] forState:0];
    [btn setTitle:@"添加" forState:0];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20];
    paragraphStyle.paragraphSpacing = 20;
    [contentView addSubview:btn];
    
    btn.frame = CGRectMake(contentViewPadding.left, CGRectGetMaxY(textField.frame) + 20, contentLimitWidth/1.8, QMUIViewSelfSizingHeight);
    btn.centerX = textField.centerX;
    contentView.frame = CGRectSetHeight(contentView.frame, CGRectGetMaxY(btn.frame) + contentViewPadding.bottom);
    [btn addTarget:self action:@selector(addNewHuaTi:) forControlEvents:UIControlEventTouchUpInside];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}
-(void)addNewHuaTi:(UIButton *)btn{
    if (textField.text.length < 1) {
        [QMUITips showError:@"请输入新话题" inView:btn.superview hideAfterDelay:2];
        return;
    }
    self.block([textField.text concate:@"#"]);
    [btn.superview.superview removeFromSuperview];
}
//获取地理位置
- (IBAction)getLoactionAction:(id)sender {
    self.locationblock(self);
}
//更多
- (IBAction)moreAction:(id)sender {
    self.moreBlock();
}
@end
