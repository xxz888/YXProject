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
@interface YXFaBuBaseViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,KSMediaPickerControllerDelegate>{
    UIImageView * _selectImageView;
    UIImage * zhanweiImage;
    NSMutableArray *_selectedAssets;
}
@property (nonatomic, strong) UICollectionView *yxCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic,readonly) QMUIModalPresentationViewController * modalNewViewController;
@end

@implementation YXFaBuBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextView];
    [self setOtherUI];
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
    if (self.model.tag.length  != 0) {
        self.tagArray = [NSMutableArray arrayWithArray:[self.model.tag split:@" "]];
           [self addNewTags];

       }
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
#pragma mark ==========  图片和视频返回的block ==========
- (void)mediaPicker:(KSMediaPickerController *)mediaPicker didFinishSelected:(NSArray<KSMediaPickerOutputModel *> *)outputArray {
    [mediaPicker.navigationController dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray * upLoadImageArray = [NSMutableArray array];
    kWeakSelf(self);
    
    for (KSMediaPickerOutputModel * model in outputArray) {
        [_selectedPhotos addObject:model];
        if (model.image) {
            [upLoadImageArray addObject:model.image];
        }else{
            
        }
    }
    [self.yxCollectionView reloadData];
    //如果数组为1,两种情况，1、视频 2、一张图片
    if (outputArray.count == 1) {
        KSMediaPickerOutputModel * model = outputArray[0];
        if (model.mediaType == PHAssetMediaTypeVideo) {
            self.fabuType = YES;
            UIImage * cover = [self getVideoPreViewImage:model.videoAsset.URL];
            [QiniuLoad uploadVideoToQNFilePath:model.videoAsset.URL success:^(NSString *reslut) {
                [weakself.photoImageList addObject:reslut];
                [weakself uploadImageQiNiuYun:[NSMutableArray arrayWithObject:cover]];
            } failure:^(NSString *error) {}];
        }else{
            self.fabuType = NO;
            [self uploadImageQiNiuYun:upLoadImageArray];
        }
    }else{
        self.fabuType = NO;
        [self uploadImageQiNiuYun:upLoadImageArray];
    }
}
-(void)uploadImageQiNiuYun:(NSMutableArray *)upLoadImageArray{
    kWeakSelf(self);
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [QMUITips showLoadingInView:self.view];
    [QiniuLoad uploadImageToQNFilePath:upLoadImageArray success:^(NSString *reslut) {
        [QMUITips hideAllTips];
        NSMutableArray * qiniuArray = [NSMutableArray arrayWithArray:[reslut split:@";"]];
        if (qiniuArray.count > 0) {
            if (weakself.fabuType) {
                weakself.videoCoverImageString = qiniuArray[0];
            }else{
                [weakself.photoImageList addObjectsFromArray:qiniuArray];
            }
        }
    } failure:^(NSString *error) {}];
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
    [self configCollectionView];
    
    self.topHeight.constant = kStatusBarHeight;
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
    [_modalNewViewController hideWithAnimated:YES completion:nil];
}

-(void)addNewTags{

    NSArray * titleArr = @[@""];
    NSArray *contentArr = @[_tagArray];
    CBGroupAndStreamView * silde = [[CBGroupAndStreamView alloc] initWithFrame:CGRectMake(0, 0,self.floatView.qmui_width, self.floatView.qmui_height)];
    silde.backgroundColor = KClearColor;
    silde.isSingle = YES;
    silde.radius = 4;
    silde.font = [UIFont systemFontOfSize:13];
    silde.titleTextFont = [UIFont systemFontOfSize:18];
    silde.backClolor = KWhiteColor;
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
    ViewBorderRadius(btn, 4, 1, KWhiteColor);
    [btn setTitleColor:[UIColor darkGrayColor] forState:0];
    [btn setTitle:@"添加" forState:0];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20];
    paragraphStyle.paragraphSpacing = 20;
    [contentView addSubview:btn];
    
    btn.frame = CGRectMake(contentViewPadding.left, CGRectGetMaxY(_xinhuatiTf.frame) + 20, contentLimitWidth/1.8, QMUIViewSelfSizingHeight);
    btn.centerX = _xinhuatiTf.centerX;
    contentView.frame = CGRectSetHeight(contentView.frame, CGRectGetMaxY(btn.frame) + contentViewPadding.bottom);
    [btn addTarget:self action:@selector(xinhuatiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
     _modalNewViewController = [[QMUIModalPresentationViewController alloc] init];
    _modalNewViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    _modalNewViewController.contentView = contentView;
    [_modalNewViewController showWithAnimated:YES completion:nil];
}
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
            if (model.thumb) {
                cell.imageView.image = model.thumb;
            }else{
                NSString * str1 = [(NSMutableString *)self.photoImageList[indexPath.row] replaceAll:@" " target:@"%20"];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
            }
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
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
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
