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
    if (_startDic) {
        self.cunCaoGaoBtn.hidden = YES;
        [self faxianEditCome];
    }
    if (_model) {

    }
}

//如果是从发现界面编辑进来的
-(void)faxianEditCome{
        //标签
        self.tagArray = [NSMutableArray arrayWithArray:[_startDic[@"tag"] split:@" "]];
        [self addNewTags];
        //地点
        self.locationString = [_startDic[@"publish_site"] isEqualToString:@""] ? @"获取地理位置" :  _startDic[@"publish_site"] ;
        [self.locationBtn setTitle:self.locationString forState:UIControlStateNormal];
}
#pragma mark ========== 发布1 和 存草稿0  ==========
- (IBAction)fabuAction:(UIButton *)btn {
    [super fabuAction:btn];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if ([self.selectedPhotos count] == [self.photoImageList count]) {
        [self commonAction:self.photoImageList btn:btn];
    }else{
        [QMUITips showInfo:@"正在上传图片,请稍等" inView:self.view hideAfterDelay:2];
    }
}
#define kQNinterface @"http://photo.thegdlife.com/"
-(NSString *)removeStrxtys:(NSString *)origStr{
    NSString *temp = nil;
    NSMutableArray *arr_0 = [NSMutableArray new];
    for(int i =0; i < [origStr length]; i++)
    {
        temp = [origStr substringWithRange:NSMakeRange(i, 1)];
        BOOL isbool = [arr_0 containsObject:temp];
        if (!isbool) {
            [arr_0 addObject:temp];
        }
    }
    NSString *result = [arr_0 componentsJoinedByString:@""];
    return result;
}

-(void)commonAction:(NSMutableArray *)imgArray btn:(UIButton *)btn{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    self.textViewInput = self.qmuiTextView.text;
    if (!_startDic && imgArray.count == 0) {
        [QMUITips showInfo:@"请至少上传一张图片!" inView:self.view hideAfterDelay:2];
        return;
    }
    if (self.textViewInput.length == 0){
        [QMUITips showError:@"请输入描述!" inView:self.view hideAfterDelay:2];
        return;
    }
//post_id 修改传，发布传空
    [dic setValue:@"" forKey:@"post_id"];
//title 标题 晒图不传
    [dic setValue:@"" forKey:@"title"];
//封面
    [dic setValue:@"" forKey:@"cover"];
//detail 详情
    [dic setValue:[self.textViewInput utf8ToUnicode] forKey:@"detail"];
//拼接photo_list
    NSString * photo_list = [imgArray componentsJoinedByString:@","];
    photo_list = [photo_list replaceAll:kQNinterface target:@""];
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
            model.describe = self.qmuiTextView.text;
            model.shaituid = key;
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
    if (_startDic) {
        [dic setValue:kGetString(_startDic[@"id"]) forKey:@"post_id"];
        [self lastFabu:dic];
    }else{
        [self lastFabu:dic];
    }
}
-(void)lastFabu:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestFaBuImagePOST:dic success:^(id object) {
        [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
        [weakself closeViewAAA];
    }];
}
-(void)closeViewAction:(id)sender{

    if (_startDic) {
        [self closeViewAAA];

    }else{
        if (self.photoImageList.count > 0 || self.qmuiTextView.text.length > 0 ) {
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
    
   
}
@end
