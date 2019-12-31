//
//  YXZhiNan2Cell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNan2Cell.h"
#define cellSpace 9
@implementation YXZhiNan2Cell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLbl = [[YYLabel alloc]init];
    self.contentLbl.numberOfLines = 0;//多行
    [self.midContentView addSubview:self.contentLbl];
}
+(CGFloat)jisuanCellHeight:(NSDictionary *)dic{
    //内容
    CGFloat height_size = [ShareManager inAllContentOutHeight:dic[@"detail"] contentWidth:KScreenWidth - 30 lineSpace:cellSpace font:SYSTEMFONT(16)];
    return height_size;
}
-(void)commonTapAction:(NSRange)range :(NSMutableAttributedString *)attText :(NSArray *)linkArray{
    kWeakSelf(self);
    [attText setTextHighlightRange:range color:YXRGBAColor(10, 96, 254) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
             NSString * indexString = [[text string] substringWithRange:range];
             NSInteger index = 0;
             for (NSInteger i = 0; i < linkArray.count; i++) {
                 NSString * currentString = linkArray[i];
                 if ([currentString contains:indexString]) {
                     index = i;
                     break;
                 }
             }
             if (weakself.linkBlock) {
                 weakself.linkBlock(linkArray[index]);
             }
         }];
}
-(void)setCellData:(NSDictionary *)dic linkData:(NSArray *)linkArray{
    kWeakSelf(self);
    NSString * contentDetail = dic[@"detail"];
    //先截取数组
     NSMutableArray * indexArray = [[NSMutableArray alloc]init];
     for (NSString * linkStr in linkArray) {
        [indexArray addObject:[linkStr split:@","][0]];
     }
     NSMutableAttributedString * attText = [[NSMutableAttributedString alloc] initWithString:contentDetail];
     [attText addAttribute:NSFontAttributeName
                          value:SYSTEMFONT(16)
                          range:NSMakeRange(0, contentDetail.length - 1)];//设置字体
     [attText addAttribute:NSForegroundColorAttributeName
                          value:COLOR_444444
                          range:NSMakeRange(0, contentDetail.length - 1)];//设置字体
     attText.lineSpacing = cellSpace;//行间距
     for (NSString * haveString in indexArray) {
         //如果有。再看包含不包括这个要点击的字符串
         NSString * noSpaceString = [haveString stringByReplacingOccurrencesOfString:@" " withString:@""];
         if ([contentDetail contains:noSpaceString]) {
             NSArray * calculateArray = [NSArray arrayWithArray:[self calculateSubStringCount:contentDetail str:noSpaceString]];
             if (calculateArray.count > 1) {
                 for (NSNumber * repetitionString in calculateArray) {
                     NSRange range = NSMakeRange([repetitionString integerValue], noSpaceString.length);
                     [self commonTapAction:range :attText :linkArray];
                 }
             }else{
                 NSRange range = [contentDetail rangeOfString:noSpaceString];
                 [self commonTapAction:range :attText :linkArray];
             }
             
     
         }
     }
     CGFloat height_size = [YXZhiNan2Cell jisuanCellHeight:dic];
     self.contentHeight.constant = height_size;

     self.contentLbl.attributedText = attText;
     self.contentLbl.frame = CGRectMake(0, 0, KScreenWidth-30, height_size);

     
    
    
    
    
    
    
    
    
    
    
    
    
    //如果有link的数组
//    if (linkArray.count > 0) {
//        NSMutableArray * indexArray = [[NSMutableArray alloc]init];
//        for (NSString * linkStr in linkArray) {
//            [indexArray addObject:[linkStr split:@","][0]];
//        }
//        for (NSString * haveString in indexArray) {
//            //如果有。再看包含不包括这个要点击的字符串
//            if ([contentDetail contains:haveString]) {
//
//                NSMutableArray * modelArray = [NSMutableArray array];
//                for (NSString * string in indexArray) {
//                    //设置需要点击的字符串，并配置此字符串的样式及位置
//                    IXAttributeModel    * model = [IXAttributeModel new];
//                    model.range = [contentDetail rangeOfString:string];
//                    model.string = string;
//                    model.attributeDic = @{NSForegroundColorAttributeName:YXRGBAColor(10, 96, 254),
//                                           NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:16]};
//                    [modelArray addObject:model];
//                }
//                //文本点击回调
//                self.contentLbl.tapBlock = ^(NSString *string) {
//                    NSString * indexString = @"";
//                    for (NSString * linkStr in linkArray) {
//                        NSString * name = [linkStr split:@","][0];
//                        if ([name isEqualToString:string]) {
//                            indexString = [linkStr split:@","][2];
//                        }
//                    }
//                    if (weakself.linkBlock) {
//                        weakself.linkBlock(indexString);
//                    }
//                };
//                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:contentDetail];
//                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//                paragraphStyle.lineSpacing = cellSpace; // 设置行间距
//                [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
//                //label内容赋值
//                [self.contentLbl setText:contentDetail
//                             attributes:@{
//                                          NSForegroundColorAttributeName :COLOR_000000,
//                                          NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:16],
//                                          NSParagraphStyleAttributeName:paragraphStyle
//                                          }
//                         tapStringArray:modelArray];
//            }else{
//                //如果没有直接赋值
//                self.contentLbl.text = contentDetail;
//            }
//        }
//    }else{
//       //如果没有直接赋值
//       self.contentLbl.text = contentDetail;
//    }
//
//
//
//
//    [ShareManager setAllContentAttributed:cellSpace inLabel:self.contentLbl font:FONT(@"PingFangSC-Light",16)];
//    CGFloat height_size = [ShareManager inTextZhiNanOutHeight:contentDetail lineSpace:9 fontSize:16];
//    self.contentHeight.constant = height_size;
}
- (NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab {
    int location = 0;
    NSMutableArray *locationArr = [NSMutableArray new];
    NSRange range = [content rangeOfString:tab];
    if (range.location == NSNotFound){
        return locationArr;
    }
    //声明一个临时字符串,记录截取之后的字符串
    NSString * subStr = content;
    while (range.location != NSNotFound) {
        if (location == 0) {
            location += range.location;
        } else {
            location += range.location + tab.length;
        }
        //记录位置
        NSNumber *number = [NSNumber numberWithUnsignedInteger:location];
        [locationArr addObject:number];
        //每次记录之后,把找到的字串截取掉
        subStr = [subStr substringFromIndex:range.location + range.length];
        range = [subStr rangeOfString:tab];
    }

    return locationArr;
}
@end
