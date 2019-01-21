//
//  YXHomeQuestionFaBuViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeQuestionFaBuViewController.h"
#import "ZZYPhotoHelper.h"
#import "LLImagePickerView.h"
#import "LTTextView.h"
#import "QMUITextView.h"
#import "QiniuLoad.h"
@interface YXHomeQuestionFaBuViewController (){
    LTTextView * _textView;
    NSMutableArray * _photoImageList;

}
@property(nonatomic, strong) QMUITextView * qmuiTextView;
@end

@implementation YXHomeQuestionFaBuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布提问";
    
    
    
    //添加3张图片
    [self initImagePhontoView];
    //
    [self initAllCon];
}
-(void)initAllCon{
    ViewRadius(self.xinhuatiBtn, 3);
    ViewRadius(self.moreBtn, 3);
    
    
    self.qmuiTextView = [[QMUITextView alloc] init];
    self.qmuiTextView.frame = CGRectMake(0, 0, self.questionMainView.frame.size.width, self.questionMainView.frame.size.height);
    self.qmuiTextView.backgroundColor = YXRGBAColor(239, 239, 239);
    self.qmuiTextView.font = UIFontMake(15);
    self.qmuiTextView.placeholder = @"发表你的提问";
    //    self.qmuiTextView.textContainerInset = UIEdgeInsetsMake(16, 12, 16, 12);
    self.qmuiTextView.layer.cornerRadius = 8;
    self.qmuiTextView.clipsToBounds = YES;
    [self.qmuiTextView becomeFirstResponder];
    [self.questionMainView addSubview:self.qmuiTextView];
    
    _photoImageList = [[NSMutableArray alloc]init];
}
-(void)initImagePhontoView{
    kWeakSelf(self);
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, KScreenWidth,self.questionImageView.frame.size.height) CountOfRow:3];
    pickerV.type = LLImageTypeAll;
    pickerV.maxImageSelected = 3;
    pickerV.allowPickingVideo = NO;
    [self.questionImageView addSubview:pickerV];
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        [_photoImageList removeAllObjects];
        for (LLImagePickerModel * model in list) {
            [_photoImageList addObject:model.image];
        }
    }];
}

#pragma mark ========== 发布 ==========
- (IBAction)fabuAction:(id)sender {
    kWeakSelf(self);
    //先上传到七牛云图片  再提交服务器
    [QiniuLoad uploadImageToQNFilePath:_photoImageList success:^(NSString *reslut) {
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
        }else if (self.questionTitleTf.text.length == 0){
            [QMUITips showError:@"请输入标题!" inView:self.view hideAfterDelay:2];
            return;
        }else if (self.qmuiTextView.text.length == 0){
            [QMUITips showError:@"请输入要提问的问题!" inView:self.view hideAfterDelay:2];
            return;
        }
        [dic setValue: self.qmuiTextView.text forKey:@"question"];
        [dic setValue:self.questionTitleTf.text forKey:@"title"];//标题
        [dic setValue:self.whereCome forKey:@"type"];//(1,"雪茄"),(2,"高尔夫"),(3,"红酒")
        //发布按钮
        [YX_MANAGER requestFaBuQuestionPOST:dic success:^(id object) {
            if ([object isEqualToString:@"1"]) {
                [QMUITips showSucceed:@"发布成功" inView:weakself.view hideAfterDelay:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [QMUITips showError:@"发布失败,请稍后重试" inView:weakself.view hideAfterDelay:2];
            }
        }];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
}

- (IBAction)xinhuatiAction:(id)sender {
}

- (IBAction)moreAction:(id)sender {
}
@end
