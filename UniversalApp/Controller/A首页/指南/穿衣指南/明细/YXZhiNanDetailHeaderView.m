//
//  YXZhiNanDetailHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanDetailHeaderView.h"

@implementation YXZhiNanDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setHeaderViewData:(NSDictionary *)dic{
    
    CGFloat headerHeight = [ShareManager inTextZhiNanOutHeight:dic[@"intro"] lineSpace:9 fontSize:16];
    self.frame = CGRectMake(0, 0, KScreenWidth, 230 + headerHeight);
    self.contentHeight.constant = headerHeight;
    self.contentLbl.text = dic[@"intro"];
    NSString * str = [(NSMutableString *)dic[@"photo_detail"] replaceAll:@" " target:@"%20"];
    [self.titleImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.collBtn.tag = [dic[@"id"] integerValue];
    if ([userManager loadUserInfo]) {
        self.is_collect = [dic[@"is_collect"] integerValue] == 1;
        UIImage * likeImage = self.is_collect ? ZAN_IMG : UNZAN_IMG;
        [self.collBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    }
    
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
        [weakself.collBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
        self.is_collect = !self.is_collect;
    }];
}
@end
