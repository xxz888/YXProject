//
//  YXFaBuBaseViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFaBuBaseViewController.h"
#import "JJImagePicker.h"
@interface YXFaBuBaseViewController ()<UITextFieldDelegate>{
    UIImageView * _selectImageView;
    UIImage * zhanweiImage;
}
#define img1_BOOL _img1.image && (_img1.image != zhanweiImage)
#define img2_BOOL _img2.image && _img2.image != zhanweiImage
#define img3_BOOL _img3.image && _img3.image != zhanweiImage

@end

@implementation YXFaBuBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextView];
    [self setOtherUI];
}
-(void)setOtherUI{
    UIColor * color1 = [UIColor darkGrayColor];
    ViewBorderRadius(self.cunCaoGaoBtn, 14, 1, YXRGBAColor(176, 151, 99));
    ViewBorderRadius(self.faBuBtn, 14, 1, color1);
    self.tagArray = [NSMutableArray array];
    self.photoImageList = [[NSMutableArray alloc]init];
    _locationString = self.locationBtn.titleLabel.text;
    ViewRadius(self.img1, 4);
    ViewRadius(self.img2, 4);
    ViewRadius(self.img3, 4);
    zhanweiImage = [UIImage imageNamed:@"LLImagePicker.bundle/AddMedia" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    
    
    
    _img1.image = zhanweiImage;
    _img2.image = zhanweiImage;
    _img3.image = zhanweiImage;
    
    
    self.del1.layer.masksToBounds = YES;
    self.del1.layer.cornerRadius = self.del1.frame.size.width / 2.0;
    
    self.del2.layer.masksToBounds = YES;
    self.del2.layer.cornerRadius = self.del2.frame.size.width / 2.0;
    
    self.del3.layer.masksToBounds = YES;
    self.del3.layer.cornerRadius = self.del2.frame.size.width / 2.0;
    
    
    _img1.hidden =  NO;
    _img2.hidden = _img3.hidden = _del1.hidden = _del2.hidden = _del3.hidden = YES;
    
    UITapGestureRecognizer * PrivateLetterTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView1:)];
    PrivateLetterTap1.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap1.numberOfTapsRequired = 1; //tap次数
    [self.img1 addGestureRecognizer:PrivateLetterTap1];
    
    UITapGestureRecognizer * PrivateLetterTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView2:)];
    PrivateLetterTap2.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap2.numberOfTapsRequired = 1; //tap次数
    [self.img2 addGestureRecognizer:PrivateLetterTap2];
    
    UITapGestureRecognizer * PrivateLetterTap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView3:)];
    PrivateLetterTap3.numberOfTouchesRequired = 1; //手指数
    PrivateLetterTap3.numberOfTapsRequired = 1; //tap次数
    [self.img3 addGestureRecognizer:PrivateLetterTap3];
}
- (void)tapAvatarView1: (UITapGestureRecognizer *)gesture{
    [self addThreeImageView:self.img1];
}
- (void)tapAvatarView2: (UITapGestureRecognizer *)gesture{
    [self addThreeImageView:self.img2];
}
- (void)tapAvatarView3: (UITapGestureRecognizer *)gesture{
    [self addThreeImageView:self.img3];
}
-(void)addTextView{
    if (!self.qmuiTextView) {
        self.qmuiTextView = [[QMUITextView alloc] init];
    }
    self.qmuiTextView.frame = CGRectMake(0,0, KScreenWidth-20, self.detailView.qmui_height);
    self.qmuiTextView.backgroundColor = YXRGBAColor(239, 239, 239);
    self.qmuiTextView.font = UIFontMake(15);
    self.qmuiTextView.placeholder = @"写点什么...";
    self.qmuiTextView.layer.cornerRadius = 8;
    self.qmuiTextView.clipsToBounds = YES;
    [self.qmuiTextView becomeFirstResponder];
    [self.detailView addSubview:self.qmuiTextView];
}
-(void)addThreeImageView:(UIImageView *)img{
    _selectImageView = img;
    JJImagePicker *picker = [JJImagePicker sharedInstance];
    //自定义裁剪图片的ViewController
    picker.customCropViewController = ^TOCropViewController *(UIImage *image) {
//        if (picker.type == JJImagePickerTypePhoto) {
//            //使用默认
//            return nil;
//        }
        TOCropViewController  *cropController = [[TOCropViewController alloc] initWithImage:image];
        //选择框可以按比例来手动调节
        cropController.aspectRatioLockEnabled = NO;
        //        cropController.resetAspectRatioEnabled = NO;
        //设置选择宽比例
        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        //显示选择框比例的按钮
        cropController.aspectRatioPickerButtonHidden = NO;
        //显示选择按钮
        cropController.rotateButtonsHidden = NO;
        //设置选择框可以手动移动
        cropController.cropView.cropBoxResizeEnabled = YES;
        return cropController;
    };
    picker.albumText = @"";
    picker.cancelText = @"取消";
    picker.doneText = @"完成";
    picker.retakeText = @"重拍";
    picker.choosePhotoText = @"选择图片";
    picker.automaticText = @"Automatic";
    picker.closeText = @"Close";
    picker.openText = @"打开";
    kWeakSelf(self);
    [picker actionSheetWithTakePhotoTitle:@"拍照" albumTitle:@"相册" cancelTitle:@"取消" InViewController:self didFinished:^(JJImagePicker *picker, UIImage *image) {
        if (img) {
            _selectImageView.image = image;
            if (_selectImageView.tag == 11) {
                _del1.hidden = NO;
                _img2.hidden = NO;
            }
            if (_selectImageView.tag == 12) {
                _del2.hidden = NO;
                _img3.hidden = NO;
            }
            if (_selectImageView.tag == 13) {
                _del3.hidden = NO;
            }
            
            
            //先上传到七牛云图片  再提交服务器
            [QiniuLoad uploadImageToQNFilePath:@[image] success:^(NSString *reslut) {
                NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                if (qiniuArray.count > 0) {
                    [weakself.photoImageList addObject:qiniuArray[0]];
                }
            } failure:^(NSString *error) {
                NSLog(@"%@",error);
            }];
        }
      
    }];
};
- (IBAction)delAction:(UIButton *)btn {
    switch (btn.tag) {
        case 201:{
            if (_img2.image == zhanweiImage) {
                _img1.image = zhanweiImage;
                _img2.hidden = YES;
            }else{
                
                if (_img3.image == zhanweiImage) {
                    _img2.image = zhanweiImage;
                    _img3.hidden = YES;

                }else{
                    _img1.image = _img2.image;
                    _img2.image = _img3.image;
                    _img3.image = zhanweiImage;
                }
            }
            _del1.hidden = [self inImageViewOutIsHidden:_img1];
            _del2.hidden = [self inImageViewOutIsHidden:_img2];
            _del3.hidden = [self inImageViewOutIsHidden:_img3];
            [self.photoImageList removeObjectAtIndex:0];
        }
            break;
        case 202:{
            if (_img3.image == zhanweiImage) {
                _img2.image = zhanweiImage;
                _img3.hidden = YES;
            }else{
                _img2.image = _img3.image;
                _img3.image = zhanweiImage;
            }
            _del1.hidden = [self inImageViewOutIsHidden:_img1];
            _del2.hidden = [self inImageViewOutIsHidden:_img2];
            _del3.hidden = [self inImageViewOutIsHidden:_img3];
            [self.photoImageList removeObjectAtIndex:1];

        }
            break;
        case 203:{
            _img3.image = zhanweiImage;
            _del1.hidden = [self inImageViewOutIsHidden:_img1];
            _del2.hidden = [self inImageViewOutIsHidden:_img2];
            _del3.hidden = [self inImageViewOutIsHidden:_img3];
            [self.photoImageList removeObjectAtIndex:2];
        }
            break;
        default:
            break;
    }
}
-(BOOL)inImageViewOutIsHidden:(UIImageView *)img{
    if (img.image == zhanweiImage || img.hidden) {
        return YES;
    }
    return  NO;
}
- (IBAction)fabuAction:(UIButton *)btn{
//    [_photoImageList removeAllObjects];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    if (_img1.image && _img1.image != zhanweiImage) {
//        [_photoImageList addObject:_img1.image];
//    }
//    if (_img2.image && _img2.image != zhanweiImage) {
//        [_photoImageList addObject:_img2.image];
//    }
//    if (_img3.image && _img3.image != zhanweiImage) {
//        [_photoImageList addObject:_img3.image];
//    }
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
    if ([_xinhuatiTf.text isEqualToString:@""]) {
        return;
    }
    [_tagArray addObject:[_xinhuatiTf.text concate:@"#"]];
    if (self.menueView) {
        [_menueView setContentView:@[_tagArray] titleArr:@[]];
    }else{
        [self addNewTags];
    }
    [btn.superview.superview removeFromSuperview];
}

-(void)addNewTags{

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
        NSMutableArray * array = [NSMutableArray arrayWithArray:weakself.tagArray];
        [array removeObjectAtIndex:index];
        [weakself.tagArray removeAllObjects];
        [weakself.tagArray addObjectsFromArray:array];
        [_menueView setContentView:@[weakself.tagArray] titleArr:@[]];
        [self addNewTags];


        
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
    _xinhuatiTf.delegate = self;
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
- (IBAction)closeViewAction:(id)sender {
//   [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self closeViewAAA];
}
-(void)closeViewAAA{
    UIViewController *controller = self;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
