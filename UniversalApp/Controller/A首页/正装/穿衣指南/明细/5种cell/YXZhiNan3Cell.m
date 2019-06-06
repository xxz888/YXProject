//
//  YXZhiNan3Cell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNan3Cell.h"

@implementation YXZhiNan3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.photoImgView, 5);
}
-(void)setCellData:(NSDictionary *)dic{
    NSString * str = [(NSMutableString *)dic[@"detail"] replaceAll:@" " target:@"%20"];
    [self.photoImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
}
@end
