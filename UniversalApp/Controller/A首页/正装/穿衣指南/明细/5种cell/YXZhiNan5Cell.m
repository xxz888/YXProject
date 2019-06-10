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
-(void)setCellData:(NSDictionary *)dic{
    self.titleLbl.text = dic[@"detail"];
}
@end
