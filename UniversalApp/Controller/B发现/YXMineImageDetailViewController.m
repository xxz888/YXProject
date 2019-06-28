//
//  YXMineImageDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/23.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageDetailViewController.h"
#import "XHWebImageAutoSize.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"
#import "YXFindImageTableViewCell.h"
#import "HXEasyCustomShareView.h"
#import "YXPublishImageViewController.h"
#import "YXFindSearchTagDetailViewController.h"
#import "UIImage+ImgSize.h"
#import "YXFirstFindImageTableViewCell.h"
#import "HGPersonalCenterViewController.h"
#import "XLVideoPlayer.h"

@interface YXMineImageDetailViewController ()<ZInputToolbarDelegate,QMUIMoreOperationControllerDelegate,SDCycleScrollViewDelegate,UIWebViewDelegate>{
    CGFloat imageHeight;
    
    BOOL zanBool;
    CGFloat webViewHeight;//webview高度
    CGFloat coverHeight;//封面高度
    BOOL webViewFinishBOOL;//判断webview是否加载完成

}
@property (nonatomic,strong)  YXFirstFindImageTableViewCell * cell;
@property (nonatomic,strong)  NSDictionary * shareDic;
@property (nonatomic,strong)  XLVideoPlayer * player;


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

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //初始化所有的控件
    [self setHeaderView];
    [self requestNewList];
    
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
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [self.bottomZanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
}
-(YXFirstFindImageTableViewCell *)cell{
    if (!_cell) {
        _cell = [[[NSBundle mainBundle]loadNibNamed:@"YXFirstFindImageTableViewCell" owner:self options:nil]lastObject];
    }
    return _cell;
}
-(void)setWebVIewData:(NSDictionary *)dic{
    self.cell.cellWebView.delegate = self;
    //获取bundlePath 路径
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //获取本地html目录 basePath
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"html"];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
    //显示内容
    if (dic[@"detail"]) {
        [self.cell.cellWebView loadHTMLString:[ShareManager adaptWebViewForHtml:dic[@"detail"]] baseURL: baseUrl];
    }
    [self.cell.cellWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    if([keyPath isEqualToString:@"contentSize"]) {
        webViewHeight= [[self.cell.cellWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
        CGRect newFrame= self.cell.cellWebView.frame;
        newFrame.size.height = webViewHeight;
        self.cell.cellWebView.frame= newFrame;
        [self.cell.cellWebView sizeToFit];
        CGRect Frame = self.cell.frame;
        Frame.size.height= self.headerViewHeight - 180 + webViewHeight + coverHeight ;
        self.cell.midViewHeight.constant =  webViewHeight;
        self.cell.frame= Frame;
        [self.yxTableView setTableHeaderView:self.cell];//这句话才是重点
    }
}
    
- (void)webViewDidFinishLoad:(UIWebView*)webView{
        CGFloat sizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
        self.cell.cellWebView.frame=CGRectMake(0,0,self.cell.midView.frame.size.width, sizeHeight);
        [QMUITips hideAllTipsInView:self.view];

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
-(void)setHeaderView{
    [self.cell setCellValue:self.startDic];
 
    self.cell.tagId = [self.startDic[@"id"] integerValue];
    CGRect oldFrame = self.cell.frame;
    CGFloat newHeight =  self.headerViewHeight;
    self.cell.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, newHeight);


    //详情界面点赞和分享调整到下边
    self.cell.threeBtnStackView.hidden =  YES;
    self.cell.bottomBottomHeight.constant = 40;
    self.cell.bottomPingLunLbl.hidden = NO;
    
    //晒图
    if ([self.startDic[@"obj"] integerValue] == 1) {
        self.cell.topTopHeight.constant = 70;
        [QMUITips hideAllTipsInView:self.view];
        //这里判断晒图是图还是视频
        if ([self.startDic[@"url_list"] count] > 0) {
            if ([kGetString(self.startDic[@"url_list"][0]) containsString:@"mp4"]) {
                CGFloat scale = [self getVideoWidthWithSourcePath:self.startDic[@"url_list"][0]];
                self.cell.midViewHeight.constant = ( KScreenWidth - 20 ) * scale;
                //视频
                self.cell.playImV.hidden = YES;
                CGRect Frame = self.cell.frame;
                Frame.size.height= self.headerViewHeight - 100 + 60 + self.cell.midViewHeight.constant;
                self.cell.frame= Frame;


                self.player.videoUrl = self.startDic[@"url_list"][0];
                [self.cell.onlyOneImv addSubview:self.player];
                
            }else{
                CGRect Frame = self.cell.frame;
                Frame.size.height= self.headerViewHeight + 100;
                self.cell.frame= Frame;
                //轮播图
                [self.cell setUpSycleScrollView:self.startDic[@"url_list"] height:KScreenWidth - 20];
                self.cell.rightCountLbl.text = [NSString stringWithFormat:@"%@/%lu",@"1",(unsigned long)[self.startDic[@"url_list"] count]];
                self.cell.rightCountLbl.hidden = [self.cell.rightCountLbl.text isEqualToString:@"1/1"] || [self.cell.rightCountLbl.text isEqualToString:@"1/0"];
            }
        }
     
        
        
    }else{
        self.cell.imgV1.hidden = self.cell.imgV2.hidden = self.cell.imgV3.hidden = self.cell.imgV4.hidden = self.cell.stackView.hidden = self.cell.onlyOneImv.hidden = self.cell.playImV.hidden = YES;
        self.cell.cellWebView.hidden = NO;
        //封面图
        self.cell.coverTopHeight.constant = 10;
        CGSize size = [UIImage getImageSizeWithURL:self.startDic[@"cover"]];
        double scale = size.width == 0 ? 0 : size.height/size.width;
        coverHeight = (kScreenWidth-20)*scale;
        self.cell.coverImvHeight.constant = coverHeight;
        NSString * str1 = [(NSMutableString *)self.startDic[@"cover"] replaceAll:@" " target:@"%20"];
        [self.cell.coverImV sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        ViewRadius(self.cell.coverImV, 5);
        [self setWebVIewData:self.startDic];
        self.cell.leftWidth.constant  = 5;
        self.cell.rightWidth.constant = 5;
    }
    zanBool =  [self.startDic[@"is_praise"] integerValue] == 1;
    self.yxTableView.tableHeaderView = self.cell;
    
    
    
    
    kWeakSelf(self);

    
    self.cell.shareblock = ^(NSInteger tag1) {
        NSIndexPath * indexPathSelect = [NSIndexPath indexPathForRow:tag1  inSection:0];
        YXFindImageTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        UserInfo * userInfo = curUser;
        BOOL isOwn = [weakself.startDic[@"user_id"] integerValue] == [userInfo.id integerValue];
        weakself.shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:cell.tagId startDic:cell.dataDic];
    };
    self.cell.clickImageBlock = ^(NSInteger tag) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself clickUserImageView:kGetString(weakself.startDic[@"user_id"])];
    };
    self.cell.clickTagblock = ^(NSString * string) {
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
        YXFindImageTableViewCell * cell = [weakself.yxTableView cellForRowAtIndexPath:indexPathSelect];
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
}
- (void)fenxiangAction{
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    UserInfo * userInfo = curUser;
    BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [userInfo.id integerValue];
    self.shareDic = [NSDictionary dictionaryWithDictionary:self.startDic];
    [self addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:[self.startDic[@"id"] integerValue]  startDic: self.startDic];
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
    UserInfo *userInfo = curUser;
    if ([userInfo.id isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 4;
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
        UIImage * likeImage = zanBool ? ZAN_IMG : UNZAN_IMG;
        [weakself.bottomZanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
        NSInteger zhengfuValue = zanBool ? 1 : -1;
        weakself.bottomZanCount.text = NSIntegerToNSString([weakself.bottomZanCount.text integerValue] + zhengfuValue);
        if ([weakself.bottomZanCount.text isEqualToString:@"0"]) {
            weakself.bottomZanCount.text= @"";
        }
    }];
}
-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",dic[@"content"] ? dic[@"content"]:dic[@"describe"],dic[@"tag"]];
    CGFloat height_size = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
    return height_size;
}

#pragma mark ========== 获取晒图评论列表 ==========
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    [YX_MANAGER requestPost_comment:[self getParamters:@"1" page:NSIntegerToNSString(self.requestPage)] success:^(id object) {
        if ([object count] > 0) {
            weakself.dataArray = [weakself commonAction:[weakself creatModelsWithCount:object] dataArray:weakself.dataArray];
        }else{
            [weakself.yxTableView.mj_header endRefreshing];
            [weakself.yxTableView.mj_footer endRefreshing];
        }
        [weakself refreshTableView];

    }];
}
-(void)refreshTableView{
    [self.yxTableView reloadData];
}
#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestpost_comment_childPOST:dic success:^(id object) {
        [weakself requestNewList];
    }];
}
#pragma mark ========== 更多评论 ==========
-(void)requestMoreCigar_comment_child:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",farther_id,page];
    [YX_MANAGER requestPost_comment_child:string success:^(id object) {
        if ([object count] == 0) {
            [QMUITips showInfo:@"没有更多评论了" detailText:@"" inView:weakself.yxTableView hideAfterDelay:1];
            return ;
        }
        SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        for (NSDictionary * dic in object) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            if ([dic[@"aim_id"] integerValue] != 0) {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName = kGetString(dic[@"user_name"]);
                commentItemModel.secondUserName = kGetString(dic[@"aim_name"]);
                commentItemModel.secondUserId = kGetString(dic[@"aim_id"]);
                commentItemModel.commentString = [kGetString(dic[@"comment"]) UnicodeToUtf8];
                commentItemModel.labelTag = [dic[@"id"] integerValue];
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_name"]);
                commentItemModel.commentString = [kGetString(dic[@"comment"]) UnicodeToUtf8];
                commentItemModel.labelTag = [dic[@"id"] integerValue];
            }
            BOOL ishave = NO;
            for (SDTimeLineCellCommentItemModel * oldCommentItemModel in model.commentItemsArray) {
                if ([oldCommentItemModel.firstUserId integerValue] == [commentItemModel.firstUserId integerValue] &&
                    [oldCommentItemModel.firstUserName isEqualToString:commentItemModel.firstUserName]   &&
                    [oldCommentItemModel.commentString isEqualToString:commentItemModel.commentString]
                    ) {
                    ishave = YES;
                }else{
                    ishave = NO;
                    break;
                }
            }
            if (ishave) {
            }else{
                [temp addObject:commentItemModel];
                model.commentItemsArray = [temp copy];
            }
        }
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== tableview数据 ==========
- (NSArray *)creatModelsWithCount:(NSArray *)formalArray{
    [self.pageArray removeAllObjects];
    NSMutableArray *resArr = [NSMutableArray new];
    for (int i = 0; i < formalArray.count; i++) {
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        NSMutableDictionary * pageDic = [[NSMutableDictionary alloc]init];
        model.iconName = formalArray[i][@"photo"];
        model.name = formalArray[i][@"user_name"];
        model.userID = formalArray[i][@"user_id"];

        model.msgContent = [formalArray[i][@"comment"] UnicodeToUtf8] ;
        model.commontTime = [formalArray[i][@"update_time"] integerValue];
        model.praise = kGetString(formalArray[i][@"is_praise"]);
        model.praise_num = kGetString(formalArray[i][@"praise_number"]);

        
        model.id =  kGetString(formalArray[i][@"id"]);
        model.postid = kGetString(formalArray[i][@"postid"]);
        if ([formalArray[i][@"child_list"] count] == 0) {
            model.moreCountPL = @"0";
        }else{
            model.moreCountPL = [NSString stringWithFormat:@"%lu",[formalArray[i][@"child_number"] integerValue] - [formalArray[i][@"child_list"] count]];
        }
      
        [pageDic setValue:@([model.id intValue]) forKey:@"id"];
        [pageDic setValue:@(0) forKey:@"page"];
        [self.pageArray addObject:pageDic];
        // 模拟随机评论数据
        NSMutableArray *tempComments = [NSMutableArray new];
        NSArray * child_listArray =  [NSArray arrayWithArray:formalArray[i][@"child_list"]];
        for (int i = 0; i < [child_listArray count]; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            commentItemModel.firstUserName = kGetString(child_listArray[i][@"user_name"]);
            commentItemModel.firstUserId = kGetString(child_listArray[i][@"user_id"]);
            if (child_listArray[i][@"aim_id"] != 0) {
                commentItemModel.secondUserName = kGetString(child_listArray[i][@"aim_name"]);
                commentItemModel.secondUserId = kGetString(child_listArray[i][@"aim_id"]);
            }
            commentItemModel.commentString = [child_listArray[i][@"comment"] UnicodeToUtf8];
            commentItemModel.labelTag = [child_listArray[i][@"id"] integerValue];
            [tempComments addObject:commentItemModel];
        }
        model.commentItemsArray = [tempComments copy];
        // 模拟随机点赞数据
        NSMutableArray *tempLikes = [NSMutableArray new];
        SDTimeLineCellLikeItemModel * model1 = [SDTimeLineCellLikeItemModel new];
        model1.userName = [NSString stringWithFormat:@"%@",formalArray[i][@"praise_number"]];
        model1.userId = @"000";
        [tempLikes addObject:model1];
        model.likeItemsArray = [tempLikes copy];
        [resArr addObject:model];
    }
    return [resArr copy];
}
#pragma mark ========== 点击跟多评论按钮 ==========
-(void)showMoreComment:(UITableViewCell *)cell{
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
    NSMutableArray * copyArray = [NSMutableArray arrayWithArray:self.pageArray];
    for (NSDictionary * dic in copyArray) {
        if ([dic[@"id"] intValue] == [model.id intValue]) {
            [dic setValue:@([dic[@"page"] intValue]+1) forKey:@"page"];
            kWeakSelf(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself requestMoreCigar_comment_child:model.id page:kGetString(dic[@"page"])];
            });
        }
    }
}
#pragma mark ========== tableview 点击评论按钮 ==========
- (void)didClickcCommentButtonInCell:(SDTimeLineCell *)cell{
    [self setupTextField];
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel * model = self.dataArray[self.currentEditingIndexthPath.row];
    self.textField.placeholder = [NSString stringWithFormat:@"  回复：%@",model.name];
    self.currentEditingIndexthPath = cell.indexPath;
    self.isReplayingComment = YES;
    self.commentToUser = model.name;
    self.commentToUserID = model.userID;
    [self adjustTableViewToFitKeyboard];
}
#pragma mark ========== tableview 点赞按钮 ==========
- (void)didClickLikeButtonInCell:(SDTimeLineCell *)cell{
    kWeakSelf(self);
    NSIndexPath *index = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    [YX_MANAGER requestPost_comment_praisePOST:@{@"comment_id":@([model.id intValue])} success:^(id object) {
        weakself.currentEditingIndexthPath = index;
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
#pragma mark ========== 评论晒图 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPost_commentPOST:dic success:^(id object) {
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/0/%@/%@/",type,self.startDic[@"id"],page];
}
-(void)delePingLun:(NSInteger)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelChildPl_ShaiTu:NSIntegerToNSString(tag) success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
-(void)deleFather_PingLun:(NSString *)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelFatherPl_ShaiTu:tag success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
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
        SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
        [self requestpost_comment_child:@{@"comment":[textField.text utf8ToUnicode],
                                          @"father_id":@([model.id intValue]),
                                          @"aim_id":self.commentToUserID,
                                          @"aim_name":self.commentToUser
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
    return    [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
}
-(CGFloat)getTitleTagLblHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"tag"]];
    return [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
}


































#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareViewIsOwn:(BOOL)isOwn isWho:(NSString *)isWho tag:(NSInteger)tagId startDic:(NSDictionary *)startDic{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    kWeakSelf(self);
    // 如果你的 item 是确定的，则可以直接通过 items 属性来显示，如果 item 需要经过一些判断才能确定下来，请看第二个示例
    NSMutableArray * itemsArray1 = [[NSMutableArray alloc]init];
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_add") title:@"编辑" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
        YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
        YXShaiTuModel * model = [[YXShaiTuModel alloc]init];
        [model setValuesForKeysWithDictionary:startDic];
        [weakself presentViewController:imageVC animated:YES completion:nil];
    }]],
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_remove") title:@"删除" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
        if ([isWho isEqualToString:@"1"]) {
            [YX_MANAGER requestDel_ShaiTU:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([isWho isEqualToString:@"2"]){
            [YX_MANAGER requestDel_WenDa:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([isWho isEqualToString:@"3"]){
            [YX_MANAGER requestDel_ZuJi:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
        }
    }]],
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
    
    if (isOwn) {
        [itemsArray1 removeObjectAtIndex:2];
        if (![isWho isEqualToString:@"1"]) {
            [itemsArray1 removeObjectAtIndex:0];
        }
    }else{
        [itemsArray1 removeObjectAtIndex:0];
        [itemsArray1 removeObjectAtIndex:0];
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
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);{
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    //先上传到七牛云图片  再提交服务器
    [QiniuLoad uploadImageToQNFilePath:@[viewImage] success:^(NSString *reslut) {
        [[ShareManager sharedShareManager] shareWebPageZhiNanDetailToPlatformType:umType obj:@{@"img":reslut}];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [_player destroyPlayer];
    _player = nil;
}

@end
