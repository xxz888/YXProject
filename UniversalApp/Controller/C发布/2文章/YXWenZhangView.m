//
//  YXWenZhangView.m
//  RichTextEditorDemo
//
//  Created by 小小醉 on 2019/6/5.
//  Copyright © 2019 Junior. All rights reserved.
//

#import "YXWenZhangView.h"
@interface YXWenZhangView ()<UITextViewDelegate>
    
@end
@implementation YXWenZhangView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.titleTextView setFont:[UIFont fontWithName:@"Helvetica Neue" size:18]];
    self.titleTextView.textColor = [UIColor grayColor];

    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    //点击几次后触发事件响应，默认为：1
    click.numberOfTapsRequired = 1;
    [self.titleImgV addGestureRecognizer:click];
    self.titleTextView.delegate = self;
    self.titleTextView.text = @"请输入标题";
    [self contentSizeToFit];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1){
        textView.text = @"请输入标题";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请输入标题"]){
        textView.text=@"";
        textView.textColor = [UIColor blackColor];
    }
}
- (void)contentSizeToFit{
        //先判断一下有没有文字（没文字就没必要设置居中了）
        if([self.titleTextView.text length]>0)
        {
            //textView的contentSize属性
            CGSize contentSize = self.titleTextView.contentSize;
            //textView的内边距属性
            UIEdgeInsets offset;
            CGSize newSize = contentSize;
            
            //如果文字内容高度没有超过textView的高度
            if(contentSize.height <= self.titleTextView.frame.size.height)
            {
                //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
                CGFloat offsetY = (self.titleTextView.frame.size.height - contentSize.height)/2;
                offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
            }
            else          //如果文字高度超出textView的高度
            {
                newSize = self.titleTextView.frame.size;
                offset = UIEdgeInsetsZero;
                CGFloat fontSize = 18;
                
                //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
                while (contentSize.height > self.titleTextView.frame.size.height)
                {
                    [self.titleTextView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                    contentSize = self.titleTextView.contentSize;
                }
                newSize = contentSize;
            }
            self.titleTextView.textColor = [UIColor grayColor];

            //根据前面计算设置textView的ContentSize和Y方向偏移量
            [self.titleTextView setContentSize:newSize];
            [self.titleTextView setContentInset:offset];
            
        }
    }
    
-(void)clickAction:(id)sender{
    self.clickTitleImgBlock(self.titleImgV);
}
@end
