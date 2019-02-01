//
//  YXPublishFootViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishFootViewController.h"


#import "ZZYPhotoHelper.h"
#import "LLImagePickerView.h"
#import "LTTextView.h"
#import "QMUITextView.h"
#import "QiniuLoad.h"
#import "CBGroupAndStreamView.h"
#import "YXGaoDeMapViewController.h"
#import "YXPublishMoreTagsViewController.h"
@interface YXPublishFootViewController (){
    LTTextView * _textView;
    NSMutableArray * _photoImageList;
    NSMutableArray * _tagArray;
    UITextField * textField;
    NSString * _textViewInput;
}
@property(nonatomic, strong) QMUITextView * qmuiTextView;
@property (strong, nonatomic) CBGroupAndStreamView * menueView;
@property (weak, nonatomic) IBOutlet UIView *floatView;
@end

@implementation YXPublishFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布足迹";
    _tagArray = [[NSMutableArray alloc]init];
    
    
    //添加3张图片
    [self initImagePhontoView];
    //
    [self initAllCon];
}
-(void)initAllCon{
    ViewRadius(self.xinhuatiBtn, 3);
    ViewRadius(self.moreBtn, 3);
    
    self.qmuiTextView = [[QMUITextView alloc] init];
    self.qmuiTextView.frame = CGRectMake(0, 0, KScreenWidth - 20, self.questionMainView.frame.size.height);
    self.qmuiTextView.backgroundColor = YXRGBAColor(239, 239, 239);
    self.qmuiTextView.font = UIFontMake(15);
    self.qmuiTextView.placeholder = @"发表你的足迹";
    self.qmuiTextView.layer.cornerRadius = 8;
    self.qmuiTextView.clipsToBounds = YES;
    [self.qmuiTextView becomeFirstResponder];
    [self.questionMainView addSubview:self.qmuiTextView];
    _photoImageList = [[NSMutableArray alloc]init];
}
-(void)initImagePhontoView{
    kWeakSelf(self);
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, self.questionImageView.frame.size.width,self.questionImageView.frame.size.height) CountOfRow:3];
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
        }else if (self.qmuiTextView.text.length == 0){
            [QMUITips showError:@"请输入足迹描述!" inView:self.view hideAfterDelay:2];
            return;
        }
        
        [dic setValue:self.cigar_id forKey:@"cigar_id"];
        [dic setValue:[ShareManager getNowTimeMiaoShu] forKey:@"publish_time"];

        
        [dic setValue: self.qmuiTextView.text forKey:@"content"];
        [dic setValue:@(1) forKey:@"type"];//(1,"雪茄"),(2,"红酒"),(3,"高尔夫")
        [dic setValue:self.switchBtn.isOn ? @(1) : @(2) forKey:@"to_find"];
        
        NSString * tag  = _tagArray.count == 0 ? @"" : [_tagArray componentsJoinedByString:@","];
        [dic setValue:tag forKey:@"tag"];//标签
        
        NSString * publish_site = [self.locationBtn.titleLabel.text isEqualToString:@"你的位置"] ? @"" : self.locationBtn.titleLabel.text;
        [dic setValue:publish_site forKey:@"publish_site"];
        
        //发布按钮
        [YX_MANAGER requestPost_track:dic success:^(id object) {
            if ([object[@"status"] integerValue] == 1) {
                [QMUITips showSucceed:object[@"message"] inView:weakself.view hideAfterDelay:2];
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
- (IBAction)switchBtnAction:(id)sender {
    
    
}


- (IBAction)moreAction:(id)sender {
    kWeakSelf(self);
    YXPublishMoreTagsViewController * VC = [[YXPublishMoreTagsViewController alloc]init];
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
    VC.tagBlock = ^(NSDictionary * dic) {
        [_tagArray addObject:[@"#" append:dic[@"tag"]]];
        if (weakself.menueView) {
            [_menueView setContentView:@[_tagArray] titleArr:@[]];
        }else{
            [weakself addNewTags];
        }
    };
    [weakself presentViewController:nav animated:YES completion:nil];
}




- (IBAction)locationBtnAction:(id)sender {
    kWeakSelf(self);
    YXGaoDeMapViewController * VC = [[YXGaoDeMapViewController alloc]init];
    VC.block = ^(NSString * locationString) {
        [weakself.locationBtn setTitle:locationString forState:0];
        [weakself dismissViewControllerAnimated:YES completion:nil];
    };
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
    [weakself presentViewController:nav animated:YES completion:nil];
}


-(void)addNewTags{
    NSArray * titleArr = @[@""];
    NSArray *contentArr = @[_tagArray];
    CBGroupAndStreamView * silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.floatView.bounds.size.height)];
    silde.isSingle = YES;
    silde.radius = 5;
    silde.font = [UIFont systemFontOfSize:12];
    silde.titleTextFont = [UIFont systemFontOfSize:18];
    [silde setContentView:contentArr titleArr:titleArr];
    [self.floatView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.floatView addSubview:silde];
    _menueView = silde;
    kWeakSelf(self);
    silde.cb_selectCurrentValueBlock = ^(NSString *value, NSInteger index, NSInteger groupId) {
        [_tagArray removeObjectAtIndex:index];
        [_menueView setContentView:@[_tagArray] titleArr:@[]];
    };
}
//新话题
- (IBAction)xinhuatiAction:(id)sender {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(50, 20, 30, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    
    textField = [[QMUITextField alloc] initWithFrame:CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, 36)];
    textField.placeholder = @"请输入新话题";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = UIFontMake(16);
    [contentView addSubview:textField];
    [textField becomeFirstResponder];
    
    UIButton *btn = [UIButton buttonWithType:0];
    ViewBorderRadius(btn, 4, 1, [UIColor darkGrayColor]);
    [btn setTitleColor:[UIColor darkGrayColor] forState:0];
    [btn setTitle:@"添加" forState:0];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20];
    paragraphStyle.paragraphSpacing = 20;
    [contentView addSubview:btn];
    
    btn.frame = CGRectMake(contentViewPadding.left, CGRectGetMaxY(textField.frame) + 20, contentLimitWidth/1.8, QMUIViewSelfSizingHeight);
    btn.centerX = textField.centerX;
    contentView.frame = CGRectSetHeight(contentView.frame, CGRectGetMaxY(btn.frame) + contentViewPadding.bottom);
    [btn addTarget:self action:@selector(addNewHuaTi:) forControlEvents:UIControlEventTouchUpInside];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}
-(void)addNewHuaTi:(UIButton *)btn{
    if (textField.text.length < 1) {
        [QMUITips showError:@"请输入新话题" inView:btn.superview hideAfterDelay:2];
        return;
    }
    kWeakSelf(self);
    //新话题
    [_tagArray addObject:[textField.text concate:@"#"]];
    if (weakself.menueView) {
        [_menueView setContentView:@[_tagArray] titleArr:@[]];
    }else{
        [weakself addNewTags];
    }
    [btn.superview.superview removeFromSuperview];
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}



















#pragma mark - 完成发布
//完成发布
-(void)finishPublish{
    //2.block传值
    if (self.mDismissBlock != nil) {
        self.mDismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//block声明方法
-(void)toDissmissSelf:(dismissBlock)block{
    self.mDismissBlock = block;
}

@end
