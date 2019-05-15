//
//  YXHomeQuestionFaBuViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeQuestionFaBuViewController.h"

@interface YXHomeQuestionFaBuViewController ()
@end

@implementation YXHomeQuestionFaBuViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布提问";
    self.switchBtn.hidden = self.fengcheView.hidden = self.faxianLbl.hidden = self.lineView3.hidden = YES;

}
#pragma mark ========== 发布 ==========
- (IBAction)fabuAction:(UIButton *)btn {
    [super fabuAction:btn];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self commonAction:self.photoImageList btn:btn];
}
-(void)commonAction:(NSMutableArray *)imgArray btn:(UIButton *)btn{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    if (imgArray.count == 0) {
        [dic setValue:@"" forKey:@"pic1"];
        [dic setValue:@"" forKey:@"pic2"];
        [dic setValue:@"" forKey:@"pic3"];
    }
    if (imgArray.count >= 1){
        [dic setValue:imgArray[0] forKey:@"pic1"];
        [dic setValue:@"" forKey:@"pic2"];
        [dic setValue:@"" forKey:@"pic3"];
    }
    if (imgArray.count >= 2){
        [dic setValue:imgArray[0] forKey:@"pic1"];
        [dic setValue:imgArray[1] forKey:@"pic2"];
        [dic setValue:@"" forKey:@"pic3"];
    }
    if (imgArray.count >= 3){
        [dic setValue:imgArray[0] forKey:@"pic1"];
        [dic setValue:imgArray[1] forKey:@"pic2"];
        [dic setValue:imgArray[2] forKey:@"pic3"];
    }
    if (self.titleTf.text.length == 0){
        [QMUITips showError:@"请输入标题!" inView:self.view hideAfterDelay:2];
        return;
    }else if (self.qmuiTextView.text.length == 0){
        [QMUITips showError:@"请输入要提问的问题!" inView:self.view hideAfterDelay:2];
        return;
    }
    /*
    else if (self.qmuiTextView.text.length >  100){
        [QMUITips showError:@"问题长度不能超过100字符" inView:self.view hideAfterDelay:2];
        return;
    }
     */
    [dic setValue: [self.qmuiTextView.text utf8ToUnicode]  forKey:@"question"];
    [dic setValue:[self.titleTf.text utf8ToUnicode] forKey:@"title"];//标题
    [dic setValue:@(1) forKey:@"type"];//(1,"雪茄"),(2,"红酒"),(3,"高尔夫")
    [dic setValue:self.switchBtn.isOn ? @(1) : @(0) forKey:@"to_find"];
    NSString * tag  = self.tagArray.count == 0 ? @"" : [self.tagArray componentsJoinedByString:@" "];
    [dic setValue:tag forKey:@"tag"];//标签
    NSString * publish_site = [self.locationBtn.titleLabel.text isEqualToString:@"获取地理位置"] ? @"" : self.locationBtn.titleLabel.text;
    [dic setValue:publish_site forKey:@"publish_site"];
    kWeakSelf(self);
    [QMUITips showLoadingInView:[ShareManager getMainView]];
    [YX_MANAGER requestFaBuQuestionPOST:dic success:^(id object) {
            [QMUITips showSucceed:object[@"message"] inView:self.view hideAfterDelay:2];
            [weakself closeViewAAA];
    }];
}

@end

