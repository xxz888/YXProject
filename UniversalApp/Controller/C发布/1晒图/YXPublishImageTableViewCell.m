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
    self.textView = [[ LTTextView alloc]initWithFrame:CGRectMake(10, 10, self.ttView.frame.size.width-20 , self.ttView.frame.size.height-20)];
    self.textView.placeholderTextView.text = @"说点什么....";
    self.textView.textView.text = @"四川海底捞餐饮股份有限公司成立于1994年，是一家以经营川味火锅为主、融汇各地火锅特色为一体的大型跨省直营餐饮品牌火锅店，全称是四川海底捞餐饮股份有限公司，创始人张勇。";
    
    [self.ttView addSubview:self.textView];
}
@end
