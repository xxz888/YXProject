//
//  YXZhiNanDetailHeaderView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanDetailHeaderView.h"
#import "OrgHalfLineLabel.h"

@implementation YXZhiNanDetailHeaderView

- (void)drawRect:(CGRect)rect {
    ViewRadius(self.collVIew, 13);
    
    // 创建一个轻拍手势 同时绑定了一个事件
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    // 设置轻拍次数
    aTapGR.numberOfTapsRequired = 1;
    // 添加手势
    [self.contentLbl addGestureRecognizer:aTapGR];
}


-(void)tapGRAction:(UITapGestureRecognizer *)tap{
    if (YX_MANAGER.moreBool) {
        self.contentLbl.numberOfLines = 2;
        self.contentHeight.constant = 56;
        self.contentLbl.orgTruncationEndAttributedString = [self orgSetAttributedStringStyle:@" 更多"];
        YX_MANAGER.moreBool = NO;
        self.openBlock(@"收起");
    }else{
        self.contentLbl.numberOfLines = 0;
        CGFloat h = [ShareManager inTextZhiNanOutHeight:self.dic[@"intro"] lineSpace:9 fontSize:15];
        CGFloat th = h/4;
        
        self.contentHeight.constant = h + th;
        self.contentLbl.orgTruncationEndAttributedString = [self orgSetAttributedStringStyle:@" 收起"];
        YX_MANAGER.moreBool = YES;
        self.openBlock(@"更多");


    }
}




-(void)setHeaderViewData:(NSDictionary *)dic{
    self.dic = [NSDictionary dictionaryWithDictionary:dic];
    NSString * titleText =  [NSString stringWithFormat:@"%@",dic[@"intro"]];
        //设置需要点击的字符串，并配置此字符串的样式及位置
    self.contentLbl.text = titleText;
    NSString * str = [(NSMutableString *)dic[@"photo_detail"] replaceAll:@" " target:@"%20"];
    [self.titleImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.collBtn.tag = [dic[@"id"] integerValue];
    if ([userManager loadUserInfo]) {
        self.is_collect = [dic[@"is_collect"] integerValue] == 1;
        UIImage * likeImage = self.is_collect ? [UIImage imageNamed:@"收藏2"] : [UIImage imageNamed:@"收藏1"] ;
        [self.collBtn setImage:likeImage forState:UIControlStateNormal];
        UIColor * color1 = self.is_collect ? YXRGBAColor(251, 24, 39) : KWhiteColor;
        self.collVIew.backgroundColor = color1;
        UIColor * color2 = self.is_collect ? KWhiteColor : KDarkGaryColor;
        [self.collBtn setTitleColor:color2 forState:UIControlStateNormal];
    }
    
    CGFloat h = [ShareManager inTextZhiNanOutHeight:titleText lineSpace:9 fontSize:15];
    if (YX_MANAGER.moreBool) {
        self.contentHeight.constant =  h + h/4 ;//
        self.contentLbl.numberOfLines = 0;
        self.contentLbl.orgTruncationEndAttributedString = [self orgSetAttributedStringStyle:@" 收起"];
    }else{
        self.contentHeight.constant =  56;//
        self.contentLbl.numberOfLines = 2;
        self.contentLbl.orgTruncationEndAttributedString = [self orgSetAttributedStringStyle:@" 更多"];
    }
    [self.contentLbl setOrgVerticalTextAlignment:OrgHLVerticalTextAlignmentMiddle];
    self.contentLbl.orgLastLineRightIndent = 10.f;

}

    
- (IBAction)collAction:(UIButton *)sender{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    kWeakSelf(self);
    NSString * tagId = NSIntegerToNSString(sender.tag);
    [YXPLUS_MANAGER requestCollect_optionGet:[@"3/" append:tagId] success:^(id object) {
        UIImage * likeImage = weakself.is_collect ? [UIImage imageNamed:@"收藏1"] : [UIImage imageNamed:@"收藏2"] ;
        UIColor * color1 =    weakself.is_collect ? KWhiteColor : YXRGBAColor(251, 24, 39);
        UIColor * color2 =    weakself.is_collect ? KDarkGaryColor           : KWhiteColor;
        self.collVIew.backgroundColor = color1;
        [self.collBtn setTitleColor:color2 forState:UIControlStateNormal];
        [self.collBtn setImage:likeImage forState:UIControlStateNormal];
        self.is_collect = !self.is_collect;
    }];
}


- (NSMutableAttributedString *)orgSetAttributedStringStyle:(NSString *)string {
    if (!string) {
        return nil;
    }
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 9;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary * attributes = @{
                                  NSForegroundColorAttributeName : kRGBA(12, 36, 45, 1.0),
                                  NSFontAttributeName : [UIFont fontWithName:@"苹方-简" size:15],
                                 };
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    return attributedString;
}




@end
