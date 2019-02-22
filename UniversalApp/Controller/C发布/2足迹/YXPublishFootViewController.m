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
- (IBAction)fabuAction:(id)sender {
    kWeakSelf(self);
    [QMUITips showLoadingInView:self.view];
    //先上传到七牛云图片  再提交服务器
    [QiniuLoad uploadImageToQNFilePath:self.photoImageList success:^(NSString *reslut) {
        NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        if (qiniuArray.count == 1){
            [dic setValue:qiniuArray[0] forKey:@"pic1"];
            [dic setValue:@"" forKey:@"pic2"];
            [dic setValue:@"" forKey:@"pic3"];
            
        }else if (qiniuArray.count == 2){
            [dic setValue:qiniuArray[0] forKey:@"pic1"];
            [dic setValue:qiniuArray[1] forKey:@"pic2"];
            [dic setValue:@"" forKey:@"pic3"];
            
        }else if (qiniuArray.count == 3){
            [dic setValue:qiniuArray[0] forKey:@"pic1"];
            [dic setValue:qiniuArray[1] forKey:@"pic2"];
            [dic setValue:qiniuArray[2] forKey:@"pic3"];
        }else if (self.qmuiTextView.text.length == 0){
            [QMUITips showError:@"请输入足迹描述!" inView:self.view hideAfterDelay:2];
            return;
        }else if (self.qmuiTextView.text.length >  100){
            [QMUITips showError:@"足迹描述长度不能超过100字符" inView:self.view hideAfterDelay:2];
            return;
        }
        
        [dic setValue:self.cigar_id forKey:@"cigar_id"];
        [dic setValue:[ShareManager getNowTimeMiaoShu] forKey:@"publish_time"];

        [dic setValue: [self.qmuiTextView.text utf8ToUnicode]  forKey:@"content"];
        [dic setValue:@(1) forKey:@"type"];//(1,"雪茄"),(2,"红酒"),(3,"高尔夫")
        [dic setValue:self.switchBtn.isOn ? @(1) : @(2) forKey:@"to_find"];
        NSString * tag  = self.tagArray.count == 0 ? @"" : [self.tagArray componentsJoinedByString:@" "];
        [dic setValue:tag forKey:@"tag"];//标签
        
        NSString * publish_site = [self.locationBtn.titleLabel.text isEqualToString:@"获取地理位置"] ? @"" : self.locationBtn.titleLabel.text;
        [dic setValue:publish_site forKey:@"publish_site"];
        
        //发布按钮
        [YX_MANAGER requestPost_track:dic success:^(id object) {
                [QMUITips hideAllTipsInView:weakself.view];
                [QMUITips showSucceed:object[@"message"] inView:weakself.view hideAfterDelay:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
        }];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
    
}

@end
