//
//  YXZhiNanDetailHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanDetailHeaderView.h"

@implementation YXZhiNanDetailHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    ViewRadius(self.collVIew, 10);
}

-(void)setHeaderViewData:(NSDictionary *)dic{
    self.dic = [NSDictionary dictionaryWithDictionary:dic];
    CGFloat headerHeight = [ShareManager inTextZhiNanOutHeight:dic[@"intro"] lineSpace:9 fontSize:15];
    
    
    NSString * titleText = [NSString stringWithFormat:@"%@更多",dic[@"intro"]];
    self.contentLbl.text = dic[@"intro"];
    NSString * str = [(NSMutableString *)dic[@"photo_detail"] replaceAll:@" " target:@"%20"];
    [self.titleImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.collBtn.tag = [dic[@"id"] integerValue];
    if ([userManager loadUserInfo]) {
        self.is_collect = [dic[@"is_collect"] integerValue] == 1;
        UIImage * likeImage = self.is_collect ? ZAN_IMG : UNZAN_IMG;
        [self.collBtn setImage:likeImage forState:UIControlStateNormal];
    }
}
-(void)setMoreColor{
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:self.contentLbl.text];
    [string addAttribute:NSForegroundColorAttributeName value:YXRGBAColor(10, 96, 254) range:NSMakeRange(self.contentLbl.text.length-2,2)];
    self.contentLbl.attributedText = string;
}
- (IBAction)backVCAction:(UIButton *)sender {
    self.backVCBlock();
}
    
- (IBAction)collAction:(UIButton *)sender{
    
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    kWeakSelf(self);
    NSString * tagId = NSIntegerToNSString(sender.tag);
    [YXPLUS_MANAGER requestCollect_optionGet:[@"3/" append:tagId] success:^(id object) {
        //赞
        UIImage * likeImage = !weakself.is_collect ? ZAN_IMG : UNZAN_IMG;
        [self.collBtn setImage:likeImage forState:UIControlStateNormal];
        self.is_collect = !self.is_collect;
    }];
}
- (IBAction)openAction:(UIButton *)btn{
    self.openBlock(btn);
    CGFloat headerHeight = [ShareManager inTextZhiNanOutHeight:self.dic[@"intro"] lineSpace:9 fontSize:15];
    if ([btn.titleLabel.text isEqualToString:@"↓ 展开"]) {
        self.contentHeight.constant = headerHeight;
        [btn setTitle:@"↑ 收起" forState:UIControlStateNormal];
    }else{
        self.contentHeight.constant = 100;
        [btn setTitle:@"↓ 展开" forState:UIControlStateNormal];
    }

}
@end
