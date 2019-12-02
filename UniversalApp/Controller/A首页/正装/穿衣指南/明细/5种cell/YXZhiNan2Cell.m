//
//  YXZhiNan2Cell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNan2Cell.h"
#import "IXAttributeTapLabel.h"
@implementation YXZhiNan2Cell

+(CGFloat)jisuanCellHeight:(NSDictionary *)dic{
    //内容
    CGFloat height_size = [ShareManager inTextZhiNanOutHeight:dic[@"detail"] lineSpace:0 fontSize:16];
    return height_size;
}
-(void)setCellData:(NSDictionary *)dic linkData:(NSArray *)linkArray{
    kWeakSelf(self);
    CGFloat height_size = [ShareManager inTextZhiNanOutHeight:dic[@"detail"] lineSpace:0 fontSize:16];
    if ([CGFloatToNSString(height_size) integerValue] == 22) {
        height_size = height_size * 2;
    }
    self.contentHeight.constant = height_size;
    
    
    NSMutableArray * indexArray = [[NSMutableArray alloc]init];
    for (NSString * linkStr in linkArray) {
        [indexArray addObject:[linkStr split:@","][0]];
    }
    NSMutableArray * modelArray = [NSMutableArray array];
    for (NSString * string in indexArray) {
        //设置需要点击的字符串，并配置此字符串的样式及位置
        IXAttributeModel    * model = [IXAttributeModel new];
        model.range = [dic[@"detail"] rangeOfString:string];
        model.string = string;
        model.attributeDic = @{NSForegroundColorAttributeName : YXRGBAColor(10, 96, 254),
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:16]};
        [modelArray addObject:model];
    }
    //文本点击回调
    self.contentLbl.tapBlock = ^(NSString *string) {
        NSString * indexString = @"";
        for (NSString * linkStr in linkArray) {
            NSString * name = [linkStr split:@","][0];
            if ([name isEqualToString:string]) {
                indexString = [linkStr split:@","][2];
            }
        }
        weakself.linkBlock(indexString);
    };
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:dic[@"detail"]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0; // 设置行间距
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    
    //label内容赋值
    [self.contentLbl setText:dic[@"detail"]
                 attributes:@{NSForegroundColorAttributeName :COLOR_000000,
                              NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:16],
                              NSParagraphStyleAttributeName:paragraphStyle
                              }
             tapStringArray:modelArray];
    
    self.contentLbl.textAlignment = NSTextAlignmentJustified;
//    [self conversionCharacterInterval:20 current:dic[@"detail"] withLabel:self.contentLbl];
    
}

@end
