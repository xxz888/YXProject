//
//  YXPublishImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishImageTableViewCell.h"

@implementation YXPublishImageTableViewCell
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
       
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    LTTextView  *textView = [[ LTTextView alloc]initWithFrame:CGRectMake(10, 10, self.ttView.frame.size.width-20 , self.ttView.frame.size.height-20)];
    textView.placeholderTextView.text = @"说点什么....";
    [self.ttView addSubview:textView];
}
@end
