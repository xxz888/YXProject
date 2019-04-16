//
//  YXPublishFootViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishFootViewController.h"
@interface YXPublishFootViewController ()
@end

@implementation YXPublishFootViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布足迹";
    self.titleTfHeight.constant = 0;
    self.caogaoHeight.constant = 0;
}

#pragma mark ========== 发布 ==========
- (IBAction)fabuAction:(UIButton *)btn {
    [super fabuAction:btn];
    [QMUITips showLoadingInView:self.view];
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
    if (self.qmuiTextView.text.length == 0){
        [QMUITips hideAllTipsInView:self.view];
        [QMUITips showError:@"请输入足迹描述!" inView:self.view hideAfterDelay:2];
        return;
    }else if (self.qmuiTextView.text.length >  100){
        [QMUITips showError:@"足迹描述长度不能超过100字符" inView:self.view hideAfterDelay:2];
        [QMUITips hideAllTipsInView:self.view];
        return;
    }
    kWeakSelf(self);
    [dic setValue:self.cigar_id forKey:@"cigar_id"];
    [dic setValue:[ShareManager getNowTimeMiaoShu] forKey:@"publish_time"];
    
    [dic setValue: [self.qmuiTextView.text utf8ToUnicode]  forKey:@"content"];
    [dic setValue:@(1) forKey:@"type"];//(1,"雪茄"),(2,"红酒"),(3,"高尔夫")
    [dic setValue:self.switchBtn.isOn ? @(1) : @(0) forKey:@"to_find"];
    NSString * tag  = self.tagArray.count == 0 ? @"" : [self.tagArray componentsJoinedByString:@" "];
    [dic setValue:tag forKey:@"tag"];//标签
    
    NSString * publish_site = [self.locationBtn.titleLabel.text isEqualToString:@"获取地理位置"] ? @"" : self.locationBtn.titleLabel.text;
    [dic setValue:publish_site forKey:@"publish_site"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(imgArray.count+1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //发布按钮
        [YX_MANAGER requestPost_track:dic success:^(id object) {
            [QMUITips hideAllTipsInView:weakself.view];

            if (weakself.switchBtn.isOn) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"returnFind" object:nil];
                [weakself.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
                }];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"returnHome" object:nil];
                [weakself.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
                }];
            }
            
        
        }];
    });
}

- (IBAction)closeViewAction:(id)sender{
    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
