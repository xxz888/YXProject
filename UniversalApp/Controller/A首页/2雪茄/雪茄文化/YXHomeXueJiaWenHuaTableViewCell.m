//
//  YXHomeXueJiaWenHuaTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaWenHuaTableViewCell.h"
//280+titleHeight
@implementation YXHomeXueJiaWenHuaTableViewCell
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    //内容
    CGFloat height_size = [ShareManager inTextOutHeight:dic[@"title"] lineSpace:9 fontSize:16];
    return 285 + height_size;
}

-(void)setCellData:(NSDictionary *)dic{
    NSString * str = [dic[@"picture"] replaceAll:@" " target:@"%20"];
    [self.wenhuaImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.wenhuaLbl.text = dic[@"title"];
    self.titleHeight.constant = [ShareManager inTextOutHeight:dic[@"title"] lineSpace:9 fontSize:16];
    
    self.talkNumLbl.text = kGetString(dic[@"comment_number"]);
    self.zanNumLbl.text = kGetString(dic[@"praise_number"]);

    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [self.zanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    
    if ([self.talkNumLbl.text isEqualToString:@"0"]) {
        self.talkNumLbl.text = @"";
    }
    
    if ([self.zanNumLbl.text isEqualToString:@"0"]) {
        self.zanNumLbl.text = @"";
    }
}


/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,3);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    
    //    _imageView.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用

    
//   theView.layer.masksToBounds = YES;
   theView.layer.cornerRadius = 5;

}

- (void)awakeFromNib {
    [super awakeFromNib];
 
    
    
    
    [self addShadowToView:self.outsideView withColor:KBlackColor];
    
    
    self.wenhuaImageView.layer.masksToBounds = YES;
    self.wenhuaImageView.layer.cornerRadius = 5;
}

- (IBAction)zanAction:(id)sender {
    self.zanblock(self);
}
@end
