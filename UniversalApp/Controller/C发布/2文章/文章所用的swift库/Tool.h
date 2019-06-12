//
//  Tool.h
//  RichTextEditorDemo
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject
/**
 组装html字符串（图文信息）
 
 @param imageUrlArr 图片url数组
 @param desArr 描述数组
 @param contentStr 正文
 @return html字符
 */
+(NSString *)makeHtmlString:(NSMutableArray *)imageUrlArr desArr:(NSMutableArray *)desArr contentStr:(NSString *)contentStr;

@end
