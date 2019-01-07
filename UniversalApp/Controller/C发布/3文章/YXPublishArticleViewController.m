//
//  YXPublishArticleViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishArticleViewController.h"
#import "LTTextView.h"

@implementation YXPublishArticleViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initMainView];
}
-(void)initMainView{
    LTTextView  *textView = [[ LTTextView alloc]initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    textView.placeholderTextView.text = @"编辑文章内容";
    [self.mainView addSubview:textView];
}
- (IBAction)coseViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
