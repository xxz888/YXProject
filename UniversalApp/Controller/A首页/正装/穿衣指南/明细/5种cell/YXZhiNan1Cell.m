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
    //内容
    CGFloat height_size = [ShareManager inTextZhiNanOutHeight:dic[@"detail"] lineSpace:9 fontSize:20];
    return height_size;
}
-(void)setCellData:(NSDictionary *)dic{
    self.titleLbl.text = dic[@"detail"];
    
    self.titleHeight.constant = [ShareManager inTextZhiNanOutHeight:dic[@"detail"] lineSpace:9 fontSize:20];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
