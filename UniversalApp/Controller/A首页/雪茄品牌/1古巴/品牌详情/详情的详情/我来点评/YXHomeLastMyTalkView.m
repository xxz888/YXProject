//
//  YXHomeLastMyTalkView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/10.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeLastMyTalkView.h"
#import "QMUITextView.h"
#import "XHStarRateView.h"
@interface YXHomeLastMyTalkView () <XHStarRateViewDelegate>

@end
@implementation YXHomeLastMyTalkView


- (void)drawRect:(CGRect)rect {

    [self fiveStarView:0 view:self.waiguanView];
    [self fiveStarView:0 view:self.ranshaoView];
    [self fiveStarView:0 view:self.xiangweiView];
    [self fiveStarView:0 view:self.kouganView];
    
    self.qmuiTextView = [[QMUITextView alloc] init];
    self.qmuiTextView.frame = CGRectMake(0, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    self.qmuiTextView.backgroundColor = YXRGBAColor(239, 239, 239);
    self.qmuiTextView.font = UIFontMake(13);
    self.qmuiTextView.placeholder = @"发表你的评论";
//    self.qmuiTextView.textContainerInset = UIEdgeInsetsMake(16, 12, 16, 12);
    self.qmuiTextView.layer.cornerRadius = 8;
    self.qmuiTextView.clipsToBounds = YES;
    [self.qmuiTextView becomeFirstResponder];
    [self.bottomView addSubview:self.qmuiTextView];
    
    self.recommend = @"1";
}
-(void)fiveStarView:(CGFloat)score view:(UIView *)view{
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = WholeStar;
    starRateView.tag = 1;
    starRateView.currentScore = 5;
    starRateView.delegate =self;
    [view addSubview:starRateView];
    
    /*
    [self.parDic setValue:@(5) forKey:@"out_looking"];
    [self.parDic setValue:@(5) forKey:@"burn"];
    [self.parDic setValue:@(5) forKey:@"fragrance"];
    [self.parDic setValue:@(5) forKey:@"mouthfeel"];
     */

}
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    NSLog(@"%ld----  %f",starRateView.tag,currentScore);
    if (starRateView.tag == 1) {
        [self.parDic setValue:@((int)currentScore) forKey:@"out_looking"];
    }else if (starRateView.tag == 2){
        [self.parDic setValue:@((int)currentScore) forKey:@"burn"];
    }else if (starRateView.tag == 3){
        [self.parDic setValue:@((int)currentScore) forKey:@"fragrance"];
    }else if (starRateView.tag == 4){
        [self.parDic setValue:@((int)currentScore) forKey:@"mouthfeel"];
    }
}

- (IBAction)fabiaoAction:(id)sender {
    kWeakSelf(self);
    /*
    if (self.parDic[@"out_looking"] && [self.parDic[@"out_looking"] integerValue] < 0) {
        [QMUITips showError:@"外观分数不能为0" inView:self hideAfterDelay:2];
        return;
    }else  if (self.parDic[@"out_looking"] && [self.parDic[@"burn"] integerValue] < 0) {
        [QMUITips showError:@"燃烧分数不能为0" inView:self hideAfterDelay:2];
        return;
    }else  if (self.parDic[@"out_looking"] && [self.parDic[@"fragrance"] integerValue] < 0) {
        [QMUITips showError:@"香味分数不能为0" inView:self hideAfterDelay:2];
        return;
    }else  if (self.parDic[@"out_looking"] && [self.parDic[@"mouthfeel"] integerValue] < 0) {
        [QMUITips showError:@"口感分数不能为0" inView:self hideAfterDelay:2];
        return;
    }
  
    int average_score = ([self.parDic[@"out_looking"] intValue] +
                         [self.parDic[@"burn"] intValue] +
                         [self.parDic[@"fragrance"] intValue] +
                         [self.parDic[@"mouthfeel"] intValue]) / 4;
   
    [self.parDic setValue:@(average_score) forKey:@"average_score"];
    */
    [self.parDic setValue:[self.qmuiTextView.text utf8ToUnicode] forKey:@"comment"];
    [self.parDic setValue:self.recommend forKey:@"recommend"];
    if (self.PeiJianOrPinPai) {
        [YX_MANAGER requestCigar_accessories_commentPOST:self.parDic success:^(id object) {
            [QMUITips showSucceed:@"评论成功" inView:self hideAfterDelay:2];
            weakself.block();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.superview removeFromSuperview];
            });
        }];
    }else{
        [YX_MANAGER requestCigar_commentPOST:self.parDic success:^(id object) {
            [QMUITips showSucceed:@"评论成功" inView:self hideAfterDelay:2];
            weakself.block();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.superview removeFromSuperview];
            });
        }];
    }
  
    
}
//cigar_id    int        雪茄id
//average_score    float        平均分
//out_looking    int        外观
//burn    int        燃烧
//fragrance    int        香味
//mouthfeel    int        口感
//comment    char(500)        评论

- (IBAction)btnAction:(UIButton *)btn{
    self.recommend =  NSIntegerToNSString(btn.tag-1000);
    UIImage * image1 = [UIImage imageNamed:@"点评单选"];
    UIImage * image2 = [UIImage imageNamed:@"单选未选中"];

    if (btn.tag == 1001) {
        
        [self.btn1 setImage:image1 forState:UIControlStateNormal];
        [self.btn2 setImage:image2 forState:UIControlStateNormal];
        [self.btn3 setImage:image2 forState:UIControlStateNormal];

    }else  if (btn.tag == 1002) {
        
        [self.btn1 setImage:image2 forState:UIControlStateNormal];
        [self.btn2 setImage:image1 forState:UIControlStateNormal];
        [self.btn3 setImage:image2 forState:UIControlStateNormal];
        
    }else  if (btn.tag == 1003) {
        
        [self.btn1 setImage:image2 forState:UIControlStateNormal];
        [self.btn2 setImage:image2 forState:UIControlStateNormal];
        [self.btn3 setImage:image1 forState:UIControlStateNormal];
    }
}
@end
