//
//  YXPublishImageViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishImageViewController.h"
#import "YXFaBuBaseViewController.h"
#define photo1_BOOL photo1 && photo1.length > 5
#define photo2_BOOL photo2 && photo2.length > 5
#define photo3_BOOL photo3 && photo3.length > 5

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
    self.floatHeight_Tag.constant = -10;
    self.switchBtn.hidden = self.fengcheView.hidden = self.faxianLbl.hidden = self.lineView3.hidden = YES;
    
    if (self.caoGaoDic) {
        NSString * photo1 = self.caoGaoDic[@"photo1"];
        NSString * photo2 = self.caoGaoDic[@"photo2"];
        NSString * photo3 = self.caoGaoDic[@"photo3"];
    
        if ([self.caoGaoDic[@"describe"] length] > 0) {
            self.qmuiTextView.text = [self.caoGaoDic[@"describe"] UnicodeToUtf8];
        }
        UIImage *  zhanweiImage = [UIImage imageNamed:@"AddMedia"];

        if (photo1_BOOL) {
            if (photo2_BOOL) {
                if (photo3_BOOL) {
                    self.img1.hidden = self.img2.hidden = self.img3.hidden = self.del1.hidden = self.del2.hidden = self.del3.hidden = NO;
                    [self.img1 sd_setImageWithURL:[NSURL URLWithString:photo1] placeholderImage:[UIImage imageNamed:@""]];
                    [self.img2 sd_setImageWithURL:[NSURL URLWithString:photo2] placeholderImage:[UIImage imageNamed:@""]];
                    [self.img3 sd_setImageWithURL:[NSURL URLWithString:photo3] placeholderImage:[UIImage imageNamed:@""]];
                }else{
                    self.img1.hidden = self.img2.hidden = NO;
                    self.del1.hidden = self.del2.hidden = NO;
                    self.img3.hidden = NO;
                    [self.img1 sd_setImageWithURL:[NSURL URLWithString:photo1] placeholderImage:[UIImage imageNamed:@""]];
                    [self.img2 sd_setImageWithURL:[NSURL URLWithString:photo2] placeholderImage:[UIImage imageNamed:@""]];
                    self.img3.image = zhanweiImage;
                }
            }else{
                self.del1.hidden = NO;
                self.img1.hidden = self.img2.hidden = NO;
                [self.img1 sd_setImageWithURL:[NSURL URLWithString:photo1] placeholderImage:[UIImage imageNamed:@""]];
                self.img2.image = zhanweiImage;
                self.img3.hidden = YES;
            }
        }else{
            self.img1.image = zhanweiImage;
            self.img2.hidden = YES;
            self.img3.hidden = YES;
        }
    }
 
    
}
#pragma mark ========== 发布1 和 存草稿0  ==========
- (IBAction)fabuAction:(UIButton *)btn {
    [super fabuAction:btn];
    kWeakSelf(self);
    
    //先上传到七牛云图片  再提交服务器
    [QiniuLoad uploadImageToQNFilePath:self.photoImageList success:^(NSString *reslut) {
        NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        self.textViewInput = self.qmuiTextView.text;
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
        [dic setValue:[self.textViewInput utf8ToUnicode] forKey:@"describe"];//描述
        NSString * publish_site = [self.locationString isEqualToString:@"获取地理位置"] ? @"" : self.locationString;
        [dic setValue:publish_site forKey:@"publish_site"];//地点
        if (weakself.tagArray.count == 0) {
            [dic setValue:@"" forKey:@"tag"];//标签
        }else{
            NSString *string = [weakself.tagArray componentsJoinedByString:@" "];
            [dic setValue:string forKey:@"tag"];//标签
        }
        //这里区别寸草稿还是发布
        if (btn.tag == 301) {
            UserDefaultsSET(dic, YX_USER_FaBuCaoGao);
            [QMUITips hideAllTipsInView:[ShareManager getMainView]];
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
            [QMUITips hideAllTipsInView:[ShareManager getMainView]];
            [QMUITips showSucceed:@"发布成功" inView:weakself.view hideAfterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
    }];
}

@end
