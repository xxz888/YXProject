//
//  YXWenZhangView.m
//  RichTextEditorDemo
//
//  Created by 小小醉 on 2019/6/5.
//  Copyright © 2019 Junior. All rights reserved.
//

#import "YXWenZhangView.h"

@implementation YXWenZhangView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}
-(void)awakeFromNib{
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    //点击几次后触发事件响应，默认为：1
    click.numberOfTapsRequired = 1;
    [self.titleImgV addGestureRecognizer:click];
}

    
    
-(void)clickAction:(id)sender{
    self.clickTitleImgBlock(self.titleImgV);
}
@end
