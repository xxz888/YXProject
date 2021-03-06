//
//  YXMineImageDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/23.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageDetailViewController.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"
#import "YXFaBuBaseViewController.h"
#import "YXFindSearchTagDetailViewController.h"
#import "UIImage+ImgSize.h"
#import "YXFirstFindImageTableViewCell.h"
#import "HGPersonalCenterViewController.h"
#import "XLVideoPlayer.h"
#import "UIWebView+KWWebViewJSTool.h"
#import "UIWebView+KWHideAccessoryView.h"
#import "YXWenZhangEditorViewController.h"
#import "YXPingLunCellTableViewCell.h"
#import "YXPingLunTableViewCell.h"
#import <Photos/Photos.h>
#define cellSpace 9
@interface YXMineImageDetailViewController ()<ZInputToolbarDelegate,QMUIMoreOperationControllerDelegate,SDCycleScrollViewDelegate,UIWebViewDelegate>{
    CGFloat imageHeight;
    
    BOOL zanBool;
    CGFloat webViewHeight;//webview高度
    CGFloat coverHeight;//封面高度
    BOOL webViewFinishBOOL;//判断webview是否加载完成
    CGFloat _oldY;
}
@property (nonatomic,strong)  YXFirstFindImageTableViewCell * cell;
@property (nonatomic,strong)  NSDictionary * shareDic;
@property (nonatomic,strong)  XLVideoPlayer * player;
@property (nonatomic,strong)  NSMutableArray * dataNewArray;


@end
@implementation YXMineImageDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [QMUITips showLoadingInView:self.view];
    [self initAllControl];
    //初始化所有的控件
    [self setHeaderView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self requestNewList];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)headerRereshing{
    [super headerRereshing];
    [self requestNewList] ;
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestNewList] ;
}
-(void)initAllControl{
    [super initAllControl];
    //赞和评论
    NSString * praisNum = kGetString(self.startDic[@"praise_number"]);
    //评论数量
    self.bottomZanCount.text = praisNum;
        if ([praisNum isEqualToString:@"0"] || [praisNum isEqualToString:@"(null)"]) {
         self.bottomZanCount.text = @"";
    }
    //赞
    BOOL isp =  [self.startDic[@"is_praise"] integerValue] == 1;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG_DARK;
    self.zanImgv.image = likeImage;
    self.pinglunView1.hidden = NO;
    self.pinglunView2.hidden = YES;
    
    self.dataNewArray = [[NSMutableArray alloc]init];
}
-(YXFirstFindImageTableViewCell *)cell{
    if (!_cell) {
        _cell = [[[NSBundle mainBundle]loadNibNamed:@"YXFirstFindImageTableViewCell" owner:self options:nil]lastObject];
    }
    return _cell;
}

-(void)setWebVIewData:(NSDictionary *)dic{
    self.cell.cellWebView.delegate = self;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath =
    [[NSBundle mainBundle] pathForResource:@"richText_editor1" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    self.cell.cellWebView.scrollView.bounces = NO;
    self.cell.cellWebView.hidesInputAccessoryView = YES;
    [self.cell.cellWebView loadHTMLString:htmlCont baseURL: baseURL];
    self.cell.cellWebView.userInteractionEnabled = NO;
    [self.cell.cellWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark -webviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
       NSString * newWebString = self.startDic[@"detail"];
       newWebString = [newWebString replaceAll:@"\"" target:@"\'"];
       newWebString = [newWebString replaceAll:@"<p><br></p><p><br></p>" target:@"<br>"];
       newWebString = [newWebString replaceAll:@"<p><br></p>" target:@"<br>"];
       newWebString = [newWebString replaceAll:@"<p class='ql-align-right'><br></p>" target:@""];
       newWebString = [newWebString replaceAll:@"<p class='ql-align-justify'><br></p>" target:@""];
       newWebString = [newWebString replaceAll:@"<p class='ql-align-left'><br></p>" target:@""];

        newWebString = [newWebString replaceAll:@"<br><br>" target:@""];
        newWebString = [newWebString replaceAll:@"<br><br><br>" target:@""];
        newWebString = [newWebString replaceAll:@"<br><br><br><br>" target:@""];
        newWebString = [newWebString replaceAll:@"<br><br><br><br><br>" target:@""];
        newWebString = [newWebString replaceAll:@"<br><br><br><br><br><br>" target:@""];
        newWebString = [newWebString replaceAll:@"<br><br><br><br><br><br><br>" target:@""];
        newWebString = [newWebString replaceAll:@"\n\n" target:@"\n"];

       [self.cell.cellWebView setupHtmlContent:newWebString];
       //删除占位信息
       [self.cell.cellWebView clearContentPlaceholder];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
        if([keyPath isEqualToString:@"contentSize"]) {
            webViewHeight= [[self.cell.cellWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
            CGRect newFrame= self.cell.cellWebView.frame;
            newFrame.size.height = webViewHeight;
            self.cell.cellWebView.frame= newFrame;
            [self.cell.cellWebView sizeToFit];
            CGRect Frame = self.cell.frame;

            CGFloat detailHeight = [ShareManager inTextOutHeight:self.startDic[@"title"] lineSpace:9 fontSize:24];
            CGFloat height = 10 + 10 + 5 + 10 + 36; //分割线和上下距离和评论
            Frame.size.height= 125 + detailHeight + webViewHeight + coverHeight + height;
            self.cell.midViewHeight.constant =  webViewHeight;
            self.cell.frame= Frame;
            [self.yxTableView setTableHeaderView:self.cell];//这句话才是重点
            [QMUITips hideAllTips];
    }
}

- (XLVideoPlayer *)player {
    if (!_player) {
        _player = [[XLVideoPlayer alloc] init];
        CGFloat scale = [self getVideoWidthWithSourcePath:self.startDic[@"url_list"][0]];
        _player.frame = CGRectMake(0, 0, kScreenWidth-20, ( KScreenWidth - 20 ) * scale);
        _player.cell = self.cell;
    }
    return _player;
}

- (double)getVideoWidthWithSourcePath:(NSString *)path{
    AVURLAsset*asset = [AVURLAsset assetWithURL:[NSURL URLWithString:path]];
    NSArray *array = asset.tracks;CGSize videoSize=CGSizeZero;
    for(AVAssetTrack*track in array){
        if([track.mediaType isEqualToString:AVMediaTypeVideo]){
           videoSize = track.naturalSize;
        }
    }
    double scale = videoSize.height/videoSize.width;
    return scale;
}


-(void)guanzhuAction{
    kWeakSelf(self);
    [YX_MANAGER requestLikesActionGET:kGetString(self.startDic[@"user_id"])  success:^(id object) {
          BOOL is_like = [weakself.guanzhuBtn.titleLabel.text isEqualToString:@"关注"] == 1;
          if (!is_like) {
              [WP_TOOL_ShareManager inGuanZhuStatus12Btn:weakself.guanzhuBtn];
              [WP_TOOL_ShareManager inGuanZhuStatus12Btn:weakself.cell.guanzhuBtn];
          }else{
              [WP_TOOL_ShareManager inYiGuanZhuStatus12Btn:weakself.guanzhuBtn];
              [WP_TOOL_ShareManager inYiGuanZhuStatus12Btn:weakself.cell.guanzhuBtn];
          }
      }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual: self.yxTableView]) {
        CGFloat detailHeight = [ShareManager inTextOutHeight:self.startDic[@"title"] lineSpace:9 fontSize:24];
        CGFloat needHeight = 0;
        if ([self.startDic[@"obj"] integerValue] == 2) {
            needHeight = detailHeight + coverHeight + 10 + 50;
        }else{
            needHeight = 50;
        }
        if (self.yxTableView.contentOffset.y > needHeight ) {
            self.coustomNavView.backgroundColor = KWhiteColor;
            [self.backBtn setImage:IMAGE_NAMED(@"A黑色返回") forState:UIControlStateNormal];
            [self.shareBtn setImage:IMAGE_NAMED(@"B黑色横向更多") forState:UIControlStateNormal];
            self.guanzhuBtn.hidden = self.titleImg.hidden = self.titleName.hidden = self.titleTime.hidden = NO;
            self.cell.guanzhuBtn.hidden = YES;
        }else{
           self.coustomNavView.backgroundColor = KClearColor;
           if ([self.startDic[@"obj"] integerValue] == 2) {
               [self.backBtn setImage:IMAGE_NAMED(@"A黑色背景返回") forState:UIControlStateNormal];
               [self.shareBtn setImage:IMAGE_NAMED(@"B黑色背景横向更多") forState:UIControlStateNormal];
           }else{
               [self.backBtn setImage:IMAGE_NAMED(@"A黑色返回") forState:UIControlStateNormal];
               [self.shareBtn setImage:IMAGE_NAMED(@"B黑色横向更多") forState:UIControlStateNormal];
           }
            self.guanzhuBtn.hidden = self.titleImg.hidden = self.titleName.hidden = self.titleTime.hidden = YES;
            self.cell.guanzhuBtn.hidden = NO;
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    _oldY = self.yxTableView.contentOffset.y;
}
-(void)setHeaderView{
    //初始化赋值
    if ([self.startDic[@"obj"] integerValue] == 2) {
        [self.backBtn setImage:IMAGE_NAMED(@"A黑色背景返回") forState:UIControlStateNormal];
        [self.shareBtn setImage:IMAGE_NAMED(@"B黑色背景横向更多") forState:UIControlStateNormal];
    }else{
        [self.backBtn setImage:IMAGE_NAMED(@"A黑色返回") forState:UIControlStateNormal];
        [self.shareBtn setImage:IMAGE_NAMED(@"B黑色横向更多") forState:UIControlStateNormal];
    }
    self.guanzhuBtn.hidden = YES;
    self.cell.guanzhuBtn.hidden = NO;
    //头像
    NSString * str1 = [(NSMutableString *)self.startDic[@"photo"] replaceAll:@" " target:@"%20"];
    [self.titleImg sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:str1]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    //头名字
    self.titleName.text = self.startDic[@"user_name"];
    //头时间
    self.titleTime.text = [ShareManager updateTimeForRow:[self.startDic[@"publish_time"] longLongValue]];
    self.titleImg.hidden = self.titleName.hidden = self.titleTime.hidden = YES;
    
    
    
    [self.cell setCellValue:self.startDic];
    kWeakSelf(self);
    [YX_MANAGER requestGetUserothers:kGetString(self.startDic[@"user_id"]) success:^(id object) {
           NSInteger tag = [object[@"is_like"] integerValue];
           if(tag == 2){
             [WP_TOOL_ShareManager inYiGuanZhuStatus12Btn:weakself.guanzhuBtn];
             [WP_TOOL_ShareManager inYiGuanZhuStatus12Btn:weakself.cell.guanzhuBtn];

           }else if(tag == 1){
            [WP_TOOL_ShareManager inHuXiangGuanZhuStatus12Btn:weakself.guanzhuBtn];
            [WP_TOOL_ShareManager inHuXiangGuanZhuStatus12Btn:weakself.cell.guanzhuBtn];

           }else{
            [WP_TOOL_ShareManager inGuanZhuStatus12Btn:weakself.guanzhuBtn];
            [WP_TOOL_ShareManager inGuanZhuStatus12Btn:weakself.cell.guanzhuBtn];
           }
    }];
    self.cell.tagId = [self.startDic[@"id"] integerValue];
    CGRect oldFrame = self.cell.frame;
    CGFloat newHeight =  self.headerViewHeight + (IS_IPhoneX ? 0 : 20);
    self.cell.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, newHeight);
    self.cell.fenxiangBtn.hidden = self.cell.fenxiangImv.hidden = YES;
    //详情界面点赞和分享调整到下边
    self.cell.threeBtnStackView.hidden =  YES;
    self.cell.bottomPingLunLbl.hidden = NO;
    //晒图
    if ([self.startDic[@"obj"] integerValue] == 1) {

        self.cell.topTopHeight.constant = 70;//头像的view距离封面图和文章lable的距离，要留出A黑色返回的高度，所以高一点
        self.cell.wenzhangDetailHeight.constant = 0;//晒图进来，设置文章的的label为0
        [QMUITips hideAllTipsInView:self.view];
        [ShareManager setAllContentAttributed:cellSpace inLabel:self.cell.detailLbl font:SYSTEMFONT(16)];
        CGFloat detailHeight = [YXFirstFindImageTableViewCell jisuanContentHeight:self.startDic];
        //标签高度
        CGFloat tagViewHeight = [YXFirstFindImageTableViewCell cellTagViewHeight:self.startDic];
        //这里判断晒图是图还是视频
        if ([self.startDic[@"url_list"] count] > 0) {
            //视频
            if ([kGetString(self.startDic[@"url_list"][0]) containsString:@"mp4"]) {
                CGFloat scale = [self getVideoWidthWithSourcePath:self.startDic[@"url_list"][0]];
                self.cell.midViewHeight.constant = ( KScreenWidth - 20 ) * scale;
                self.cell.playImV.hidden = YES;
                CGRect Frame = self.cell.frame;
                Frame.size.height= self.headerViewHeight - 100 + 60 + self.cell.midViewHeight.constant+ (IS_IPhoneX ? 0 : 20) + 6;
                self.cell.frame= Frame;
                self.player.videoUrl = self.startDic[@"url_list"][0];
                [self.cell.onlyOneImv addSubview:self.player];
            //晒图
            }else{
                CGRect Frame = self.cell.frame;

                CGFloat midViewHeight = [YXFirstFindImageTableViewCell cellAllImageHeight:self.startDic];
                Frame.size.height = 170 + tagViewHeight +  detailHeight + midViewHeight + kTopHeight+ (IS_IPhoneX ? 0 : 20) + 6;
                self.cell.frame= Frame;
               
            }
        }
         self.yxTableView.tableHeaderView = self.cell;
    //文章
    }else{
        self.cell.onlyOneImv.hidden = self.cell.playImV.hidden = YES;
        CGFloat detailHeight = [ShareManager inTextOutHeight:[self.startDic[@"title"] UnicodeToUtf8] lineSpace:9 fontSize:24];
        self.cell.wenzhangDetailHeight.constant = detailHeight;//晒图进来，设置文章的的label为0
        self.cell.cellWebView.hidden = NO;//文章显示webview
        self.cell.topTopHeight.constant = 0 ;//头像的view距离封面图的距离，文章因为有封面，所以离封面图10就行
        self.cell.detailLbl.hidden = YES;//隐藏原有detail的详情
        self.cell.detailHeight.constant = 0;//设置原有的detail为0
        //封面图
        NSString * cover = self.startDic[@"cover"];
        if (![self.startDic[@"cover"] contains:IMG_URI]) {
            cover = [IMG_URI append:self.startDic[@"cover"]];
        }
        CGSize size = [UIImage getImageSizeWithURL:cover];
        double scale = size.width == 0 ? 0 : size.height/size.width;
        coverHeight = kScreenWidth * scale;
        self.cell.coverImvHeight.constant = coverHeight;
        [self.cell.coverImV sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        [self setWebVIewData:self.startDic];
        self.yxTableView.tableHeaderView = self.cell;
    }
    zanBool =  [self.startDic[@"is_praise"] integerValue] == 1;

    self.cell.shareblock = ^(NSInteger tag1) {
        
    };
    self.cell.clickImageBlock = ^(NSInteger tag) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself clickUserImageView:kGetString(weakself.startDic[@"user_id"])];
    };
    self.cell.clickTagblock = ^(NSString * string) {
        if ([string contains:@"#"]) {string = [string split:@"#"][1];}
        [YX_MANAGER requestSearchFind_all:@{@"key":string,@"key_unicode":[string utf8ToUnicode],@"page":@"1",@"type":@"2"} success:^(id object) {
            if ([object count] > 0) {
                YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
                VC.type = @"3";
                VC.key = object[0][@"tag"];
                VC.startDic = [NSDictionary dictionaryWithDictionary:object[0]];
                [weakself.navigationController pushViewController:VC animated:YES];
            }else{
                [QMUITips showInfo:@"无此标签的信息"];
            }
        }];
    };
    self.cell.clickDetailblock = ^(NSInteger tag, NSInteger tag1) {
        NSIndexPath * indexPathSelect = [NSIndexPath indexPathForRow:tag1  inSection:0];
        YXFirstFindImageTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        if (tag == 1) {
            [weakself setupTextField];
            [weakself.inputToolbar.textInput becomeFirstResponder];
        }else if(tag == 2){
       
        }else{
           
        }
    };
    self.cell.guanZhublock = ^{
        if (![userManager loadUserInfo]) {
                  KPostNotification(KNotificationLoginStateChange, @NO);
                  return;
              }
        [weakself guanzhuAction];
    };
}

- (void)fenxiangAction{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [kGetString(userInfo[@"id"]) integerValue];
    self.shareDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    [self addGuanjiaShareViewIsOwn:isOwn isWho:kGetString(self.startDic[@"obj"]) tag:[self.startDic[@"id"] integerValue]  startDic: self.startDic];
}
- (void)dianzanAction{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    [self requestDianZan_Image_Action:nil];
}
#pragma mark ========== 头像点击 ==========
-(void)clickUserImageView:(NSString *)userId{
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    if ([kGetString(userInfo[@"id"]) isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 3;
        return;
    }
    HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
    mineVC.userId = userId;
    mineVC.whereCome = YES;    //  YES为其他人 NO为自己
    [self.navigationController pushViewController:mineVC animated:YES];
    
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.startDic[@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        //赞
        zanBool = !zanBool;
        UIImage * likeImage = zanBool ? ZAN_IMG : UNZAN_IMG_DARK;
        weakself.zanImgv.image = likeImage;
        NSInteger zhengfuValue = zanBool ? 1 : -1;
        weakself.bottomZanCount.text = NSIntegerToNSString([weakself.bottomZanCount.text integerValue] + zhengfuValue);
        if ([weakself.bottomZanCount.text isEqualToString:@"0"]) {
            weakself.bottomZanCount.text= @"";
        }
    }];
}


#pragma mark ========== 获取晒图评论列表 ==========
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    [YX_MANAGER requestPost_comment:[self getParamters:@"1" page:NSIntegerToNSString(self.requestPage)] success:^(id object) {
        weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView.mj_header endRefreshing];
        [weakself.yxTableView.mj_footer endRefreshing];
        [weakself refreshTableView];
    }];
}
-(void)refreshTableView{
    [self.yxTableView reloadData];
}
//#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestpost_comment_childPOST:dic success:^(id object) {
        [weakself requestNewList];
    }];
}
#pragma mark ========== tableview 点赞按钮 ==========
-(void)zanCurrentCell:(NSDictionary *)dic{
        kWeakSelf(self);
        [YX_MANAGER requestPost_comment_praisePOST:@{@"comment_id":kGetString(dic[@"id"])} success:^(id object) {
            [weakself requestNewList];
        }];
}
#pragma mark ========== 评论最外层晒图 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPost_commentPOST:dic success:^(id object) {
         [weakself requestNewList];
    }];
}
#pragma mark ========== 回复某一个cell的 ==========
-(void)huFuCurrentCell:(NSDictionary *)dic{
     self.isReplayingComment = YES;
     self.currentCellDic = [NSDictionary dictionaryWithDictionary:dic];
     [self setupTextField];
     [self.inputToolbar.textInput becomeFirstResponder];
}
#pragma mark ========== 删除某一个cell ==========
-(void)delCurrentCell:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestDelFatherPl_ShaiTu:kGetString(dic[@"id"]) success:^(id object) {
          [QMUITips showSucceed:@"删除成功"];
          [weakself requestNewList];
    }];
}
#pragma mark ========== 删除某一个cell的自己的子评论 ==========
-(void)pressLongDelChildCurrentCell:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestDelChildPl_ShaiTu:kGetString(dic[@"id"]) success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        [weakself requestNewList];
    }];
}

-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/0/%@/%@/",type,self.startDic[@"id"],page];
}
//-(void)delePingLun:(NSInteger)tag{
//    kWeakSelf(self);
//    [YX_MANAGER requestDelChildPl_ShaiTu:NSIntegerToNSString(tag) success:^(id object) {
//        [QMUITips showSucceed:@"删除成功"];
//        [weakself requestNewList];
//    }];
//}
-(void)deleFather_PingLun:(NSString *)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelFatherPl_ShaiTu:tag success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        [weakself requestNewList];
    }];
}

- (IBAction)clickPingLunAction:(id)sender{
    [self setupTextField];
    [self.inputToolbar.textInput becomeFirstResponder];
}

- (void)setupTextField{
    [self.inputToolbar removeFromSuperview];
    self.inputToolbar = [[ZInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.height, self.view.width, 60)];
    self.inputToolbar.textViewMaxLine = 5;
    self.inputToolbar.delegate = self;
    self.inputToolbar.placeholderLabel.text = @"开始评论...";
    
    [self.view addSubview:self.inputToolbar];
}
#pragma mark - ZInputToolbarDelegate
-(void)inputToolbar:(ZInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {
    [self finishTextView:inputToolbar.textInput];
    // 清空输入框文字
    [self.inputToolbar sendSuccessEndEditing];
}


#pragma mark - UITextFieldDelegate
-(void)finishTextView:(UITextView *)textField{
    if (self.isReplayingComment) {
        
        [self requestpost_comment_child:@{@"comment":textField.text,
                                          @"father_id":kGetString(self.currentCellDic[@"id"]),
                                          @"aim_id":kGetString(self.currentCellDic[@"user_id"]),
                                          @"aim_name":self.currentCellDic[@"user_name"]
                                          }];
        self.isReplayingComment = NO;
    }else{
        [self pinglunFatherPic:@{@"comment":[textField.text utf8ToUnicode],
                                 @"post_id":@([self.startDic[@"id"] intValue]),
                                 }];
        
    }
}

-(CGFloat)getImvHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * url =  whereCome ? dic[@"pic1"]:dic[@"photo1"];
    if (url.length < 5) {
        return 0;
    }
    return  400;
}

#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareViewIsOwn:(BOOL)isOwn isWho:(NSString *)isWho tag:(NSInteger)tagId startDic:(NSDictionary *)startDic{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    kWeakSelf(self);
    
    NSMutableArray * itemsArray1 = [[NSMutableArray alloc]init];
    if (isOwn) {
        if ([isWho isEqualToString:@"1"] || [isWho isEqualToString:@"2"]) {
            [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_add") title:@"编辑" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                       [moreOperationController hideToBottom];
                if ([isWho isEqualToString:@"1"]) {
                    YXFaBuBaseViewController * imageVC = [[YXFaBuBaseViewController alloc]init];
                    YXShaiTuModel * model = [[YXShaiTuModel alloc]init];
                    model.post_id = kGetString(startDic[@"id"]);
                    model.coustomId = @"";
                    model.detail = startDic[@"detail"];
                    model.publish_site = startDic[@"publish_site"];
                    model.title = startDic[@"title"];
                    model.tag = startDic[@"tag"];
                    model.publish_site = startDic[@"publish_site"];
                    model.photo_list = startDic[@"photo_list"];
                    model.cover = startDic[@"cover"];
                    model.obj = kGetString(startDic[@"obj"]);
                    imageVC.model = model;
                    imageVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakself presentViewController:imageVC animated:YES completion:nil];
                }else{
                    YXWenZhangEditorViewController * wenzhangVC = [[YXWenZhangEditorViewController alloc]init];
                    YXShaiTuModel * model = [[YXShaiTuModel alloc]init];
                    model.post_id = kGetString(startDic[@"id"]);
                    model.coustomId = @"";
                    model.detail = startDic[@"detail"];
                    model.publish_site = startDic[@"publish_site"];
                    model.title = startDic[@"title"];
                    model.tag = startDic[@"tag"];
                    model.publish_site = startDic[@"publish_site"];
                    model.photo_list = startDic[@"photo_list"];
                    model.cover = startDic[@"cover"];
                    model.obj = kGetString(startDic[@"obj"]);
                    wenzhangVC.model = model;
                    wenzhangVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakself presentViewController:wenzhangVC animated:YES completion:nil];
                }
                       
            }]];
        }
    
        [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_remove") title:@"删除" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
            [moreOperationController hideToBottom];
                [QMUITips showLoadingInView:weakself.view];
                [YX_MANAGER requestDel_ShaiTU:NSIntegerToNSString(tagId) success:^(id object) {
                    [QMUITips hideAllTips];
                    [QMUITips showSucceed:@"删除成功"];
                    [weakself.navigationController popViewControllerAnimated:YES];
                }];
        
        }]];
    }else{
        [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_report") title:@"举报" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
            [moreOperationController hideToBottom];
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            }];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"不友善内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                [QMUITips showSucceed:@"举报成功"];
            }];
            QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"有害内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                [QMUITips showSucceed:@"举报成功"];
            }];
            QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"抄袭内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                [QMUITips showSucceed:@"举报成功"];
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            [alertController addAction:action4];
            [alertController showWithAnimated:YES];
        }]];
    }

    
    
    moreOperationController.items = @[
                                      // 第一行
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_WechatSession];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_WechatTimeLine];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_QQ") title:@"分享给QQ好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [weakself saveImage:UMSocialPlatformType_QQ];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [weakself saveImage:UMSocialPlatformType_Qzone];
                                          }],
                                          ],
                                      itemsArray1
                                      // 第二行
                         
                                      ];
    [moreOperationController showFromBottom];

}
- (void)saveImage:(UMSocialPlatformType)umType{
    UIImage* viewImage = nil;
    UITableView *scrollView = self.yxTableView;
    UIGraphicsBeginImageContextWithOptions(scrollView.frame.size, scrollView.opaque, 0.0);{
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width,KScreenHeight);
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    //先上传到七牛云图片  再提交服务器
    [QMUITips showLoadingInView:self.view];
    [QiniuLoad uploadImageToQNFilePath:@[viewImage] success:^(NSString *reslut) {
        [QMUITips hideAllTips];

           NSDictionary * userInfo = userManager.loadUserAllInfo;
           NSString * title = [NSString stringWithFormat:@"%@发布的内容@蓝皮书app",userInfo[@"username"]];
           NSString * desc = @"这篇内容真的很赞，快点开看!";
          [[ShareManager sharedShareManager] shareAllToPlatformType:umType obj:@{@"img":reslut,@"desc":desc,@"title":title,@"type":@"3"}];
    } failure:^(NSString *error) {
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [_player destroyPlayer];
    _player = nil;
}
- (void)shareAction{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    NSDictionary * userInfo = userManager.loadUserAllInfo;
    BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [kGetString(userInfo[@"id"]) integerValue];
    self.shareDic = [NSDictionary dictionaryWithDictionary:self.cell.dataDic];
    [self addGuanjiaShareViewIsOwn:isOwn isWho:kGetString(self.startDic[@"obj"]) tag:[self.startDic[@"id"] integerValue] startDic:self.startDic];
}

@end
