//
//  YXFaBuBaseViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFaBuBaseViewController.h"

@interface YXFaBuBaseViewController (){
}


@end

@implementation YXFaBuBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextView];
    [self addThreeImageView];
    [self setOtherUI];
}
-(void)setOtherUI{
    UIColor * color1 = [UIColor darkGrayColor];
    ViewBorderRadius(self.cunCaoGaoBtn, 14, 1, YXRGBAColor(176, 151, 99));
    ViewBorderRadius(self.faBuBtn, 14, 1, color1);
    self.tagArray = [[NSMutableArray alloc]init];
    self.photoImageList = [[NSMutableArray alloc]init];
    _locationString = self.locationBtn.titleLabel.text;
}
-(void)addTextView{
    if (!self.qmuiTextView) {
        self.qmuiTextView = [[QMUITextView alloc] init];
    }
    self.qmuiTextView.frame = CGRectMake(0,0, self.detailView.qmui_width, self.detailView.qmui_height);
    self.qmuiTextView.backgroundColor = YXRGBAColor(239, 239, 239);
    self.qmuiTextView.font = UIFontMake(15);
    self.qmuiTextView.placeholder = @"发表你的提问";
    self.qmuiTextView.layer.cornerRadius = 8;
    self.qmuiTextView.clipsToBounds = YES;
    [self.qmuiTextView becomeFirstResponder];
    [self.detailView addSubview:self.qmuiTextView];
}
-(void)addThreeImageView{
    
//    NSMutableArray * preArray = [[NSMutableArray alloc]init];
//    if (self.caoGaoDic) {
//        if (self.caoGaoDic[@"photo1"]) {
//            [preArray addObject:self.caoGaoDic[@"photo1"]];
//        }else  if (self.caoGaoDic[@"photo2"]) {
//            [preArray addObject:self.caoGaoDic[@"photo2"]];
//        }else if (self.caoGaoDic[@"photo3"]) {
//            [preArray addObject:self.caoGaoDic[@"photo3"]];
//        }
//    }
    
    kWeakSelf(self);
    LLImagePickerView *pickerV = [LLImagePickerView ImagePickerViewWithFrame:CGRectMake(0, 0, self.threeImageView.frame.size.width,self.threeImageView.frame.size.height) CountOfRow:3];
    pickerV.type = LLImageTypePhotoAndCamera;
    pickerV.maxImageSelected = 3;
    pickerV.allowPickingVideo = NO;
    [self.threeImageView addSubview:pickerV];
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        [_photoImageList removeAllObjects];
        for (LLImagePickerModel * model in list) {
            [_photoImageList addObject:model.image];
        }
    }];
}
- (IBAction)fabuAction:(id)sender{
}

- (IBAction)locationBtnAction:(id)sender{
    kWeakSelf(self);
    YXGaoDeMapViewController * VC = [[YXGaoDeMapViewController alloc]init];
    VC.block = ^(NSString * locationString) {
        _locationString = locationString;
        [self.locationBtn setTitle:locationString forState:0];
        [weakself dismissViewControllerAnimated:YES completion:nil];
    };
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
    [weakself presentViewController:nav animated:YES completion:nil];
}
- (IBAction)xinhuatiAction:(id)sender{
    [self pushNewHuaTi];
}
- (IBAction)moreAction:(id)sender{
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

-(void)xinhuatiButtonAction:(UIButton *)btn{
    [_tagArray addObject:[_xinhuatiTf.text concate:@"#"]];
    if (self.menueView) {
        [_menueView setContentView:@[_tagArray] titleArr:@[]];
    }else{
        [self addNewTags];
    }
    [btn.superview.superview removeFromSuperview];
}

-(void)addNewTags{
    if (_xinhuatiTf.text.length < 1) {
        [QMUITips showError:@"请输入新话题" inView:self.view hideAfterDelay:1];
        return;
    }
    NSArray * titleArr = @[@""];
    NSArray *contentArr = @[_tagArray];
    CBGroupAndStreamView * silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0,self.floatView.qmui_width, self.floatView.qmui_height)];
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
        //        NSMutableArray * array = [NSMutableArray arrayWithArray:weakself.tagArray];
        //        [array removeObjectAtIndex:index];
        //        [weakself.tagArray removeAllObjects];
        //        [weakself.tagArray addObjectsFromArray:array];
        //        [_menueView setContentView:@[weakself.tagArray] titleArr:@[]];
    };
}
-(void)pushNewHuaTi{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(50, 20, 30, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    
    _xinhuatiTf = [[QMUITextField alloc] initWithFrame:CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, 36)];
    _xinhuatiTf.placeholder = @"请输入新话题";
    _xinhuatiTf.borderStyle = UITextBorderStyleRoundedRect;
    _xinhuatiTf.font = UIFontMake(16);
    [contentView addSubview:_xinhuatiTf];
    [_xinhuatiTf becomeFirstResponder];
    
    UIButton *btn = [UIButton buttonWithType:0];
    ViewBorderRadius(btn, 4, 1, [UIColor darkGrayColor]);
    [btn setTitleColor:[UIColor darkGrayColor] forState:0];
    [btn setTitle:@"添加" forState:0];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20];
    paragraphStyle.paragraphSpacing = 20;
    [contentView addSubview:btn];
    
    btn.frame = CGRectMake(contentViewPadding.left, CGRectGetMaxY(_xinhuatiTf.frame) + 20, contentLimitWidth/1.8, QMUIViewSelfSizingHeight);
    btn.centerX = _xinhuatiTf.centerX;
    contentView.frame = CGRectSetHeight(contentView.frame, CGRectGetMaxY(btn.frame) + contentViewPadding.bottom);
    [btn addTarget:self action:@selector(xinhuatiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}
- (IBAction)closeViewAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
