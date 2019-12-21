//
//  YXDingZhiDetailTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiDetailTableViewCell.h"
#define cellSpace 9

@implementation YXDingZhiDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [ShareManager fiveStarView:5 view:self.starView];
    
    
}
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    CGFloat detailHeight = [YXDingZhiDetailTableViewCell jisuanContentHeight:dic];
    CGFloat imgHeight = [YXDingZhiDetailTableViewCell jisuanImageHeight:dic];
    CGFloat imgToTopHeight = imgHeight == 0 ? 0 : 16;
    CGFloat gudingHeight = 15 + 36 + 10 + detailHeight + imgToTopHeight + imgHeight + 13 +  15 + 14 ;
    return  gudingHeight;
}
//计算文字高度
+(CGFloat)jisuanContentHeight:(NSDictionary *)dic{
    NSString * contentText =  @"与祖国同行，看濠江盛景。即将迎来回归祖国20周年纪念日的澳门，一路欢歌，生机勃发。澳门回归祖国20年来，开创了历史上最好的发展局面。事实充分证明，“一国两制”是完全行得通、办得到、得人心的";
    return [ShareManager inAllContentOutHeight:contentText contentWidth:KScreenWidth-34 lineSpace:cellSpace font:SYSTEMFONT(14)];
}
//计算图片高度
+(CGFloat)jisuanImageHeight:(NSDictionary *)dic{
    return 0;//[dic[@"photoList"] count] == 0 ? 0 : 95;
}
-(void)setCellData:(NSDictionary *)dic{
    self.cellContent.text = @"与祖国同行，看濠江盛景。即将迎来回归祖国20周年纪念日的澳门，一路欢歌，生机勃发。澳门回归祖国20年来，开创了历史上最好的发展局面。事实充分证明，“一国两制”是完全行得通、办得到、得人心的";
    [ShareManager setAllContentAttributed:cellSpace inLabel:self.cellContent font:SYSTEMFONT(14)];
    self.contentDetailHeight.constant = [YXDingZhiDetailTableViewCell jisuanContentHeight:dic];
    //如果图片数组为0，那么图片view的高度和top高度都为0
//    if ([dic[@"photoList"] count] == 0) {
//        self.cellMiddleViewToTopHeight.constant = self.cellMiddleViewHeight.constant = 0;
//    }
    self.cellMiddleViewToTopHeight.constant = self.cellMiddleViewHeight.constant = 0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)zanAction:(id)sender {
    
}
- (IBAction)talkAction:(id)sender {
    
}
@end
