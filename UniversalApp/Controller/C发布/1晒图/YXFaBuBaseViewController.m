//
//  YXFaBuBaseViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//
#import "YXFaBuBaseViewController.h"
#import "JJImagePicker.h"
#import "TZTestCell.h"
#import "HXPhotoPicker.h"
#import "SDWebImageManager.h"
static const CGFloat kPhotoViewMargin = 0;
@interface YXFaBuBaseViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,HXPhotoViewDelegate>{
    UIImageView * _selectImageView;
    UIImage * zhanweiImage;
    NSMutableArray *_selectedAssets;
    CGFloat _tagHeight;
}
@property (nonatomic, strong) UICollectionView *yxCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollViewFaBu;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic,readonly) QMUIModalPresentationViewController * modalNewViewController;
@end
@implementation YXFaBuBaseViewController
-(HXPhotoManager *)manager{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.showDeleteNetworkPhotoAlert = NO;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 9;
        _manager.configuration.selectTogether = NO;
    }
    return _manager;
}
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.tagViewHeight.constant = 0;
    self.tagViewTopHeight.constant = 0;
    
    [self addTextView];
    [self setOtherUI];
    JQFMDB *db = [JQFMDB shareDatabase];
    if (![db jq_isExistTable:YX_USER_FaBuCaoGao]) {
        [db jq_createTable:YX_USER_FaBuCaoGao dicOrModel:[YXShaiTuModel class]];
    }
    //如果model有，说明1、是编辑界面进来的 2、是从草稿界面进来的
    if (_model) {
        [self faxianEditCome];
    }
}
- (void)addNetworkPhoto {
    if (self.manager.afterSelectPhotoCountIsMaximum) {
        [self.view showImageHUDText:@"图片已达到最大数"];
        return;
    }
    [self.photoView refreshView];
}
#pragma -----------------上传完图片和视频的回调方法-----------------
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    if (allList.count > 0) {
        //判断是不是编辑或者草稿进来的
        kWeakSelf(self);
        //如果是视频
           if (videos.count > 0) {
               [QMUITips showLoadingInView:self.view];
               [self.toolManager writeSelectModelListToTempPathWithList:videos requestType:0 success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
                     //上传七牛云视频
                     [QiniuLoad uploadVideoToQNFilePath:videoURL[0] success:^(NSString *reslut) {
                         [weakself.photoImageList addObject:reslut];
                     } failure:^(NSString *error) {[QMUITips hideAllTips];}];
                       //上传完视频，再上传封面图片
                       [weakself.toolManager getSelectedImageList:videos success:^(NSArray<UIImage *> *imageList) {
                           //上传七牛云图片
                           [QiniuLoad uploadImageToQNFilePath:imageList success:^(NSString *reslut) {
                               [QMUITips hideAllTips];
                               NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                               weakself.videoCoverImageString = qiniuArray[0];
                           } failure:^(NSString *error) {[QMUITips hideAllTips];}];
                       } failed:^{ [QMUITips hideAllTips];}];
                 } failed:^{[QMUITips hideAllTips];}];
           }
        //如果是图片
           if (photos.count > 0) {
               [QMUITips showLoadingInView:self.view];
                [self.toolManager getSelectedImageList:photos success:^(NSArray<UIImage *> *imageList) {
                     //上传七牛云图片
                     [QiniuLoad uploadImageToQNFilePath:imageList success:^(NSString *reslut) {
                          [QMUITips hideAllTips];
                          [weakself.photoImageList removeAllObjects];
                          NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                          if (qiniuArray.count > 0) {
                            [weakself.photoImageList addObjectsFromArray:qiniuArray];
                          }
                      } failure:^(NSString *error) {[QMUITips hideAllTips];}];
                 } failed:^{[QMUITips hideAllTips];}];
           }
    }
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame{
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollViewFaBu.contentSize = CGSizeMake(KScreenWidth-32, CGRectGetMaxY(frame) + kPhotoViewMargin);
    self.threeViewHeight.constant = frame.size.height < 100 ? 100 : 150;
    [self.scrollViewFaBu setSize:CGSizeMake(KScreenWidth-32,self.threeViewHeight.constant)];

}
//如果是从发现界面编辑进来的
-(void)faxianEditCome{
    //标签
    if (self.model.tag.length  != 0) {
        self.tagArray = [NSMutableArray arrayWithArray:[self.model.tag split:@" "]];
        [self addNewTags];
    }
    //地点
    self.locationString = [self.model.publish_site isEqualToString:@""] ? @"获取地理位置" :  self.model.publish_site;
    [self.locationBtn setTitle:self.locationString forState:UIControlStateNormal];
    [self.photoImageList removeAllObjects];
    for (NSString * imgString in [self.model.photo_list split:@","]) {
        [self.photoImageList addObject:[IMG_URI append:imgString]];
    }
    //有默认的图片的话，就显示出来
      [self.manager addNetworkingImageToAlbum:self.photoImageList selected:YES];
      [self.photoView refreshView];
    //封面
    self.videoCoverImageString = @"";
    //内容
    self.qmuiTextView.text = self.model.detail;
    //类型
    self.fabuType = NO;
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
    NSString * cover = [self.videoCoverImageString contains:IMG_URI] ? [self.videoCoverImageString split:IMG_URI][1]:self.videoCoverImageString;
    [dic setValue:cover forKey:@"cover"];
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
            NSDictionary * userInfo = userManager.loadUserAllInfo;
            NSString * userId = kGetString(userInfo[@"id"]);
            NSString * key = [NSString stringWithFormat:@"%@%@",userId,[ShareManager getNowTimeTimestamp3]];
            JQFMDB *db = [JQFMDB shareDatabase];
            YXShaiTuModel * model = [[YXShaiTuModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
             model.coustomId =  key;
            [db jq_inDatabase:^{
                [db jq_insertTable:YX_USER_FaBuCaoGao dicOrModel:model];
            }];
            if (weakself.model.coustomId && ![weakself.model.coustomId isEqualToString:@""]) {
                JQFMDB *db = [JQFMDB shareDatabase];
                NSString * sql = [@"WHERE coustomId = " append:kGetString(weakself.model.coustomId)];
                [db jq_deleteTable:YX_USER_FaBuCaoGao whereFormat:sql];
            }
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
        [QMUITips showSucceed:@"发布成功"];
        [weakself closeViewAAA];
        if (weakself.model.coustomId && ![weakself.model.coustomId isEqualToString:@""]) {
            JQFMDB *db = [JQFMDB shareDatabase];
            NSString * sql = [@"WHERE coustomId = " append:kGetString(weakself.model.coustomId)];
            [db jq_deleteTable:YX_USER_FaBuCaoGao whereFormat:sql];
        }
    }];
}
-(void)closeViewAAA{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSecondVC" object:nil];
    [self closeViewBBB];
}
-(void)closeViewBBB{
    UIViewController *controller = self;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:YES completion:^{}];
}
-(void)setOtherUI{
    self.tagArray = [NSMutableArray array];
    self.photoImageList = [[NSMutableArray alloc]init];
    _locationString = self.locationBtn.titleLabel.text;
    //1. 初始化轻扫手势对象, 并设置轻扫时触发的方法
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    //2. 轻扫方向( | :表示两个方向都可以)
    //#轻扫手势的默认轻扫方向是向右的, 若需要向左扫描时也能触发向右的扫描方法, 需要指定扫描方向为以下属性:
    swipe.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft |UISwipeGestureRecognizerDirectionUp |UISwipeGestureRecognizerDirectionDown;
    //3. 添加手势到view对象上
    [self.view addGestureRecognizer:swipe];
    
    self.videoCoverImageString=@"";
    _selectedPhotos = [NSMutableArray array];
    
    self.topHeight.constant = kStatusBarHeight;
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-32, self.threeViewHeight.constant)];
    [self.threeImageView addSubview:scrollView];
    self.scrollViewFaBu.userInteractionEnabled = NO;
    self.scrollViewFaBu = scrollView;
    
    CGFloat width = KScreenWidth-32;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0);
    photoView.lineCount = 5;
    photoView.delegate = self;
    photoView.spacing = 5;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    ViewRadius(self.fabuBtn, 14);
    ViewBorderRadius(self.cunCaoGaoBtn, 14, 0.5, COLOR_999999);
    
    self.toTopHeight.constant = STATUS_BAR_HEIGHT + 10;
}
- (void)swipeAction: (UITapGestureRecognizer *)gesture{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)addTextView{
    if (!self.qmuiTextView) {
        self.qmuiTextView = [[QMUITextView alloc] init];
    }
    self.qmuiTextView.frame = CGRectMake(0,0, KScreenWidth-20, self.detailView.qmui_height);
    self.qmuiTextView.backgroundColor = KClearColor;
    self.qmuiTextView.font = UIFontMake(15);
    self.qmuiTextView.placeholder = @"写点什么...";
    self.qmuiTextView.layer.cornerRadius = 8;
    self.qmuiTextView.clipsToBounds = YES;
    [self.qmuiTextView becomeFirstResponder];
    [self.detailView addSubview:self.qmuiTextView];
}
- (IBAction)fabuAction:(UIButton *)btn{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self commonAction:self.photoImageList btn:btn];
}
- (IBAction)locationBtnAction:(id)sender{
    kWeakSelf(self);
    YXGaoDeMapViewController * VC = [[YXGaoDeMapViewController alloc]init];
    VC.block = ^(NSString * locationString) {
        _locationString = locationString;
        if ([locationString isEqualToString:@""]) {
            [weakself.locationBtn setTitle:@"获取地理位置" forState:0];
        }else{
            [weakself.locationBtn setTitle:locationString forState:0];
        }
        [weakself dismissViewControllerAnimated:YES completion:nil];
    };
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
    [weakself presentViewController:nav animated:YES completion:nil];
}
- (IBAction)xinhuatiAction:(id)sender{
//    [self pushNewHuaTi];
}
- (IBAction)moreAction:(id)sender{
    kWeakSelf(self);
    YXPublishMoreTagsViewController * VC = [[YXPublishMoreTagsViewController alloc]init];
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
    VC.tagBlock = ^(NSDictionary * dic) {
        [weakself.tagArray addObject:[@"#" append:dic[@"tag"]]];
//        if (weakself.menueView) {
//            [weakself.menueView setContentView:@[weakself.tagArray] titleArr:@[]];
//        }else{
            [weakself addNewTags];
//        }
        self.tagViewHeight.constant = [self cellTagViewHeight];
    };
    [weakself presentViewController:nav animated:YES completion:nil];
}
-(void)xinhuatiButtonAction:(UIButton *)btn{
    if ([_xinhuatiTf.text isEqualToString:@""]) {
        return;
    }
    [_tagArray addObject:[_xinhuatiTf.text concate:@"#"]];
//    if (self.menueView) {
//        [_menueView setContentView:@[_tagArray] titleArr:@[]];
//    }else{
        [self addNewTags];
//    }
    [_modalNewViewController hideWithAnimated:YES completion:nil];
    self.tagViewHeight.constant = [self cellTagViewHeight];
}
//计算标签高度
-(CGFloat)cellTagViewHeight{
    if ([self.tagArray count] == 0) {return 0;}
    CBGroupAndStreamView * cb = [[CBGroupAndStreamView alloc] init];
    cb.hidden = YES;cb.frame = CGRectMake(0, 0, KScreenWidth-34-10, 0);
    cb.isSingle = YES;cb.radius = 4;cb.butHeight = 32;cb.font = [UIFont systemFontOfSize:12];
    cb.titleTextFont = [UIFont systemFontOfSize:12];
    [cb setContentView:@[self.tagArray] titleArr:@[@""]];
    self.tagViewTopHeight.constant = -15;
    return  cb.allViewHeight;
}
-(void)addNewTags{
    NSArray * titleArr = @[@""];
    NSArray *contentArr = @[_tagArray];
    [self.floatView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.tagViewHeight.constant = [self cellTagViewHeight];
    CBGroupAndStreamView * silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0,self.floatView.qmui_width, [self cellTagViewHeight])];
    [self.floatView addSubview:silde];
    silde.backgroundColor = KWhiteColor;
    silde.isSingle = YES;
    silde.radius = 4;
    silde.butHeight = 32;
    silde.font = [UIFont systemFontOfSize:14];
    silde.titleTextFont = [UIFont systemFontOfSize:14];
    silde.scroller.scrollEnabled = NO;
    silde.contentNorColor  = SEGMENT_COLOR;
    silde.contentSelColor = SEGMENT_COLOR;
    silde.backClolor = kRGBA(245, 245, 245, 1);
    [silde setContentView:contentArr titleArr:titleArr];
    _menueView = silde;
    kWeakSelf(self);
    silde.cb_selectCurrentValueBlock = ^(NSString *value, NSInteger index, NSInteger groupId) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:weakself.tagArray];
        [array removeObjectAtIndex:index];
        [weakself.tagArray removeAllObjects];
        [weakself.tagArray addObjectsFromArray:array];
        [weakself.menueView setContentView:@[weakself.tagArray] titleArr:@[]];
        [weakself addNewTags];
        weakself.tagViewHeight.constant = [weakself cellTagViewHeight];
    };
}
//-(void)pushNewHuaTi{
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
//    contentView.backgroundColor = UIColorWhite;
//    contentView.layer.cornerRadius = 6;
//
//    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(50, 20, 30, 20);
//    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
//
//    _xinhuatiTf = [[QMUITextField alloc] initWithFrame:CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, 36)];
//    _xinhuatiTf.placeholder = @"请输入新话题";
//    _xinhuatiTf.borderStyle = UITextBorderStyleRoundedRect;
//    _xinhuatiTf.font = UIFontMake(16);
//    _xinhuatiTf.delegate = self;
//    [contentView addSubview:_xinhuatiTf];
//    [_xinhuatiTf becomeFirstResponder];
//
//    UIButton *btn = [UIButton buttonWithType:0];
//    ViewBorderRadius(btn, 4, 1, KWhiteColor);
//    [btn setTitleColor:[UIColor darkGrayColor] forState:0];
//    [btn setTitle:@"添加" forState:0];
//    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20];
//    paragraphStyle.paragraphSpacing = 20;
//    [contentView addSubview:btn];
//
//    btn.frame = CGRectMake(contentViewPadding.left, CGRectGetMaxY(_xinhuatiTf.frame) + 20, contentLimitWidth/1.8, QMUIViewSelfSizingHeight);
//    btn.centerX = _xinhuatiTf.centerX;
//    contentView.frame = CGRectSetHeight(contentView.frame, CGRectGetMaxY(btn.frame) + contentViewPadding.bottom);
//    [btn addTarget:self action:@selector(xinhuatiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//
//
//     _modalNewViewController = [[QMUIModalPresentationViewController alloc] init];
//    _modalNewViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
//    _modalNewViewController.contentView = contentView;
//    [_modalNewViewController showWithAnimated:YES completion:nil];
//}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
- (IBAction)closeViewAction:(id)sender {
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
