//
//  YXDingZhiPingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXDingZhiPingLunViewController.h"
#import "QMUITextView.h"
#import "HXPhotoPicker.h"
#import "QiniuLoad.h"
#import "XHStarRateView.h"
@interface YXDingZhiPingLunViewController ()<HXPhotoViewDelegate,XHStarRateViewDelegate>{
    NSInteger _starScore;
}
@property(nonatomic, strong) QMUITextView * qmuiTextView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) UIScrollView *scrollViewMenTou;
@property (strong, nonatomic) NSMutableArray *photoImageList;
@end

@implementation YXDingZhiPingLunViewController
- (IBAction)fabiaoAction:(id)sender {
    if (self.qmuiTextView.text.length == 0) {
        [QMUITips showInfo:@"请填写评论内容"];
        return;
    }
    
    //图片key的数组
    NSMutableArray * imageKeyArray = [[NSMutableArray alloc]init];
    for (NSString * key in self.photoImageList) {
        [imageKeyArray addObject:[key split:IMG_URI][1]];
    }
    NSString * imageKey = [imageKeyArray componentsJoinedByString:@","];
    NSDictionary * dic = @{
        @"business_id":kGetNSInteger([self.startDic[@"id"] integerValue]),
        @"grade":kGetNSInteger(_starScore),
        @"comment":self.qmuiTextView.text,
        @"publish_time":[ShareManager getNowTimeMiaoShu],
        @"photo_list":imageKey,
        @"price":self.xiaofeiTf.text,
        @"anonymity":self.nimingBtn.selected ? @"1" : @"0",
    };
    kWeakSelf(self);
    [YXPLUS_MANAGER addShopBusiness_commentSuccess:dic success:^(id object) {
        [QMUITips showSucceed:@"发表成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    _starScore = (NSInteger)currentScore;
    if (currentScore == 5) {
        self.starLbl.text = @"超赞";
    }else if (currentScore == 4){
        self.starLbl.text = @"满意";
    }else if (currentScore == 3){
        self.starLbl.text = @"一般";
    }else{
        self.starLbl.text = @"较差";
    }
}
-(BOOL)checkParamters{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIData];
    [self addStarView];
    [self addTextView];
    [self addUpLoadImgView];
    [self addSetNiMingBtn];
}
-(void)setUIData{
    self.fabuTitle.text = self.startDic[@"name"];
}
-(void)addSetNiMingBtn{
    [self.nimingBtn setImage:IMAGE_NAMED(@"shouhuo_unSel") forState:UIControlStateNormal];
    [self.nimingBtn setImage:IMAGE_NAMED(@"shouhuo_sel") forState:UIControlStateSelected];
}
-(void)addUpLoadImgView{
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-32, self.threeImgView.cb_Height)];
     [self.threeImgView addSubview:scrollView];
     self.scrollViewMenTou.userInteractionEnabled = NO;
     self.scrollViewMenTou = scrollView;
     
     CGFloat width = 276;
     HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
     photoView.frame = CGRectMake(0, 0, width, 0);
     photoView.lineCount = 3;
     photoView.delegate = self;
     photoView.spacing = 3;
     photoView.backgroundColor = [UIColor whiteColor];
     [scrollView addSubview:photoView];
     self.photoView = photoView;
    _photoImageList = [[NSMutableArray alloc]init];
}

-(HXPhotoManager *)manager{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.showDeleteNetworkPhotoAlert = NO;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.photoMaxNum = 3;
        _manager.configuration.imageMaxSize = 5;
    }
    return _manager;
}
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame{
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollViewMenTou.contentSize = CGSizeMake(KScreenWidth-32, self.threeImgView.cb_Height);
}
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    //如果是图片
    if (photos.count > 0) {
        kWeakSelf(self);
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
-(void)addStarView{
    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, self.starView.frame.size.width, self.starView.frame.size.height)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = WholeStar;
    starRateView.tag = 1;
    starRateView.currentScore = 5;
    starRateView.delegate = self;
    [self.starView addSubview:starRateView];
    
    _starScore = 5;
    self.starLbl.text = @"超赞";

}

-(void)addTextView{
    if (!self.qmuiTextView) {
        self.qmuiTextView = [[QMUITextView alloc] init];
    }
    self.qmuiTextView.frame = CGRectMake(0,0, KScreenWidth-20, self.detailView.qmui_height);
    self.qmuiTextView.backgroundColor = KClearColor;
    self.qmuiTextView.font = UIFontMake(15);
    self.qmuiTextView.placeholder = @"快分享你的体验，谈谈你的看法吧！";
    self.qmuiTextView.layer.cornerRadius = 8;
    self.qmuiTextView.clipsToBounds = YES;
    [self.detailView addSubview:self.qmuiTextView];
}
- (IBAction)backVcaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nimingAction:(id)sender {
    self.nimingBtn.selected = !self.nimingBtn.selected;
}
@end
