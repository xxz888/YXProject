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
    ViewRadius(self.collVIew, 14);
//    self.contentHeight.constant = 75;
}

-(void)setHeaderViewData:(NSDictionary *)dic{
    self.dic = [NSDictionary dictionaryWithDictionary:dic];
    NSString * titleText = [NSString stringWithFormat:@"%@",dic[@"intro"]];
        //设置需要点击的字符串，并配置此字符串的样式及位置
    NSMutableArray * modelArray = [NSMutableArray array];
    IXAttributeModel    * model = [IXAttributeModel new];
    model.range = [titleText rangeOfString:@"更多"];
    model.string = @"更多";
    model.attributeDic = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    [modelArray addObject:model];
    
  
    self.contentLbl.text = titleText;
//    [self.contentLbl setText:titleText attributes:@{NSFontAttributeName:[UIFont fontWithName:@"苹方-简" size:15.f]}
//                  tapStringArray:modelArray];

    
    kWeakSelf(self);
    //文本点击回调
    self.contentLbl.tapBlock = ^(NSString *string) {
        return;
        if ([string isEqualToString:@"更多"]) {
            weakself.contentHeight.constant = [ShareManager inTextZhiNanOutHeight:titleText lineSpace:9 fontSize:15];
            weakself.openBlock();
        }
    };
    
    
    
      self.contentHeight.constant = [ShareManager inTextZhiNanOutHeight:titleText lineSpace:9 fontSize:15];
  
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
        UIImage * likeImage = weakself.is_collect ? [UIImage imageNamed:@"收藏1"] : [UIImage imageNamed:@"收藏2"] ;
        UIColor * color1 =    weakself.is_collect ? KWhiteColor : YXRGBAColor(251, 24, 39);
        UIColor * color2 =    weakself.is_collect ? KDarkGaryColor           : KWhiteColor;

        
        self.collVIew.backgroundColor = color1;
        [self.collBtn setTitleColor:color2 forState:UIControlStateNormal];
        [self.collBtn setImage:likeImage forState:UIControlStateNormal];
        self.is_collect = !self.is_collect;
    }];
}
@end
