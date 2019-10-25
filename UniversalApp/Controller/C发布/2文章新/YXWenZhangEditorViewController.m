//
//  YXWenZhangEditorViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/22.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXWenZhangEditorViewController.h"
#import "WGCommon.h"
#import "HXPhotoPicker.h"
#import "HXAlbumListViewController.h"
@import JavaScriptCore;
#define kEditorURL @"richText_editor"
#import "YXWenZhangView.h"
#import "QiniuLoad.h"
@interface YXWenZhangEditorViewController ()<UITextViewDelegate,UIWebViewDelegate,KWEditorBarDelegate,KWFontStyleBarDelegate,HXAlbumListViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,assign) BOOL isExitView;

@property (nonatomic,copy) NSString *tempArticleID;

@property (nonatomic,copy) NSString *tempTitle;
@property (nonatomic,copy) NSString *tempContent;

@property (nonatomic,assign) BOOL isLoadFinsh;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) KWEditorBar *toolBarView;
@property (nonatomic,strong) KWFontStyleBar *fontBar;
@property (nonatomic,strong) HXPhotoManager *manager;
@property (nonatomic,strong) HXPhotoView *photoView;

@property (nonatomic,assign) BOOL showHtml;
@property (nonatomic, strong) YXWenZhangView * headerView;
@property (nonatomic, strong) NSString * cover;


/**
 *  存放所有正在上传及失败的图片model
 */
@property (nonatomic,strong) NSMutableArray *uploadPics;

@end

@implementation YXWenZhangEditorViewController
- (IBAction)backVcAction:(id)sender {
    
    if (self.closeNewVcblock) {
        self.closeNewVcblock();
    }
}
- (IBAction)fabuAction:(id)sender {
     NSLog(@"%@",[self.webView contentHtmlText]);
     NSLog(@"%@",[self.webView titleText]);
    
    
    
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        //post_id 修改传，发布传空
        [dic setValue:@"" forKey:@"post_id"];
        //title 标题 晒图不传
        [dic setValue:[self.webView titleText] forKey:@"title"];
        //封面
        [dic setValue:self.cover forKey:@"cover"];
        //detail 详情
        [dic setValue:[self.webView contentHtmlText] forKey:@"detail"];
        //拼接photo_list
        [dic setValue:@"" forKey:@"photo_list"];
    //    NSString * photo_list = [imgArray componentsJoinedByString:@","];
    //    photo_list = [photo_list replaceAll:kQNinterface target:@""];
    //    [dic setValue:photo_list forKey:@"photo_list"];
        //obj 1晒图 2文章
        [dic setValue:@"2" forKey:@"obj"];
        //tag 标签
        [dic setValue:@"" forKey:@"tag"];
    //    self.tagArray.count == 0 ?
    //    [dic setValue:@"" forKey:@"tag"] : [dic setValue:[self.tagArray componentsJoinedByString:@" "] forKey:@"tag"];
        //publish_site 地点
        [dic setValue:@"" forKey:@"publish_site"];
    //    NSString * publish_site = [self.locationString isEqualToString:@"获取地理位置"] ? @"" : self.locationString;
    //    [dic setValue:publish_site forKey:@"publish_site"];
        
        kWeakSelf(self);
        [YX_MANAGER requestFaBuImagePOST:dic success:^(id object) {
            [QMUITips hideAllTipsInView:weakself.view];
            [QMUITips showSucceed:object[@"message"] inView:[ShareManager getMainView] hideAfterDelay:1];
            if (weakself.closeNewVcblock) {
                   weakself.closeNewVcblock();
               }
        }];
}

- (NSMutableArray *)uploadPics{
    if (!_uploadPics) {
        _uploadPics = [NSMutableArray array];
    }
    return _uploadPics;
}
- (KWEditorBar *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [KWEditorBar editorBar];
        _toolBarView.frame = CGRectMake(0,SCREEN_HEIGHT - KWEditorBar_Height+1, self.view.frame.size.width, KWEditorBar_Height);
        _toolBarView.backgroundColor = kRGBA(237, 237, 237, 1);
    }
    return _toolBarView;
}
- (KWFontStyleBar *)fontBar{
    if (!_fontBar) {
        _fontBar = [[KWFontStyleBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame) - KWFontBar_Height - KWEditorBar_Height, self.view.frame.size.width, KWFontBar_Height)];
        _fontBar.delegate = self;
        [_fontBar.heading2Item setSelected:YES];
        
    }
    return _fontBar;
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:kEditorURL                                                              ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                            encoding:NSUTF8StringEncoding
                                                           error:nil];
        [_webView loadHTMLString:htmlCont baseURL:baseURL];
        _webView.scrollView.bounces=NO;
        _webView.hidesInputAccessoryView = YES;
//        _webView.detectsPhoneNumbers = NO;
        
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = KWhiteColor;
    /// config
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolBarView];
    _webView.scrollView.bounces = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.toolBarView.delegate = self;
    [self.toolBarView addObserver:self forKeyPath:@"transform" options:
     NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.contentInset= UIEdgeInsetsMake(176,0,0,0);
    [self addCoverImage];
}
-(void)addCoverImage{
    
    // 这里也是关键
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, -176,KScreenWidth,176)];
    view.backgroundColor = KWhiteColor;
    
    UIImageView * coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 160)];
    coverImage.tag = 1001;
    coverImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickImage)];
    [coverImage addGestureRecognizer:singleTap];
    coverImage.backgroundColor = KWhiteColor;
    [view addSubview:coverImage];
    
    UIImageView * zhanweiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 34)];
    zhanweiImage.tag = 1002;

    zhanweiImage.userInteractionEnabled = NO;
    CGFloat x = coverImage.center.x;
    CGFloat y = coverImage.center.y - 5;
    zhanweiImage.center = CGPointMake(x, y);
    zhanweiImage.image = [UIImage imageNamed:@"fabuwenzhangxiangji"];
    [view addSubview:zhanweiImage];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, KScreenWidth, 16)];
    bottomView.backgroundColor = kRGBA(245, 245, 245, 1);
    [view addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc] init];
    label.tag = 1003;
    label.userInteractionEnabled = NO;
    label.frame = CGRectMake((KScreenWidth-56)/2,91,100,20);
    label.numberOfLines = 0;
    CGFloat x1 = coverImage.center.x;
    CGFloat y1 = coverImage.center.y + 25;
    label.center = CGPointMake(x1, y1);
    [view addSubview:label];
    
    label.text = @"添加照片";
    label.font = [UIFont systemFontOfSize:14 weight:600];
    label.textColor = SEGMENT_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.alpha = 1.0;
    // 把自定义的view添加到webView的scrollView上面!!!
    [self.webView.scrollView addSubview:view];
    //去掉黑色框框
    // -100是自己瞎写的,根据不同情况设定,黑框越大,这个数就越小!是负数的小!!

}
-(void)whenClickImage{
    [self showPhotos:YES];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"transform"]){
        
        CGRect fontBarFrame = self.fontBar.frame;
        fontBarFrame.origin.y = CGRectGetMaxY(self.toolBarView.frame)- KWFontBar_Height - KWEditorBar_Height;
        self.fontBar.frame = fontBarFrame;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.webView.frame = CGRectMake(0,44+k_status_height, self.view.frame.size.width,self.view.frame.size.height - KWEditorBar_Height - 44-k_status_height);
    
}



#pragma mark -webviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    JSContext *ctx = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"contentUpdateCallback"] = ^(JSValue *msg) {
        [self.webView autoScrollTop:[self.webView getCaretYPosition]];
    };
    [ctx evaluateScript:@"document.getElementById('article_content').addEventListener('input', contentUpdateCallback, false);"];
    
//    [self.webView setupContent:@""];
//    [self.webView setupContentDisable:NO];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"NSError = %@",error);

    if([error code] == NSURLErrorCancelled){
        return;
    }
}
//获取IMG标签
-(NSArray*)getImgTags:(NSString *)htmlText
{
    if (htmlText == nil) {
        return nil;
    }
    NSError *error;
    NSString *regulaStr = @"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:htmlText options:0 range:NSMakeRange(0, [htmlText length])];
    
    return arrayOfAllMatches;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"loadURL = %@",urlString);
    
    [self handleEvent:urlString];
    
    if ([urlString rangeOfString:@"re-state-content://"].location != NSNotFound) {
        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"re-state-content://" withString:@""];
        
        [self.fontBar updateFontBarWithButtonName:className];
        
        if ([self.webView contentText].length <= 0) {
            [self.webView showContentPlaceholder];
            if ([self getImgTags:[self.webView contentHtmlText]].count > 0) {
                [self.webView clearContentPlaceholder];
            }
        }else{
            [self.webView clearContentPlaceholder];
        }
        
        if ([[className componentsSeparatedByString:@","] containsObject:@"unorderedList"]) {
            [self.webView clearContentPlaceholder];
        }
        
        
    }
    
    [self handleWithString:urlString];
    return YES;
}
#pragma mar - webView监听处理事件
- (void)handleEvent:(NSString *)urlString{
    if ([urlString hasPrefix:@"re-state-content://"]) {
        self.fontBar.hidden = NO;
        self.toolBarView.hidden = NO;
//        if ([self.webView contentText].length <= 0) {
//            [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
    }
    
    if ([urlString hasPrefix:@"re-state-title://"]) {
        self.fontBar.hidden = YES;
        self.toolBarView.hidden = YES;
    }
    
}


- (void)dealloc{
    @try {
        [self.toolBarView removeObserver:self forKeyPath:@"transform"];
    } @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
    } @finally {
        // Added to show finally works as well
    }
    self.timer = nil;
}


/**
 *  是否显示占位文字
 */
- (void)isShowPlaceholder{
    if ([self.webView contentText].length <= 0)
    {
        [self.webView showContentPlaceholder];
    }else{
        [self.webView clearContentPlaceholder];
    }
}

#pragma mark -editorbarDelegate
- (void)editorBar:(KWEditorBar *)editorBar didClickIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //显示或隐藏键盘
            if (self.toolBarView.transform.ty < 0) {
                [self.webView hiddenKeyboard];
            }else{
                [self.webView showKeyboardContent];
            }
            
        }
            break;
        case 1:{
            //回退
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('undo')"];
        }
            break;
        case 2:{
               [self.webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('redo')"];
        }
            break;
        case 3:{
            //显示更多区域
            editorBar.fontButton.selected = !editorBar.fontButton.selected;
            if (editorBar.fontButton.selected) {
                [self.view addSubview:self.fontBar];
            }else{
                [self.fontBar removeFromSuperview];
            }
        }
            break;
        case 5:{
            //插入图片
            if (!self.toolBarView.keyboardButton.selected) {
                [self.webView showKeyboardContent];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showPhotos:NO];
                });
            }else{
                [self showPhotos:NO];
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - fontbardelegate
- (void)fontBar:(KWFontStyleBar *)fontBar didClickBtn:(UIButton *)button{
    if (self.toolBarView.transform.ty>=0) {
        [self.webView showKeyboardContent];
    }
    switch (button.tag) {
        case 0:{
            //粗体
            [self.webView bold];
        }
            break;
        case 1:{//下划线
            [self.webView underline];
        }
            break;
        case 2:{//斜体
            [self.webView italic];
        }
            break;
        case 3:{//14号字体
            [self.webView setFontSize:@"2"];
        }
            break;
        case 4:{//16号字体
            [self.webView setFontSize:@"3"];
        }
            break;
        case 5:{//18号字体
            [self.webView setFontSize:@"4"];
        }
            break;
        case 6:{//左对齐
            [self.webView justifyLeft];
        }
            break;
        case 7:{//居中对齐
            [self.webView justifyCenter];
        }
            break;
        case 8:{//右对齐
            [self.webView justifyRight];
        }
            break;
        case 9:{//无序
            [self.webView unorderlist];
        }
            break;
        case 10:{
            //缩进
            button.selected = !button.selected;
            if (button.selected) {
                [self.webView indent];
            }else{
                [self.webView outdent];
            }
        }
            break;
        case 11:{
            
        }
            break;
        default:
            break;
    }
    
}
- (void)fontBarResetNormalFontSize{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView normalFontSize];
    });
}



#pragma mark -keyboard
- (void)keyBoardWillChangeFrame:(NSNotification*)notification{
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.transform =  CGAffineTransformIdentity;
            self.toolBarView.keyboardButton.selected = NO;
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
            self.toolBarView.keyboardButton.selected = YES;
            
        }];
    }
}


#pragma mark -上传图片
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    kWeakSelf(self);
    [self.manager clearSelectedList];
 
    if (photoList.count > 0) {
        for (int i = 0; i<photoList.count; i++) {
            HXPhotoModel *picM = photoList[i];
            WGUploadPictureModel *uploadM = [[WGUploadPictureModel alloc] init];
            uploadM.image = picM.thumbPhoto;
            uploadM.key = [NSString uuid];
            uploadM.imageData = UIImageJPEGRepresentation(picM.thumbPhoto,1.0f);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (albumListViewController.isCoverImgBool) {
                    [QiniuLoad uploadImageToQNFilePath:@[uploadM.image] success:^(NSString *reslut) {
                            NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                            //3、上传成功替换返回的网络地址图片
                        UIImageView * coverImage = [weakself.webView.scrollView viewWithTag:1001];
                        UIImageView * zhanweiImage = [weakself.webView.scrollView viewWithTag:1002];
                        UILabel * zhanweilbl = [weakself.webView.scrollView viewWithTag:1003];
                        NSString * string = [(NSMutableString *)qiniuArray[0] replaceAll:@" " target:@"%20"];
                        [coverImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"img_moren"]];
                        zhanweiImage.hidden = zhanweilbl.hidden = YES;
                        weakself.cover = [string split:IMG_URI][1];
                   } failure:^(NSString *error) {}];
                }else{
                    //1、插入本地图片
                     [weakself.webView inserImage:uploadM.imageData key:uploadM.key];
                     //2、模拟网络请求上传图片 更新进度
                     [weakself.webView inserImageKey:uploadM.key progress:0.5];
                     [QiniuLoad uploadImageToQNFilePath:@[uploadM.image] success:^(NSString *reslut) {
                     [weakself.webView inserImageKey:uploadM.key progress:1];
                           NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                           //3、上传成功替换返回的网络地址图片
                            [weakself.webView inserSuccessImageKey:uploadM.key imgUrl:qiniuArray[0]];
                            uploadM.type = WGUploadImageModelTypeError;
                            if ([weakself.uploadPics containsObject:uploadM]) {
                                [weakself.uploadPics removeObject:uploadM];
                            }
                     } failure:^(NSString *error) {}];
                }
         
                
                
                
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.webView inserImageKey:uploadM.key progress:1];
////                    BOOL error = false; //上传成功样式
//
//                    BOOL error = false; //上传失败样式
//                    if (!error) {
//                        //3、上传成功替换返回的网络地址图片
//                        [self.webView inserSuccessImageKey:uploadM.key imgUrl:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=4278445236,4070967445&fm=173&app=25&f=JPEG?w=218&h=146&s=B1145A915E28110D18B9A940030080B2"];
//
//                        uploadM.type = WGUploadImageModelTypeError;
//
//                        if ([self.uploadPics containsObject:uploadM]) {
//                            [self.uploadPics removeObject:uploadM];
//                        }
//                    }else{
//                        //3、上传失败 显示失败的样式
//                        [self.webView uploadErrorKey:uploadM.key];
//
//                        uploadM.type = WGUploadImageModelTypeError;
//
//                        [self.uploadPics addObject:uploadM];
//                    }
//
//                });
//
                
            });
        }
        
    }
    
}

#pragma mark -图片点击操作
- (BOOL)handleWithString:(NSString *)urlString{
    
    //点击的图片标记URL（自定义）
    NSString *preStr = @"protocol://iOS?code=uploadResult&data=";
    
    if ([urlString hasPrefix:preStr]) {
        NSString *result = [urlString stringByReplacingOccurrencesOfString:preStr withString:@" "];
        
        NSString *jsonString = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

        NSString *meg = [NSString stringWithFormat:@"上传的图片ID为%@",dict[@"imgId"]];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:meg message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
        //上传状态 - 默认上传成功
        BOOL uploadState = YES;
        
        for (WGUploadPictureModel *upPic in self.uploadPics) {
            if (upPic.type == WGUploadImageModelTypeError) {
                //上传失败的
                uploadState = false;
            }
        }
        
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:uploadState?@"删除图片":@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //根据自身业务需要处理图片操作：如删除、重新上传图片操作等
            if (uploadState) {
                //例如删除图片执行函数imgID=key;
                [self.webView deleteImageKey:dict[@"imgId"]];
            }else{
                //见387行代码 上传片段 。。。
            }
        }];
        UIAlertAction *ok1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
              }];
        [alert addAction:ok];
        [alert addAction:ok1];

        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark -图片选择器
- (void)showPhotos:(BOOL)isCoverImg{
    HXAlbumListViewController *vc = [[HXAlbumListViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    vc.isCoverImgBool = isCoverImg;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
    nav.supportRotation = self.manager.configuration.supportRotation;
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.toolBarTitleColor = kRGBA(33,189,109,1);
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.imageMaxSize = 5;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.rowCount = 4;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.singleJumpEdit = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.supportRotation = NO;
        _manager.configuration.hideOriginalBtn = NO;
    _manager.configuration.navigationTitleColor = [UIColor blackColor];
    _manager.configuration.showDateSectionHeader =NO;
        _manager.configuration.singleSelected = NO;
    }
    return _manager;
}

@end
