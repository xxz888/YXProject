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

    //如果model有，说明1、是编辑界面进来的 2、是从草稿界面进来的
    if (_model) {
        [self faxianEditCome];
    }
}

//如果是从发现界面编辑进来的
-(void)faxianEditCome{
    
    
    //标签
    self.tagArray = [NSMutableArray arrayWithArray:[self.model.tag split:@" "]];
    [self addNewTags];
    //地点
    self.locationString = [self.model.publish_site isEqualToString:@""] ? @"获取地理位置" :  self.model.publish_site;
    [self.locationBtn setTitle:self.locationString forState:UIControlStateNormal];
    
    for (NSString * imgString in [self.model.photo_list split:@","]) {
        KSMediaPickerOutputModel * model = [KSMediaPickerOutputModel.alloc modelInitWithCoder:nil];
        [self.selectedPhotos addObject:model];
        [self.photoImageList addObject:[IMG_URI append:imgString]];
    }
    //封面
    self.videoCoverImageString = @"";
    
    //内容
    self.qmuiTextView.text = [self.model.detail UnicodeToUtf8];
    //类型
    self.fabuType = NO;
}
#pragma mark ========== 发布1 和 存草稿0  ==========
- (IBAction)fabuAction:(UIButton *)btn {
    [super fabuAction:btn];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if ([self.selectedPhotos count] == [self.photoImageList count]) {
        if (self.fabuType){//视频
            if([self.videoCoverImageString isEqualToString:@""]){
                [QMUITips showInfo:@"正在上传,请稍等" inView:self.view hideAfterDelay:2];
            }else{
                [self commonAction:self.photoImageList btn:btn];
            }
        }else{//图片
            [self commonAction:self.photoImageList btn:btn];
        }
    }else{
        [QMUITips showInfo:@"正在上传,请稍等" inView:self.view hideAfterDelay:2];
    }
}

-(void)commonAction:(NSMutableArray *)imgArray btn:(UIButton *)btn{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    self.textViewInput = self.qmuiTextView.text;
    if (imgArray.count == 0) {
        [QMUITips showInfo:@"请至少上传一张图片或者一个视频!" inView:self.view hideAfterDelay:2];
        return;
    }
//post_id 修改传，发布传空
    [dic setValue:self.model.post_id ? self.model.post_id : @"" forKey:@"post_id"];
//title 标题 晒图不传
    [dic setValue:@"" forKey:@"title"];
//封面
    [dic setValue:self.videoCoverImageString forKey:@"cover"];
//detail 详情
    [dic setValue:[self.textViewInput utf8ToUnicode] forKey:@"detail"];
//拼接photo_list
    NSString * photo_list = [imgArray componentsJoinedByString:@","];
    photo_list = [photo_list replaceAll:IMG_URI target:@""];
    [dic setValue:photo_list forKey:@"photo_list"];
//obj 1晒图 2文章
    [dic setValue:@"1" forKey:@"obj"];
//tag 标签
    self.tagArray.count == 0 ?
    [dic setValue:@"" forKey:@"tag"] : [dic setValue:[self.tagArray componentsJoinedByString:@" "] forKey:@"tag"];
//publish_site 地点
    NSString * publish_site = [self.locationString isEqualToString:@"获取地理位置"] ? @"" : self.locationString;
    [dic setValue:publish_site forKey:@"publish_site"];
    
    kWeakSelf(self);
        //这里区别寸草稿还是发布
        if (btn.tag == 301) {
            UserInfo *userInfo = curUser;
            NSString * userId = userInfo.id;
            NSString * key = [NSString stringWithFormat:@"%@%@",userId,[ShareManager getNowTimeTimestamp3]];
            JQFMDB *db = [JQFMDB shareDatabase];
            YXShaiTuModel * model = [[YXShaiTuModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
             model.coustomId =  key;
            [db jq_inDatabase:^{
                [db jq_insertTable:YX_USER_FaBuCaoGao dicOrModel:model];
            }];
            [QMUITips showSucceed:@"存草稿成功"];
            [weakself closeViewAAA];
        }else{
            [weakself requestFabu:dic];
        }

}
-(void)requestFabu:(NSMutableDictionary *)dic{
    [QMUITips showLoadingInView:[ShareManager getMainView]];
    BOOL sameBool = [self.model.post_id isEqualToString:@""];
    
    if (sameBool) {
        [self lastFabu:dic];
    }else{
        [dic setValue:self.model.post_id forKey:@"post_id"];
        [self lastFabu:dic];
    }
}
-(void)lastFabu:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestFaBuImagePOST:dic success:^(id object) {
        [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
        [weakself closeViewAAA];
        
        
        
        if (self.model.coustomId && ![self.model.coustomId isEqualToString:@""]) {
            JQFMDB *db = [JQFMDB shareDatabase];
            NSString * sql = [@"WHERE coustomId = " append:kGetString(self.model.coustomId)];
            [db jq_deleteTable:YX_USER_FaBuCaoGao whereFormat:sql];
        }
    }];
}
-(void)closeViewAction:(id)sender{

    if (_startDic) {
        [self closeViewBBB];

    }else{
        if (self.photoImageList.count > 0 || self.qmuiTextView.text.length > 0 ) {
            kWeakSelf(self);
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weakself closeViewBBB];
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
            [self closeViewBBB];
        }
    }
}
-(void)closeViewAAA{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSecondVC" object:nil];

    if (self.closeNewVcblock) {
        self.closeNewVcblock();
        
    }else{
        [self closeViewBBB];
    }

}
-(void)closeViewBBB{
    UIViewController *controller = self;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:YES completion:^{}];
}
@end
