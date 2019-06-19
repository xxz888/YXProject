//
//  Tool.m
//  RichTextEditorDemo
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import "Tool.h"

@implementation Tool
+(NSString *)makeHtmlString:(NSMutableArray *)imageUrlArr desArr:(NSMutableArray *)desArr contentStr:(NSString *)contentStr{
    NSString * htmlStr = @"";
    //组装图片标签
    NSMutableArray * imgTagArr = [NSMutableArray array];
    for (int i = 0; i < imageUrlArr.count; i ++) {
        NSString * urlStr = imageUrlArr[i];
        NSString * imgTag  = [NSString stringWithFormat:@"<img src='%@' style='max-width:100%%;border-radius:5px' /><br>",urlStr];
//        NSString * imgTag  = [@"<img>\n" stringByAppendingString:[[@"<url>" stringByAppendingString:urlStr] stringByAppendingString:@"</url>\n"]];
//        for (int j = 0; j < desArr.count; j ++) {
//            if (i == j) {
//                NSString * desStr = desArr[j];
//                imgTag = [[imgTag stringByAppendingString:[[@"<des>" stringByAppendingString:desStr] stringByAppendingString:@"</des>\n"]] stringByAppendingString:@"</img>\n"];
//            }
//        }
        [imgTagArr addObject:imgTag];
    }
    
    //组装文字标签 和图片标签
    NSArray * textArr = [contentStr componentsSeparatedByString:@"<我是图片>"];
    for (int i= 0; i < textArr.count; i ++) {
        NSString * pTag = [[@"<p>" stringByAppendingString:textArr[i]]stringByAppendingString:@"</p>\n"];
        htmlStr = [NSString stringWithFormat:@"%@%@",htmlStr,pTag];
        for (int j = 0; j < imgTagArr.count; j ++) {
            if (i == j) {
                htmlStr = [NSString stringWithFormat:@"%@%@",htmlStr,imgTagArr[j]];
            }
        }
    }
    
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<p>\n</p>" withString:@""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
    NSLog(@"这是转化后的html格式的图文内容----%@",htmlStr);
    return htmlStr;
}
@end
