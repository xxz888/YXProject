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
#import "UniversalApp-Swift.h"
@interface YXFaBuBaseViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,KSMediaPickerControllerDelegate>{
    UIImageView * _selectImageView;
    UIImage * zhanweiImage;
    NSMutableArray *_selectedAssets;
}
@property (nonatomic, strong) UICollectionView *yxCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation YXFaBuBaseViewController

#pragma mark ==========  图片和视频返回的block ==========
- (void)mediaPicker:(KSMediaPickerController *)mediaPicker didFinishSelected:(NSArray<KSMediaPickerOutputModel *> *)outputArray {
    [mediaPicker.navigationController dismissViewControllerAnimated:YES completion:nil];
    for (KSMediaPickerOutputModel * model in outputArray) {
        [_selectedPhotos addObject:model];
    }
    [self.yxCollectionView reloadData];
    
    
    
    //这一步开始上传
    kWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        for (NSInteger i = 0; i < [outputArray count]; i++) {
            KSMediaPickerOutputModel * model = outputArray[i];
                if (model.mediaType == PHAssetMediaTypeVideo) {
                    weakself.fabuType = YES;
                [QiniuLoad uploadVideoToQNFilePath:model.videoAsset.URL success:^(NSString *reslut) {
                    [weakself.photoImageList addObject:reslut];
                    dispatch_semaphore_signal(sema);
                } failure:^(NSString *error) {}];
                    
                UIImage * cover = [weakself getVideoPreViewImage:model.videoAsset.URL];
                //先上传到七牛云图片  再提交服务器
                [QiniuLoad uploadImageToQNFilePath:@[cover] success:^(NSString *reslut) {
                    NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                    if (qiniuArray.count > 0) {
                        weakself.videoCoverImageString = qiniuArray[0];
                    }
                    dispatch_semaphore_signal(sema);
                } failure:^(NSString *error) {}];
            }else{
                weakself.fabuType = NO;
                //先上传到七牛云图片  再提交服务器
                [QiniuLoad uploadImageToQNFilePath:@[model.image] success:^(NSString *reslut) {
                    NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
                    if (qiniuArray.count > 0) {
                        [weakself.photoImageList addObject:qiniuArray[0]];
                    }
                    dispatch_semaphore_signal(sema);
                } failure:^(NSString *error) {}];
            }
         
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    });
}

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
    //1. 初始化轻扫手势对象, 并设置轻扫时触发的方法
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    //2. 轻扫方向( | :表示两个方向都可以)
    //#轻扫手势的默认轻扫方向是向右的, 若需要向左扫描时也能触发向右的扫描方法, 需要指定扫描方向为以下属性:
    swipe.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft |UISwipeGestureRecognizerDirectionUp |UISwipeGestureRecognizerDirectionDown;
    //3. 添加手势到view对象上
    [self.view addGestureRecognizer:swipe];
    
    self.videoCoverImageString=@"";
    _selectedPhotos = [NSMutableArray array];
    [self configCollectionView];
}
- (void)swipeAction: (UITapGestureRecognizer *)gesture{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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

- (IBAction)fabuAction:(UIButton *)btn{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
    [self pushNewHuaTi];
}
- (IBAction)moreAction:(id)sender{

    kWeakSelf(self);
    YXPublishMoreTagsViewController * VC = [[YXPublishMoreTagsViewController alloc]init];
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:VC];
    VC.tagBlock = ^(NSDictionary * dic) {
        [weakself.tagArray addObject:[@"#" append:dic[@"tag"]]];
        if (weakself.menueView) {
            [weakself.menueView setContentView:@[weakself.tagArray] titleArr:@[]];
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
        [weakself.menueView setContentView:@[weakself.tagArray] titleArr:@[]];
        [weakself addNewTags];


        
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
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}












- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _yxCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _yxCollectionView.showsVerticalScrollIndicator = _yxCollectionView.showsHorizontalScrollIndicator = NO;
    _yxCollectionView.backgroundColor = KWhiteColor;
    _yxCollectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _yxCollectionView.dataSource = self;
    _yxCollectionView.delegate = self;
    _yxCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _yxCollectionView.contentSize = CGSizeMake(kScreenWidth-20, 0);
    [self.threeImageView addSubview:_yxCollectionView];
    [_yxCollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _layout.itemSize = CGSizeMake(90, 90);
    _layout.minimumInteritemSpacing = 10;
    _layout.minimumLineSpacing = 10;
    [_yxCollectionView setCollectionViewLayout:_layout];
    _yxCollectionView.frame = CGRectMake(-7, 0, kScreenWidth -20,100);
}
#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= 9) {
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        KSMediaPickerOutputModel * model = _selectedPhotos[indexPath.item];
        if (model.mediaType == mediaTypeVideo) {
            cell.imageView.image = model.thumb;
            cell.videoImageView.hidden = NO;
        }else{
            cell.imageView.image = model.thumb;
        }
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) {
        /// 两个参数都请不要传0，因为没处理单媒体类型录影和拍照的问题
        if (_selectedPhotos.count == 1 && self.fabuType) {
            [QMUITips showInfo:@"只能上传一个视频!" inView:self.view hideAfterDelay:2];
            return;
        }
        KSMediaPickerController *ctl = [KSMediaPickerController.alloc initWithMaxVideoItemCount:1 maxPictureItemCount:9];
        ctl.delegate = self;
        KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
        [self presentViewController:nav animated:YES completion:nil];
        
    } else { // preview photos or video / 预览照片或者视频
      
    }
}
#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_yxCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_yxCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_yxCollectionView reloadData];
    }];
}



// 获取视频第一帧
- (UIImage*)getVideoPreViewImage:(NSURL *)path{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
@end
