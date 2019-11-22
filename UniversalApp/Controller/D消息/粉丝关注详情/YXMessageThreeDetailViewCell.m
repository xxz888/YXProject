//
//  YXMessageThreeDetailViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMessageThreeDetailViewCell.h"

@implementation YXMessageThreeDetailViewCell
+(CGFloat)jisuanGaoDu:(NSDictionary *)dic{
    CGFloat contentHeight = [ShareManager inAllContentOutHeight:dic[@"comment"] contentWidth:KScreenWidth-20 lineSpace:9 font:SYSTEMFONT(16)];
    return contentHeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImg.layer.masksToBounds = YES;
    self.titleImg.layer.cornerRadius = self.titleImg.frame.size.width / 2.0;
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.titleImg.tag = 1001;
    [self.titleImg addGestureRecognizer:tapGesturRecognizer1];
    
    ViewRadius(self.rightImv, 4);
    ViewBorderRadius(self.huifuBtn, 14, 1, kRGBA(238, 238, 238, 1));
    
    ViewRadius(self.guanZhuBtn, 14);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)tapAction:(id)sender{
    self.imgBlock(self);
}


- (IBAction)guanZhuAction:(id)sender {
    self.gzBlock(self);
}
- (IBAction)huifuAction:(id)sender {
    self.huifuaction(self.tag);
}
@end
