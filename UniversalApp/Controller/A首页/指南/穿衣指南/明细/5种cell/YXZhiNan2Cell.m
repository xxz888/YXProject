//
//  YXZhiNan2Cell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNan2Cell.h"

@implementation YXZhiNan2Cell
+(CGFloat)jisuanCellHeight:(NSDictionary *)dic{
    //内容
    CGFloat height_size = [ShareManager inTextZhiNanOutHeight:dic[@"detail"] lineSpace:9 fontSize:18];
    return height_size;
}
-(void)setCellData:(NSDictionary *)dic{
    self.contentLbl.text = dic[@"detail"];
}

@end
