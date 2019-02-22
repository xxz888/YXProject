//
//  YXPublishImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishImageViewController.h"
#import "YXFaBuBaseViewController.h"

@interface YXPublishImageViewController ()

@property(nonatomic,strong)NSMutableDictionary * caoGaoDic;

@end

@implementation YXPublishImageViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
     self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.caoGaoDic = [[NSMutableDictionary alloc]init];
    self.caoGaoDic = UserDefaultsGET(YX_USER_FaBuCaoGao);
    self.titleTfHeight.constant = 0;
    self.view3Height.constant = 0;
    self.switchBtn.hidden = self.fengcheView.hidden = self.faxianLbl.hidden = YES;
}
#pragma mark ========== 发布1 和 存草稿0  ==========
- (IBAction)fabuAction:(UIButton *)btn {
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
            [dic setValue:qiniuArray[0] forKey:@"photo1"];
            [dic setValue:@"" forKey:@"photo2"];
            [dic setValue:@"" forKey:@"photo3"];

        }else if (qiniuArray.count == 2){
            [dic setValue:qiniuArray[0] forKey:@"photo1"];
            [dic setValue:qiniuArray[1] forKey:@"photo2"];
            [dic setValue:@"" forKey:@"photo3"];

        }else if (qiniuArray.count == 3){
            [dic setValue:qiniuArray[0] forKey:@"photo1"];
            [dic setValue:qiniuArray[1] forKey:@"photo2"];
            [dic setValue:qiniuArray[2] forKey:@"photo3"];
        }else if (self.textViewInput.length == 0){
            [QMUITips showError:@"请输入描述!" inView:self.view hideAfterDelay:2];
            return;
        }else if (self.textViewInput.length >  100){
            [QMUITips showError:@"描述长度不能超过100字符" inView:self.view hideAfterDelay:2];
            return;
        }
        self.textViewInput = self.qmuiTextView.text;
        [dic setValue:[self.textViewInput utf8ToUnicode] forKey:@"describe"];//描述
        NSString * publish_site = [self.locationString isEqualToString:@"获取地理位置"] ? @"" : self.locationString;
        [dic setValue:publish_site forKey:@"publish_site"];//地点
        if (weakself.tagArray.count == 0) {
            [dic setValue:@"" forKey:@"tag"];//标签
        }else{
            NSString *string = [weakself.tagArray componentsJoinedByString:@" "];
            [dic setValue:string forKey:@"tag"];//标签
        }
        if (btn.tag == 0) {
            UserDefaultsSET(dic, YX_USER_FaBuCaoGao);
            [QMUITips showSucceed:@"存草稿成功" inView:weakself.view hideAfterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [weakself requestFabu:dic];
        }
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}
-(void)requestFabu:(NSMutableDictionary *)dic{
    kWeakSelf(self);
    //发布按钮
    [YX_MANAGER requestFaBuImagePOST:dic success:^(id object) {
            [QMUITips hideAllTipsInView:weakself.view];
            [QMUITips showSucceed:@"发布成功" inView:weakself.view hideAfterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
    }];
}

@end
