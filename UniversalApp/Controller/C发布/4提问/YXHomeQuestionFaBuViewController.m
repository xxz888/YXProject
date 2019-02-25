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
}
#pragma mark ========== 发布 ==========
- (IBAction)fabuAction:(id)sender {
    [super fabuAction:sender];

    kWeakSelf(self);
    [QMUITips showLoadingInView:self.view];
    //先上传到七牛云图片  再提交服务器
    [QiniuLoad uploadImageToQNFilePath:self.photoImageList success:^(NSString *reslut) {
        NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        if (qiniuArray.count == 0) {
            [QMUITips showError:@"请上传图片" inView:self.view hideAfterDelay:2];
            return;
        }else if (qiniuArray.count == 1){
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
        }else if (self.titleTf.text.length == 0){
            [QMUITips showError:@"请输入标题!" inView:self.view hideAfterDelay:2];
            return;
        }else if (self.qmuiTextView.text.length == 0){
            [QMUITips showError:@"请输入要提问的问题!" inView:self.view hideAfterDelay:2];
            return;
        }else if (self.qmuiTextView.text.length >  100){
            [QMUITips showError:@"问题长度不能超过100字符" inView:self.view hideAfterDelay:2];
            return;
        }
        [dic setValue: [self.qmuiTextView.text utf8ToUnicode]  forKey:@"question"];
        [dic setValue:[self.titleTf.text utf8ToUnicode] forKey:@"title"];//标题
        [dic setValue:@(1) forKey:@"type"];//(1,"雪茄"),(2,"红酒"),(3,"高尔夫")
        [dic setValue:self.switchBtn.isOn ? @(1) : @(2) forKey:@"to_find"];
        
        NSString * tag  = self.tagArray.count == 0 ? @"" : [self.tagArray componentsJoinedByString:@" "];
        [dic setValue:tag forKey:@"tag"];//标签

        NSString * publish_site = [self.locationBtn.titleLabel.text isEqualToString:@"获取地理位置"] ? @"" : self.locationBtn.titleLabel.text;
        [dic setValue:publish_site forKey:@"publish_site"];

        //发布按钮
        [YX_MANAGER requestFaBuQuestionPOST:dic success:^(id object) {
                [QMUITips hideAllTipsInView:weakself.view];
                [QMUITips showSucceed:@"发布成功" inView:weakself.view hideAfterDelay:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                });

        }];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
    
}


@end

