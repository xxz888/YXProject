//
//  YXMineFootDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFootDetailViewController.h"
#import "XHWebImageAutoSize.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"
#import "YXPublishImageViewController.h"
#import "HXEasyCustomShareView.h"
#import "YXFindImageTableViewCell.h"
#import "YXFindSearchTagDetailViewController.h"

@interface YXMineFootDetailViewController ()<SDCycleScrollViewDelegate,ZInputToolbarDelegate>{
    CGFloat imageHeight;
    NSDictionary * shareDic;
    YXFindImageTableViewCell * cell;
    BOOL zanBool;
}

@end
@implementation YXMineFootDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if ([self.startDic[@"pic1"] length] >= 5) {
        NSString * str1 = [(NSMutableString *)self.startDic[@"pic1"] replaceAll:@" " target:@"%20"];

        imageHeight   = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:str1] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
    }
    //初始化所有的控件
    [self initAllControl];
//    [self addRefreshView:self.yxTableView];
    [self requestNewList];
}
-(void)initAllControl{
    kWeakSelf(self);
    [super initAllControl];
    //点击segment
    self.lastDetailView.block = ^(NSInteger index) {
        index == 0 ? [weakself requestNewList] : [weakself requestHotList];
        weakself.segmentIndex = index;
    };}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    cell = [[[NSBundle mainBundle]loadNibNamed:@"YXFindImageTableViewCell" owner:self options:nil]lastObject];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:self.startDic];
    NSString * talkNum = dic[@"comment_number"] ? kGetString(dic[@"comment_number"]) :kGetString(dic[@"answer_number"]);
    NSString * praisNum = kGetString(dic[@"praise_number"]);
    //cell的头图片
    NSString * str1 = [(NSMutableString *)(dic[@"user_photo"] ? dic[@"user_photo"] : dic[@"photo"]) replaceAll:@" " target:@"%20"];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //自己的头图像
    UserInfo *userInfo = curUser;
    NSString * str2 = [(NSMutableString *)userInfo.photo replaceAll:@" " target:@"%20"];
//    [cell.addPlImageView sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    //评论数量
    cell.talkCount.text = talkNum;
    cell.zanCount.text = praisNum;
    //头名字
    cell.titleLbl.text = dic[@"user_name"];
    //头时间
    cell.timeLbl.text = [ShareManager updateTimeForRow:[dic[@"publish_time"] longLongValue]];
    //地点button
    [cell.mapBtn setTitle:dic[@"publish_site"] forState:UIControlStateNormal];
    //赞
    BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
    zanBool = isp;
    UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
    [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
    
    if ([talkNum isEqualToString:@"0"] || [talkNum isEqualToString:@"(null)"]) {
        cell.talkCount.text = @"";
    }
    if ([praisNum isEqualToString:@"0"] || [praisNum isEqualToString:@"(null)"]) {
        cell.zanCount.text = @"";
    }
    NSMutableArray * imgArray =  [NSMutableArray array];
    if ([dic[@"pic1"] length] > 5) {
        [imgArray addObject:dic[@"pic1"]];
    }
    if ([dic[@"pic2"] length] > 5) {
        [imgArray addObject:dic[@"pic2"]];
    }
    if ([dic[@"pic3"] length] > 5) {
        [imgArray addObject:dic[@"pic3"]];
    }
    if (imgArray.count > 0) {
        [cell setUpSycleScrollView:imgArray height:[self getImvHeight:dic whereCome:NO]];
        cell.cycleScrollView3.hidden = NO;
    }else{
        cell.cycleScrollView3.hidden = YES;
    }
    cell.rightCountLbl.text = [NSString stringWithFormat:@"%@/%ld",@"1",imgArray.count];
    cell.rightCountLbl.hidden = [cell.rightCountLbl.text isEqualToString:@"1/1"] ||
    [cell.rightCountLbl.text isEqualToString:@"1/0"];

//    cell.titleTagtextViewHeight.constant = 30;
//    NSString * zuji = [NSString stringWithFormat:@"来自足迹·%@ %@",dic[@"cigar_info"][@"brand_name"],dic[@"cigar_info"][@"cigar_name"]];
//    cell.titleTagtextView.text = zuji;
    //图片高度
    cell.imvHeight.constant = [self getImvHeight:dic whereCome:NO];
    //title
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",dic[@"content"],dic[@"tag"]] UnicodeToUtf8];
    cell.titleTagLbl.text = titleText;
    //
    cell.plAllHeight.constant = 0;
    cell.addPlViewHeight.constant = 0;
    cell.addPlView.hidden = YES;
    NSArray * indexArray = [dic[@"tag"] split:@" "];
    NSMutableArray * modelArray = [NSMutableArray array];
    for (NSString * string in indexArray) {
        //设置需要点击的字符串，并配置此字符串的样式及位置
        IXAttributeModel    * model = [IXAttributeModel new];
        model.range = [titleText rangeOfString:string];
        model.string = string;
        model.attributeDic = @{NSForegroundColorAttributeName : [UIColor blueColor]};
        [modelArray addObject:model];
    }
    //label内容赋值
    [cell.titleTagLbl setText:titleText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
               tapStringArray:modelArray];
    cell.titleTagLblHeight.constant = [self getTitleTagLblHeight:dic whereCome:NO];

    if ([dic[@"publish_site"] isEqualToString:@""] || !dic[@"publish_site"] ) {
        cell.nameCenter.constant = cell.titleImageView.frame.origin.y;
    }else{
        cell.nameCenter.constant = 0;
    }
    kWeakSelf(self)
    
    cell.clickImageBlock = ^(NSInteger i) {
        
    };
    //文本点击回调
    cell.titleTagLbl.tapBlock = ^(NSString *string) {
        kWeakSelf(self);
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
    cell.addPlActionblock = ^(YXFindImageTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself setupTextField];
        [weakself.inputToolbar.textInput becomeFirstResponder];
    };
    cell.zanblock = ^(YXFindImageTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        
        [weakself requestDianZan_ZuJI_Action:indexPath1];
    };
    
    cell.shareblock = ^(YXFindImageTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        UserInfo * userInfo = curUser;
        BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [userInfo.id integerValue];
        shareDic = [NSDictionary dictionaryWithDictionary:self.startDic];
        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:cell.whereCome ? @"3" : @"1" tag:[weakself.startDic[@"id"] integerValue] startDic: nil];
    };
    return cell;
}
-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",dic[@"content"] ? dic[@"content"]:dic[@"describe"],dic[@"tag"]];
    CGFloat height_size = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
    return height_size;
}
#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.startDic[@"id"]);
    [YX_MANAGER requestDianZanFoot:@{@"track_id":track_id} success:^(id object) {
        //赞
        zanBool = !zanBool;
        UIImage * likeImage = zanBool ? ZAN_IMG : UNZAN_IMG;
        [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];
        
        NSInteger zhengfuValue = zanBool ? 1 : -1;
        cell.zanCount.text = NSIntegerToNSString([cell.zanCount.text integerValue] + zhengfuValue);
        
        if ([cell.zanCount.text isEqualToString:@"0"]) {
            cell.zanCount.text= @"";
        }
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  self.headerViewHeight;
}
-(void)headerRereshing{
    [super headerRereshing];
    self.segmentIndex == 0 ? [self requestNewList] : [self requestHotList];
}
-(void)footerRereshing{
    [super footerRereshing];
    self.segmentIndex == 0 ? [self requestNewList] : [self requestHotList];
}
#pragma mark ========== 获取足迹评论列表 ==========
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    [YX_MANAGER requestGetNewFootList:[self getParamters:@"1" page:NSIntegerToNSString(self.requestPage)] success:^(id object) {
        
        if ([object count] > 0) {
          weakself.dataArray = [weakself commonAction:[weakself creatModelsWithCount:object] dataArray:weakself.dataArray];
        }else{
            [weakself.yxTableView.mj_header endRefreshing];
            [weakself.yxTableView.mj_footer endRefreshing];
        }
        [weakself refreshTableView];

    }];
}
-(void)requestHotList{
    kWeakSelf(self);
    //请求评价列表 最热评论列表
    [YX_MANAGER requestGetHotFootList:[self getParamters:@"2" page:NSIntegerToNSString(self.requestPage)] success:^(id object) {
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
//    if (self.currentEditingIndexthPath) {
//        [self.yxTableView reloadRowsAtIndexPaths:@[self.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
//    }else{
        [self.yxTableView reloadData];
//    }
}
#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestFaBuFoot_child_PingLun:dic success:^(id object) {
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
#pragma mark ========== 更多评论 ==========
-(void)requestMoreCigar_comment_child:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",farther_id,page];
    [YX_MANAGER requestGetFootPingLun_Child_List:string success:^(id object) {
        if ([object count] == 0) {
            [QMUITips showInfo:@"没有更多评论了" detailText:@"" inView:weakself.yxTableView hideAfterDelay:1];
            return ;
        }
        SDTimeLineCellModel *model = weakself.dataArray[weakself.currentEditingIndexthPath.row];
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

//
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
        [weakself.yxTableView reloadRowsAtIndexPaths:@[self.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
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
        model.msgContent = [formalArray[i][@"comment"] UnicodeToUtf8];
        model.commontTime = [formalArray[i][@"update_time"] integerValue];
        model.praise = kGetString(formalArray[i][@"is_praise"]);
        model.praise_num = kGetString(formalArray[i][@"praise_number"]);
        model.id =  kGetString(formalArray[i][@"id"]);
        model.postid = kGetString(formalArray[i][@"track_id"]);
        [pageDic setValue:@([model.id intValue]) forKey:@"id"];
        [pageDic setValue:@(0) forKey:@"page"];
        [self.pageArray addObject:pageDic];
        if ([formalArray[i][@"child_list"] count] == 0) {
            model.moreCountPL = @"0";
        }else{
            model.moreCountPL = [NSString stringWithFormat:@"%ld",[formalArray[i][@"child_number"] integerValue] - [formalArray[i][@"child_list"] count]];
        }
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
            commentItemModel.labelTag = [child_listArray[i][@"id"] integerValue];
            commentItemModel.commentString = [child_listArray[i][@"comment"] UnicodeToUtf8];
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
            [self requestMoreCigar_comment_child:model.id page:kGetString(dic[@"page"])];
        }
    }
}
#pragma mark ========== tableview 点击评论按钮 ==========
- (void)didClickcCommentButtonInCell:(SDTimeLineCell *)cell{
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel * model = self.dataArray[self.currentEditingIndexthPath.row];
    self.inputToolbar.placeholderLabel.text = [NSString stringWithFormat:@"  回复：%@",model.name];
    self.currentEditingIndexthPath = cell.indexPath;
    [self setupTextField];
    [self.inputToolbar.textInput becomeFirstResponder];
    self.isReplayingComment = YES;
    self.commentToUser = model.name;
    self.commentToUserID = model.userID;
//    [self adjustTableViewToFitKeyboard];
}
#pragma mark ========== tableview 点赞按钮 ==========
- (void)didClickLikeButtonInCell:(SDTimeLineCell *)cell{
    kWeakSelf(self);
    NSIndexPath *index = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    [YX_MANAGER requestDianZanFoot_PingLun:@{@"comment_id":@([model.id intValue])} success:^(id object) {
        weakself.currentEditingIndexthPath = index;
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
- (IBAction)clickPingLunAction:(id)sender {
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
                                          }];
        self.isReplayingComment = NO;
    }else{
        [self pinglunFatherPic:@{@"comment":[textField.text utf8ToUnicode],
                                 @"track_id":@([self.startDic[@"id"] intValue]),
                                 }];
        
    }
}









#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length) {
        [self.textField resignFirstResponder];
      
        self.textField.text = @"";
        self.textField.placeholder = nil;
        
        return YES;
    }
    return NO;
}
#pragma mark ========== 评论足迹 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPingLunFoot:dic success:^(id object) {
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}

-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/%@",self.startDic[@"id"],page];
}
-(void)delePingLun:(NSInteger)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelChildPl_Zuji:NSIntegerToNSString(tag) success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
-(void)deleFather_PingLun:(NSString *)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelFatherPl_Zuji:tag success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}


#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareViewIsOwn:(BOOL)isOwn isWho:(NSString *)isWho tag:(NSInteger)tagId startDic:(NSDictionary *)startDic{
    NSMutableArray * shareAry = [NSMutableArray arrayWithObjects:
                                 @{@"image":@"raiders_weichat",
                                   @"title":@"微信"},
                                 @{@"image":@"shareView_friend",
                                   @"title":@"朋友圈"},
                                 @{@"image":@"回收",
                                   @"title":@"删除"},
                                 @{@"image":@"举报",
                                   @"title":@"举报"},nil];
    if (isOwn) {
        [shareAry removeObjectAtIndex:3];
        
    }else{
        [shareAry removeObjectAtIndex:2];
        
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 54)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    HXEasyCustomShareView *shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    shareView.startDic = [NSDictionary dictionaryWithDictionary:startDic];
    shareView.tag = tagId;
    shareView.isWho = isWho;
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:shareAry firstCount:isOwn ? shareAry.count-1 : shareAry.count+1];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.middleLineLabel.hidden = NO;
    [shareView.cancleButton addSubview:lineLabel1];
    shareView.cancleButton.frame = CGRectMake(shareView.cancleButton.frame.origin.x, shareView.cancleButton.frame.origin.y, shareView.cancleButton.frame.size.width, 54);
    shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [shareView setShareAry:shareAry delegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
}
#pragma mark 分享按钮
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title startDic:(NSDictionary *)dic{
    [shareView tappedCancel];
    NSLog(@"当前点击:%@",title);
    kWeakSelf(self);
    if ([title isEqualToString:@"微信"]) {
        [[ShareManager sharedShareManager] shareAllToPlatformType:UMSocialPlatformType_WechatSession obj:shareDic];
    }
    if ([title isEqualToString:@"朋友圈"]) {
        [[ShareManager sharedShareManager] shareAllToPlatformType:UMSocialPlatformType_WechatTimeLine obj:shareDic];
    }
    if ([title isEqualToString:@"删除"]) {
            [YX_MANAGER requestDel_ZuJi:NSIntegerToNSString(shareView.tag) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
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
-(CGFloat)getImvHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * url =  whereCome ? dic[@"pic1"]:dic[@"pic1"];
    if (url.length < 5) {
        return 0;
    }
    return    [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
}
-(CGFloat)getTitleTagLblHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"tag"]];
    return [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
}

@end
