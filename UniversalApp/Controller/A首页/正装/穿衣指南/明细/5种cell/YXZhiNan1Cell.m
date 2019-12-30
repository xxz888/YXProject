//
//  YXZhiNan1Cell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNan1Cell.h"

@implementation YXZhiNan1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(CGFloat)jisuanCellHeight:(NSDictionary *)dic{
    CGFloat height_size = [ShareManager inAllContentOutHeight:dic[@"detail"] contentWidth:KScreenWidth - 30 lineSpace:9 font:BOLDSYSTEMFONT(20)];
    return height_size;
}
-(void)setCellData:(NSDictionary *)dic{
    NSString * contentDetail = dic[@"detail"];
    NSMutableAttributedString * attText = [[NSMutableAttributedString alloc] initWithString:contentDetail];
    [attText addAttribute:NSFontAttributeName
                         value:BOLDSYSTEMFONT(20)
                         range:NSMakeRange(0, contentDetail.length - 1)];//设置字体
    [attText addAttribute:NSForegroundColorAttributeName
                         value:kRGBA(176, 151, 99, 1)
                         range:NSMakeRange(0, contentDetail.length - 1)];//设置字体
    attText.lineSpacing = 0;//行间距
    self.titleHeight.constant = [YXZhiNan1Cell jisuanCellHeight:dic];
    self.titleLbl.attributedText = attText;
}
@end
