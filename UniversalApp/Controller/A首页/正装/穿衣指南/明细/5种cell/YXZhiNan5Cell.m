//
//  YXZhiNan5Cell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNan5Cell.h"

@implementation YXZhiNan5Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(CGFloat)jisuanCellHeight5:(NSDictionary *)dic{
    //内容
    CGFloat height_size = [ShareManager inTextZhiNanOutHeight:dic[@"detail"] lineSpace:0 fontSize:16];
    return height_size;
}
-(void)setCellData:(NSDictionary *)dic{
    self.titleLbl.text = dic[@"detail"];
    self.contentHeight5.constant = [ShareManager inTextZhiNanOutHeight:dic[@"detail"] lineSpace:0 fontSize:16];
    self.titleLbl.textAlignment = NSTextAlignmentJustified;

    
}
@end
