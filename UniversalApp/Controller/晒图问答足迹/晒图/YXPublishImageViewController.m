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
#import "JQFMDB.h"

@interface YXPublishImageViewController ()


@end

@implementation YXPublishImageViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
     self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleTfHeight.constant = 0;
    self.view3Height.constant = 0;
    self.floatHeight_Tag.constant = -10;
    self.switchBtn.hidden = self.fengcheView.hidden = self.faxianLbl.hidden = self.lineView3.hidden = YES;
    JQFMDB *db = [JQFMDB shareDatabase];
    if (![db jq_isExistTable:YX_USER_FaBuCaoGao]) {
        [db jq_createTable:YX_USER_FaBuCaoGao dicOrModel:[YXShaiTuModel class]];
    }

    //如果是从草稿进来，并且有值
    if (_model) {
        NSString * photo1 = _model.photo1;
        NSString * photo2 = _model.photo2;
        NSString * photo3 = _model.photo3;
    
        if ([_model.describe length] > 0) {
            self.qmuiTextView.text = [_model.describe UnicodeToUtf8];
            if ([photo1 length] > 5) {
                self.img1.hidden = NO;
                [self.img1 sd_setImageWithURL:[NSURL URLWithString:photo1] placeholderImage:[UIImage imageNamed:@""]];
            }
            if ([photo2 length] > 5) {
                self.img2.hidden = NO;
                [self.img2 sd_setImageWithURL:[NSURL URLWithString:photo2] placeholderImage:[UIImage imageNamed:@""]];
            }
            if ([photo3 length] > 5) {
                self.img3.hidden = NO;
                [self.img3 sd_setImageWithURL:[NSURL URLWithString:photo3] placeholderImage:[UIImage imageNamed:@""]];
            }
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
    [QMUITips showLoadingInView:self.view];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self commonAction:self.photoImageList btn:btn];


//    kWeakSelf(self);
//    if (self.photoImageList.count == 0) {
//    }else{
//        //先上传到七牛云图片  再提交服务器
//        [QiniuLoad uploadImageToQNFilePath:self.photoImageList success:^(NSString *reslut) {
//            NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
//            [weakself commonAction:qiniuArray btn:btn];
//        } failure:^(NSString *error) {
//            NSLog(@"%@",error);
//        }];
//    }
 
}
-(void)commonAction:(NSMutableArray *)imgArray btn:(UIButton *)btn{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    self.textViewInput = self.qmuiTextView.text;
    if (imgArray.count == 0) {
        [dic setValue:@"" forKey:@"photo1"];
        [dic setValue:@"" forKey:@"photo2"];
        [dic setValue:@"" forKey:@"photo3"];
        [QMUITips hideAllTipsInView:self.view];

        [QMUITips showInfo:@"请至少上传一张图片" inView:self.view hideAfterDelay:2];
        return;
    }
    if (imgArray.count >= 1){
        [dic setValue:imgArray[0] forKey:@"photo1"];
        [dic setValue:@"" forKey:@"photo2"];
        [dic setValue:@"" forKey:@"photo3"];
    }
    if (imgArray.count >= 2){
        [dic setValue:imgArray[0] forKey:@"photo1"];
        [dic setValue:imgArray[1] forKey:@"photo2"];
        [dic setValue:@"" forKey:@"photo3"];
    }
    if (imgArray.count >= 3){
        [dic setValue:imgArray[0] forKey:@"photo1"];
        [dic setValue:imgArray[1] forKey:@"photo2"];
        [dic setValue:imgArray[2] forKey:@"photo3"];
    }
    
    if (self.textViewInput.length == 0){
        [QMUITips showError:@"请输入描述!" inView:self.view hideAfterDelay:2];
        [QMUITips hideAllTipsInView:self.view];

        return;
    }else if (self.textViewInput.length >  100){
        [QMUITips showError:@"描述长度不能超过100字符" inView:self.view hideAfterDelay:2];
        [QMUITips hideAllTipsInView:self.view];

        return;
    }
    [dic setValue:[self.textViewInput utf8ToUnicode] forKey:@"describe"];//描述
    NSString * publish_site = [self.locationString isEqualToString:@"获取地理位置"] ? @"" : self.locationString;
    [dic setValue:publish_site forKey:@"publish_site"];//地点
    if (self.tagArray.count == 0) {
        [dic setValue:@"" forKey:@"tag"];//标签
    }else{
        NSString *string = [self.tagArray componentsJoinedByString:@" "];
        [dic setValue:string forKey:@"tag"];//标签
    }
    kWeakSelf(self);

        //这里区别寸草稿还是发布
        if (btn.tag == 301) {
            UserInfo *userInfo = curUser;
            NSString * userId = userInfo.id;
            NSString * key = [NSString stringWithFormat:@"%@%@",userId,[ShareManager getNowTimeTimestamp3]];
            JQFMDB *db = [JQFMDB shareDatabase];
            YXShaiTuModel * model = [[YXShaiTuModel alloc]init];
            if (imgArray.count == 0) {
                model.photo1 = @"";
                model.photo2 = @"";
                model.photo3 = @"";
            }
            if (imgArray.count >= 1){
                model.photo1 = imgArray[0];
                model.photo2 = @"";
                model.photo3 = @"";
            }
            if (imgArray.count >= 2){
                model.photo1 = imgArray[0];
                model.photo2 = imgArray[1];
                model.photo3 = @"";
            }
            if (imgArray.count >= 3){
                model.photo1 = imgArray[0];
                model.photo2 = imgArray[1];
                model.photo3 = imgArray[2];
            }
            model.describe = self.qmuiTextView.text;
            model.shaituid = key;
            [db jq_inDatabase:^{
                [db jq_insertTable:YX_USER_FaBuCaoGao dicOrModel:model];
            }];
            [QMUITips hideAllTipsInView:self.view];

            [QMUITips showSucceed:@"存草稿成功"];
            [weakself closeViewAAA];

        }else{
            [weakself requestFabu:dic];
        }

}
-(void)requestFabu:(NSMutableDictionary *)dic{
    kWeakSelf(self);
    //发布按钮
    [YX_MANAGER requestFaBuImagePOST:dic success:^(id object) {
        [QMUITips hideAllTipsInView:weakself.view];
        [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
        [weakself closeViewAAA];
    }];
}
-(void)closeViewAction:(id)sender{
    if (self.photoImageList.count > 0 || self.qmuiTextView.text.length > 0) {
        kWeakSelf(self);
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakself closeViewAAA];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakself fabuAction:self.cunCaoGaoBtn];
        }];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"你将退出发布,是否保存草稿?" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:action3];
        [alertController addAction:action2];
        [alertController addAction:action1];
        if (IS_IPAD) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
            CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
            CGRect cellRectInSelfView = [self.view convertRect:cellRect fromView:self.tableView];
            alertController.popoverPresentationController.sourceView = self.view;
            alertController.popoverPresentationController.sourceRect = cellRectInSelfView;
        }
        [self presentViewController:alertController animated:YES completion:NULL];
    }else{
        [self closeViewAAA];
    }
}
@end
