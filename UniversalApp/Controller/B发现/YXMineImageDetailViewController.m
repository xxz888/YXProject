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
@interface YXMineImageDetailViewController ()<ZInputToolbarDelegate,QMUIMoreOperationControllerDelegate,SDCycleScrollViewDelegate,UIWebViewDelegate>{
    CGFloat imageHeight;
    NSDictionary * shareDic;
    YXFirstFindImageTableViewCell * cell;
    BOOL zanBool;
    CGFloat webViewHeight;
    BOOL webViewFinishBOOL;//判断webview是否加载完成
}

@end
@implementation YXMineImageDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    //初始化所有的控件
    [self initAllControl];
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
    [self setHeaderView];
}
-(void)setWebVIewData:(NSDictionary *)dic{
    cell.cellWebView.delegate = self;
    //获取bundlePath 路径
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //获取本地html目录 basePath
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"html"];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
    //显示内容
    if (dic[@"detail"]) {
        [cell.cellWebView loadHTMLString:[ShareManager adaptWebViewForHtml:dic[@"detail"]] baseURL: baseUrl];
    }
    [cell.cellWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    if([keyPath isEqualToString:@"contentSize"]) {
        webViewHeight= [[cell.cellWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
        CGRect newFrame= cell.cellWebView.frame;
        newFrame.size.height = webViewHeight;
        cell.cellWebView.frame= newFrame;
        [cell.cellWebView sizeToFit];
        CGRect Frame = cell.frame;
        Frame.size.height= self.headerViewHeight - (kScreenWidth - 20) + webViewHeight;
        cell.midViewHeight.constant =  webViewHeight;
        cell.frame= Frame;
        [self.yxTableView setTableHeaderView:cell];//这句话才是重点
    }
}
    
- (void)webViewDidFinishLoad:(UIWebView*)webView{
        CGFloat sizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
        cell.cellWebView.frame=CGRectMake(0,0,cell.midView.frame.size.width, sizeHeight);
}
-(void)setHeaderView{
    cell = [[[NSBundle mainBundle]loadNibNamed:@"YXFirstFindImageTableViewCell" owner:self options:nil]lastObject];
    [cell setCellValue:self.startDic];
    cell.leftWidth.constant = cell.rightWidth.constant = 5;
    cell.tagId = [self.startDic[@"id"] integerValue];
    CGRect oldFrame = cell.frame;
    CGFloat newHeight =  self.headerViewHeight;
    cell.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, newHeight);
    //晒图
    if ([self.startDic[@"obj"] integerValue] == 1) {
        [cell setUpSycleScrollView:self.startDic[@"url_list"] height:KScreenWidth - 20];
        cell.rightCountLbl.text = [NSString stringWithFormat:@"%@/%lu",@"1",(unsigned long)[self.startDic[@"url_list"] count]];
        cell.rightCountLbl.hidden = [cell.rightCountLbl.text isEqualToString:@"1/1"] || [cell.rightCountLbl.text isEqualToString:@"1/0"];
        zanBool =  [self.startDic[@"is_praise"] integerValue] == 1;
    }else{
        cell.imgV1.hidden = cell.imgV2.hidden = cell.imgV3.hidden = cell.imgV4.hidden = cell.stackView.hidden = cell.onlyOneImv.hidden = YES;
        cell.cellWebView.hidden = NO;
        [self setWebVIewData:self.startDic];
    }
    self.yxTableView.tableHeaderView = cell;
    kWeakSelf(self);
    cell.shareblock = ^(YXFirstFindImageTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        UserInfo * userInfo = curUser;
        BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [userInfo.id integerValue];
        shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:cell.tagId startDic:cell.dataDic];
    };
    cell.clickImageBlock = ^(NSInteger tag) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.clickTagblock = ^(NSString * string) {
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
    cell.clickDetailblock = ^(NSInteger tag, YXFirstFindImageTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        if (tag == 1) {
            [weakself setupTextField];
            [weakself.inputToolbar.textInput becomeFirstResponder];
        }else if(tag == 2){
            NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
            [weakself requestDianZan_Image_Action:indexPath1];
        }else{
            UserInfo * userInfo = curUser;
            BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [userInfo.id integerValue];
            shareDic = [NSDictionary dictionaryWithDictionary:self.startDic];
            [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:[weakself.startDic[@"id"] integerValue]  startDic: weakself.startDic];
        }
    };
}
    
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self.startDic[@"obj"] integerValue] == 1 ? self.headerViewHeight : self.headerViewHeight + tagHeight + 200;
}
//- (void)webViewDidFinishLoad:(UIWebView *)wb{
//    tagHeight = [[wb stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    cell.midViewHeight.constant = tagHeight;
//    webViewFinishBOOL = YES;
//    [self.yxTableView reloadData];
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    cell = [[[NSBundle mainBundle]loadNibNamed:@"YXFirstFindImageTableViewCell" owner:self options:nil]lastObject];
    [cell setCellValue:self.startDic];
    //晒图
    if ([self.startDic[@"obj"] integerValue] == 1) {
        [cell setUpSycleScrollView:self.startDic[@"url_list"] height:KScreenWidth - 20];
        cell.rightCountLbl.text = [NSString stringWithFormat:@"%@/%lu",@"1",(unsigned long)[self.startDic[@"url_list"] count]];
        cell.rightCountLbl.hidden = [cell.rightCountLbl.text isEqualToString:@"1/1"] || [cell.rightCountLbl.text isEqualToString:@"1/0"];
        zanBool =  [self.startDic[@"is_praise"] integerValue] == 1;
    }else{

       
    }
   
    kWeakSelf(self);
    cell.shareblock = ^(YXFirstFindImageTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        UserInfo * userInfo = curUser;
        BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [userInfo.id integerValue];
        shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:cell.tagId startDic:cell.dataDic];
    };
    cell.clickImageBlock = ^(NSInteger tag) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.clickTagblock = ^(NSString * string) {
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
    cell.clickDetailblock = ^(NSInteger tag, YXFirstFindImageTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        if (tag == 1) {
            [weakself setupTextField];
            [weakself.inputToolbar.textInput becomeFirstResponder];
        }else if(tag == 2){
            NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
            [weakself requestDianZan_Image_Action:indexPath1];
        }else{
            UserInfo * userInfo = curUser;
            BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [userInfo.id integerValue];
            shareDic = [NSDictionary dictionaryWithDictionary:self.startDic];
            [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:[weakself.startDic[@"id"] integerValue]  startDic: weakself.startDic];
        }
    };
    return cell;
}
    */
#pragma mark ========== 头像点击 ==========
-(void)clickUserImageView:(NSString *)userId{
    UserInfo *userInfo = curUser;
    if ([userInfo.id isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 4;
        return;
    }
    //     UIStoryboard * stroryBoard5 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
    //     YXMineViewController * mineVC = [stroryBoard5 instantiateViewControllerWithIdentifier:@"YXMineViewController"];
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
        [cell.zanBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
        NSInteger zhengfuValue = zanBool ? 1 : -1;
        cell.zanCount.text = NSIntegerToNSString([cell.zanCount.text integerValue] + zhengfuValue);
        if ([cell.zanCount.text isEqualToString:@"0"]) {
            cell.zanCount.text= @"";
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
        //判断评论数组是否添加过新数据，如果添加过就不添加了
        for (NSDictionary * dic in object) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            if ([dic[@"aim_id"] integerValue] != 0) {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName = kGetString(dic[@"user_name"]);
                commentItemModel.secondUserName = kGetString(dic[@"aim_name"]);
                commentItemModel.secondUserId = kGetString(dic[@"aim_id"]);
                commentItemModel.commentString = [kGetString(dic[@"comment"]) UnicodeToUtf8];
                commentItemModel.labelTag = [dic[@"id"] integerValue];

//                self.isReplayingComment = YES;
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
//        [weakself.yxTableView reloadRowsAtIndexPaths:@[weakself.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
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
              model.moreCountPL = [NSString stringWithFormat:@"%ld",[formalArray[i][@"child_number"] integerValue] - [formalArray[i][@"child_list"] count]];
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
        imageVC.startDic = [[NSMutableDictionary alloc]initWithDictionary:startDic];
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
                                              [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatSession obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_QQ") title:@"分享给QQ好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_QQ obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_Qzone obj:shareDic];
                                          }],
                                          ],
                                      itemsArray1
                                      // 第二行
                                      
                                      ];
    [moreOperationController showFromBottom];
    
}

#pragma mark 分享按钮
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title startDic:(NSDictionary *)dic{
    [shareView tappedCancel];
    NSLog(@"当前点击:%@",title);
    kWeakSelf(self);
    if ([title isEqualToString:@"微信"]) {
        [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatSession obj:shareDic];
    }
    if ([title isEqualToString:@"朋友圈"]) {
        [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine obj:shareDic];
    }
    if ([title isEqualToString:@"删除"]) {
        if ([shareView.isWho isEqualToString:@"1"]) {
            [YX_MANAGER requestDel_ShaiTU:NSIntegerToNSString(shareView.tag) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
            }];
        }else if ([shareView.isWho isEqualToString:@"2"]){
            [YX_MANAGER requestDel_WenDa:NSIntegerToNSString(shareView.tag) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
            }];
        }else if ([shareView.isWho isEqualToString:@"3"]){
            [YX_MANAGER requestDel_ZuJi:NSIntegerToNSString(shareView.tag) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
            }];
        }
    }
    if ([title isEqualToString:@"举报"]) {
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
    }
    if([title isEqualToString:@"编辑"]){
        YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
        imageVC.startDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [weakself presentViewController:imageVC animated:YES completion:nil];
    }
}





@end
