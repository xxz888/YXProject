//
//  EditorViewController.m
//  RichTextEditorDemo
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import "EditorViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "YYKit.h"
#import "TZImagePickerController.h"
#import "BlocksKit+UIKit.h"
#import "Tool.h"
#import "YXWenZhangView.h"
#import "UniversalApp-Swift.h"
#import "QiniuLoad.h"
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface EditorViewController ()<YYTextViewDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,KSMediaPickerControllerDelegate>
@property (nonatomic ,strong)UIButton * publishBtn;

@property (nonatomic, strong) YYTextView *contentTextView;
@property (nonatomic ,strong)TZImagePickerController *imagePickerVc;
@property (nonatomic ,assign)CGFloat keyboardHeight;
@property (nonatomic ,assign)CGFloat navHeight;

@property (nonatomic ,strong)NSMutableArray * imagesArr;    //存放图片
@property (nonatomic ,strong)NSMutableArray * imageUrlsArr; // 存放图片url
@property (nonatomic ,strong)NSMutableArray * desArr;       //存放图片描述
@property (nonatomic ,strong)NSString * contentStr;       // 带有标签的文章内容

@property (nonatomic, strong) YXWenZhangView * headerView;

@end

@implementation EditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布图文";
    self.view.backgroundColor = [UIColor whiteColor];
    _navHeight = kDevice_Is_iPhoneX ? 88 : 64;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [self setupSubViews];
}

/**
 设置UI布局
 */
- (void)setupSubViews {
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.publishBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    // 图文正文输入框
    [self.view addSubview:self.contentTextView];
}
#pragma mark - setter
- (YYTextView *)contentTextView {
    if (!_contentTextView) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXWenZhangView" owner:self options:nil];
        self.headerView = [nib objectAtIndex:0];
        self.headerView.frame = CGRectMake(0,0,self.view.frame.size.width,200);
        YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + 60, KScreenWidth, KScreenHeight - 60 - kStatusBarHeight)];
        textView.tag = 1000;
        textView.textContainerInset = UIEdgeInsetsMake(210, 16, 20,16);
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        textView.scrollIndicatorInsets = textView.contentInset;
        textView.delegate = self;
        textView.placeholderText = @"请输入文章";
        textView.font = [UIFont fontWithName:@"苹方-简" size:15];
        textView.placeholderFont = [UIFont fontWithName:@"苹方-简" size:15];
        textView.textColor = [UIColor blackColor];
        textView.selectedRange = NSMakeRange(textView.text.length, 0);
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        textView.allowsPasteImage = YES;
        textView.allowsPasteAttributedString = YES;
        textView.typingAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        textView.inputAccessoryView = [self textViewBar];
        _contentTextView = textView;
        [_contentTextView addSubview:self.headerView];
        
        kWeakSelf(self);
        self.headerView.clickTitleImgBlock = ^(UIImageView * iamge) {
            KSMediaPickerController *ctl = [KSMediaPickerController.alloc initWithMaxVideoItemCount:1 maxPictureItemCount:9];
            ctl.view.tag = 2;
            ctl.delegate = weakself;
            KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
            [weakself presentViewController:nav animated:YES completion:nil];
        };
    }
    return _contentTextView;
}
/**
 获取键盘高度
 */
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
}

/**
 插入图片
 
 @param image 图片image
 */
- (void)setupImage:(UIImage *)image {
    NSAttributedString * changeString =  [[NSAttributedString alloc] initWithString:@"\n" attributes:nil];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTextView.attributedText];

    UIFont *font = [UIFont systemFontOfSize:20];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
    YYImage *img = [YYImage imageWithData:imgData];
    
    
    
    img.preloadAllAnimatedImageFrames = YES;
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.autoPlayAnimatedImage = NO;
    imageView.clipsToBounds = YES;
    
    
    [imageView startAnimating];
    CGSize size = imageView.size;
    CGFloat textViewWidth = kScreenWidth - 32.0;
    size = CGSizeMake(textViewWidth, size.height * textViewWidth / size.width);
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleToFill attachmentSize:size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text insertAttributedString:attachText atIndex:self.contentTextView.selectedRange.location];
    [text appendAttributedString:changeString];
    [text appendAttributedString:changeString];
    [text appendAttributedString:changeString];
    text.font = font;
    self.contentTextView.attributedText = text;
    [self.contentTextView becomeFirstResponder];
    self.contentTextView.selectedRange = NSMakeRange(self.contentTextView.text.length, 0);
}

    
- (IBAction)backVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)fabuAction:(id)sender {
    [self.imagesArr removeAllObjects];
    [self.desArr removeAllObjects];
    [self.imageUrlsArr removeAllObjects];
    
    NSAttributedString *content = self.contentTextView.attributedText;
    NSString *text = [self.contentTextView.text copy];
    //这一步开始上传
    kWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [content enumerateAttributesInRange:NSMakeRange(0, text.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            YYTextAttachment *att = attrs[@"YYTextAttachment"];
            if (att) {
                if ([att.content isKindOfClass:[YYTextView class]]) {
                    YYTextView * textView = att.content;
                    [self.desArr addObject:textView.text];
                }else{
                    YYAnimatedImageView *imgView = att.content;
                    [self.imagesArr addObject:imgView.image];

                    [QiniuLoad uploadImageToQNFilePath:@[imgView.image] success:^(NSString *reslut) {
                        NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                        [weakself.imageUrlsArr addObject:qiniuArray[0]];
                        dispatch_semaphore_signal(sema);
                    } failure:^(NSString *error) {}];
                    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                }
            }

        }];
        self.contentStr = [text stringByReplacingOccurrencesOfString:@"\U0000fffc\U0000fffc" withString:@"<我是图片>"];
        NSString * resuletString = [Tool makeHtmlString:_imageUrlsArr desArr:_desArr contentStr:_contentStr];
        NSLog(@"%@",resuletString);
    });



}
    

/**
 发布
 */
-(void)clickToPublish{
    [self.imagesArr removeAllObjects];
    [self.desArr removeAllObjects];
    [self.imageUrlsArr removeAllObjects];
    
    NSAttributedString *content = self.contentTextView.attributedText;
    NSString *text = [self.contentTextView.text copy];
    
    [content enumerateAttributesInRange:NSMakeRange(0, text.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        YYTextAttachment *att = attrs[@"YYTextAttachment"];
        if (att) {
            if ([att.content isKindOfClass:[YYTextView class]]) {
                YYTextView * textView = att.content;
                [self.desArr addObject:textView.text];
            }else{
                YYAnimatedImageView *imgView = att.content;
                [self.imagesArr addObject:imgView.image];
                
                
                [self.imageUrlsArr addObject:@"http://www.baidu.com"];
            }
        }
    }];
    self.contentStr = [text stringByReplacingOccurrencesOfString:@"\U0000fffc\U0000fffc" withString:@"<我是图片>"];
    [Tool makeHtmlString:_imageUrlsArr desArr:_desArr contentStr:_contentStr];
}


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

    
    CGFloat scale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    /** 遍历选择的所有图片*/
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
        
        /** 获取图片*/
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:size
                                                  contentMode:PHImageContentModeDefault
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    /** 刷新*/
                                                    [self setupImage:result];
                                                }];
    }
}


#pragma mark YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView{
    if (textView.text.length > 100 && textView.tag != 1000) {
        textView.text = [textView.text substringToIndex:100];
    }
}

//防止输入图片描述的输入框被键盘遮挡
-(void)textViewDidBeginEditing:(YYTextView *)textView{
    if (textView.tag != 1000) {
        if ((textView.origin.y + 50) >(kScreenHeight - self.keyboardHeight)) {
            [self.contentTextView setContentOffset:CGPointMake(0, (textView.origin.y + 50) - (kScreenHeight - self.keyboardHeight)) animated:YES];
        }
    }
}



- (UIToolbar *)textViewBar {
    __weak typeof(self) weakSelf = self;

    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    // 空白格
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 关闭箭头
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 19, 11);
    [btn setImage:[UIImage imageNamed:@"icon_down2"] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [self.view endEditing:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    // 添加图片
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 20, 18);
    [btn1 setImage:[UIImage imageNamed:@"icon_addphoto"] forState:UIControlStateNormal];
    [btn1 bk_addEventHandler:^(id sender) {
        
        KSMediaPickerController *ctl = [KSMediaPickerController.alloc initWithMaxVideoItemCount:1 maxPictureItemCount:9];
        ctl.view.tag = 1;
        ctl.delegate = weakSelf;
        KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
        [weakSelf presentViewController:nav animated:YES completion:nil];
//
//        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    bar.items = @[left, space, right];
    return bar;
}
- (void)mediaPicker:(KSMediaPickerController *)mediaPicker didFinishSelected:(NSArray<KSMediaPickerOutputModel *> *)outputArray {
    [mediaPicker.navigationController dismissViewControllerAnimated:YES completion:nil];
    for (KSMediaPickerOutputModel * model in outputArray) {
        if (mediaPicker.view.tag == 1) {
            [self setupImage:model.image];
        }else{
            self.headerView.titleImgV.image = model.image;
        }
    }
}
- (UIToolbar *)titleFieldBar {
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    // 空白格
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 关闭箭头
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 19, 11);
    
    [btn setImage:[UIImage imageNamed:@"icon_down2"] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [self.view endEditing:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    bar.items = @[left, space];
    
    return bar;
}

-(TZImagePickerController *)imagePickerVc
{
    _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    _imagePickerVc.allowPickingOriginalPhoto = YES;
    _imagePickerVc.naviBgColor = [UIColor whiteColor];
    _imagePickerVc.naviTitleColor = [UIColor blueColor];
    _imagePickerVc.barItemTextColor = [UIColor blueColor];
//    _imagePickerVc.isStatusBarDefault = YES;
    _imagePickerVc.delegate = self;
    _imagePickerVc.allowTakePicture = NO;
    _imagePickerVc.allowPickingVideo = NO;
    _imagePickerVc.allowPickingGif = NO;
    return _imagePickerVc;
}

-(UIButton *)publishBtn
{
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBtn.bounds = CGRectMake(0, 0, 40, 44);
        [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_publishBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_publishBtn bk_addEventHandler:^(id sender) {
            [self clickToPublish];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

-(NSMutableArray *)imageUrlsArr{
    if (!_imageUrlsArr) {
        _imageUrlsArr = [NSMutableArray array];
    }
    return _imageUrlsArr;
}
-(NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}
-(NSMutableArray *)desArr{
    if (!_desArr) {
        _desArr = [NSMutableArray array];
    }
    return _desArr;
}
@end
