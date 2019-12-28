//
//  YXPingLunCellTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXPingLunCellTableViewCell.h"

@implementation YXPingLunCellTableViewCell
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic{
    CGFloat plLblHeight = [YXPingLunCellTableViewCell getPlDetailHeight:dic];
    return plLblHeight + 8;
}
+(CGFloat)getPlDetailHeight:(NSDictionary *)dic{
     NSString * text = [NSString stringWithFormat:@"%@: %@",dic[@"user_name"],dic[@"comment"]];
     CGFloat height =
     [ShareManager inAllContentOutHeight:text contentWidth:KScreenWidth-12-12-72-16 lineSpace:9 font:SYSTEMFONT(13)];
     return height;
}
-(void)setCellData:(NSDictionary *)dic{
    //如果aim_id 和外边的id相等，那么
    NSString * user_name = [NSString stringWithFormat:@"%@",dic[@"user_name"]];
    NSString * comment = [NSString stringWithFormat:@"%@",dic[@"comment"]];

    self.plLbl.text = [NSString stringWithFormat:@"%@: %@",user_name,comment];
    [ShareManager setAllContentAttributed:9 inLabel:self.plLbl font:SYSTEMFONT(13)];
    self.plHeight.constant = [YXPingLunCellTableViewCell getPlDetailHeight:dic];
    [ShareManager inAllTextOutDifColor:self.plLbl tag:user_name lineSpace:9 color:COLOR_333333 font:SYSTEMFONT(13)];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
