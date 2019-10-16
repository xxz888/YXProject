//
//  NSString+CString.m
//  GTS
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

#import "NSString+CString.h"

@implementation NSString (CString)

//查找和替换
-(NSString *) replaceAll:(NSString *)search target:(NSString *)target
{
    NSString *str = [self stringByReplacingOccurrencesOfString:search withString:target];
    return str;
}

//对应位置插入
-(NSString *) insertAt:(NSString *)str post:(NSUInteger)post
{
    NSString *str1 = [self substringToIndex:post];
    NSString *str2 = [self substringFromIndex:post];
    return [[str1 stringByAppendingString:str]stringByAppendingString:str2];
}

-(NSUInteger) indexOf:(NSString *)str
{
    if (str == nil) {
        return NSNotFound;
    }
    
    if ([str isEqualToString:@""]) {
        return NSNotFound;
    }
    
    return [self rangeOfString:str].location;
}

//尾部位置追加
-(NSString *) append:(NSString *)str
{
    return [self stringByAppendingString:str];
}

//头部位置插入
-(NSString *) concate:(NSString *)str
{
    return [str stringByAppendingString:self];
}

//对应字符分割
-(NSArray *) split:(NSString *)split
{
    return [self componentsSeparatedByString:split];
}

//去除多余的空白字符
-(NSString *) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//去除多余的特定字符
-(NSString *) trim:(NSString *)trim
{
    NSString *str = self;
    str = [str trimLeft:trim];
    str = [str trimRight:trim];
    return str;
}

//去除左边多余的空白字符
-(NSString *) trimLeft
{
    return [self trimLeft:@" "];
}

//去除左边多余的特定字符
-(NSString *) trimLeft:(NSString *)trim
{
    NSString *str = self;
    while ([str hasPrefix:trim]) {
        str = [str substringFromIndex:[trim length]];
    }
    return str;
}

//去除右边多余的空白字符
-(NSString *) trimRight
{
    return [self trimRight:@" "];
}

//去除右边多余的特定字符
-(NSString *) trimRight:(NSString *)trim
{
    NSString *str = self;
    while ([str hasSuffix:trim])
    {
        str = [str substringToIndex:([str length] - [trim length])];
    }
    return str;
}

//取得字符串的左边特定字符数
-(NSString *) left:(NSUInteger)num
{
    //TODO:判断Index
    return [self substringToIndex:num];
}

//取得字符串的右边特定字符数
-(NSString *) right:(NSUInteger)num
{
    //TODO:判断Index
    return [self substringFromIndex:([self length] - num)];
}

//取得字符串的右边特定字符数
-(NSString *) left:(NSUInteger) left right:(NSUInteger) right
{
    return [[self left:left]right:right];
}

-(NSString *) right:(NSUInteger) right left:(NSUInteger) left
{
    return [[self right:right]left:left];
}

-(BOOL)containsEmoji{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

/**
 * 是否包含某个字符串
 */
- (BOOL)contains:(NSString *)text{
    //判断roadTitleLab.text 是否含有qingjoin
    if([self rangeOfString:text].location != NSNotFound)//_roaldSearchText
    {
        return YES;
    }else{
        return NO;
    }
}

/**
 * text 为nil 替换为当前字符
 * IIF(text == nil, self, text)
 */
- (NSString *)nilForReplace:(NSString *)text{
    if (text) {
        return text;
    }else{
        return self;
    }
}

+ (BOOL)isEmpty:(NSString *)text{
    if (!text) {
        return YES;
    }
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    if ([text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (BOOL)equalToString:(id)source{
    return source && [source isKindOfClass:[NSString class]] && [self isEqualToString:source];
}

- (BOOL)equalToDictionaryTag:(NSString *)tag source:(id)source{
    return source && [source isKindOfClass:[NSDictionary class]] && source[tag] && [self isEqualToString:source[tag]];
}

- (NSString *)emptyForReplace:(NSString *)text{
    if (!text) {
        return self;
    }
    if ([text isEqual:[NSNull null]]) {
        return self;
    }
    if ([text isEqualToString:@""]) {
        return self;
    }
    if ([text isEqualToString:@"<null>"]) {
        return self;
    }
    return text;
}

/**
 * 是否为空格
 */
+ (BOOL)isSpace:(NSString *)text{
    if (!text) {
        return YES;
    }
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    if ([text isEqualToString:@""]) {
        return YES;
    }
    NSString *strSpace = [text replaceAll:@" " target:@""];
    if ([strSpace isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString *)buildVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)version{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 * 如果为空格替换
 */
- (NSString *)spaceForReplace:(NSString *)text{
    if (!text) {
        return self;
    }
    if ([text isEqual:[NSNull null]]) {
        return self;
    }
    if ([text isEqualToString:@""]) {
        return self;
    }
    NSString *strSpace = [text replaceAll:@" " target:@""];
    if ([strSpace isEqualToString:@""]) {
        return self;
    }
    return text;
}

-(NSString *)decode:(NSString *)firstKey, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list params; //定义一个指向个数可变的参数列表指针；
    id next;
    if (firstKey) {
        va_start(params,firstKey);//va_start  得到第一个可变参数地址,
        id key = firstKey;
        //va_arg 指向下一个参数地址
        while(key && (next = va_arg(params,id)))
        {
            if (next && key){
                if ([self isEqualToString:key]) {
                    return next;
                }
            }
            key = va_arg(params,id);
        }
        return key;
        //置空
        va_end(params);
    }else{
        return firstKey;
    }
}

-(NSInteger)decodeInteger:(NSInteger)firstKey, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list params; //定义一个指向个数可变的参数列表指针；
    NSInteger next;
    if (firstKey) {
        va_start(params,firstKey);//va_start  得到第一个可变参数地址,
        NSInteger key = firstKey;
        //va_arg 指向下一个参数地址
        while(key && (next = va_arg(params,NSInteger)))
        {
            if (next && key){
                if (self.intValue == key) {
                    return next;
                }
            }
            key = va_arg(params,NSInteger);
        }
        return key;
        //置空
        va_end(params);
    }else{
        return firstKey;
    }
}

- (NSString *)localizedString{
    return NSLocalizedString(self, @"");
}
- (NSString *)utf8ToUnicode{
/*
    NSUInteger length = [self length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
//        unichar _char = [self characterAtIndex:i];
        // 判断是否为英文和数字
//        if (_char <= '9' && _char >='0'){
//            [s appendFormat:@"\\%x",[self characterAtIndex:i]];
//        }else if(_char >='a' && _char <= 'z'){
//            [s appendFormat:@"\\%x",[self characterAtIndex:i]];
//        }else if(_char >='A' && _char <= 'Z')
//        {
//            [s appendFormat:@"\\%x",[self characterAtIndex:i]];
//        }else{
            // 中文和字符
            [s appendFormat:@"\\u%x",[self characterAtIndex:i]];
            // 不足位数补0 否则解码不成功
            if(s.length == 4) {
                [s insertString:@"00" atIndex:2];
            } else if (s.length == 5) {
                [s insertString:@"0" atIndex:2];
            }
//        }
        [str appendFormat:@"%@", s];
    }
    return str;
    */
    return self;
}

-(NSString *)UnicodeToUtf8{
//    NSString *tempStr1=[self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
//    NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
//    NSString *tempStr3=[[@"\"" stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
//    NSData *tempData=[tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* returnStr =[NSPropertyListSerialization propertyListFromData:tempData
//                                                          mutabilityOption:NSPropertyListImmutable
//                                                                    format:NULL
//                                                          errorDescription:NULL];
//
//    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    return self;
}
-(NSString *)UnicodeToUtf81{
    NSString *tempStr1=[self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3=[[@"\"" stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData=[tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr =[NSPropertyListSerialization propertyListFromData:tempData
                                                          mutabilityOption:NSPropertyListImmutable
                                                                    format:NULL
                                                          errorDescription:NULL];

    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    return self;
}
@end
