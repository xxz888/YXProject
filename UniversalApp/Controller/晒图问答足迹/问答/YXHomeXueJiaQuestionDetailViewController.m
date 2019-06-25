//
//  YXHomeXueJiaQuestionDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/16.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "YXHomeQuestionDetailHeaderView.h"
#import "HGPersonalCenterViewController.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"
#import "YXFindQuestionTableViewCell.h"
#import "YXFindSearchTagDetailViewController.h"
#import "HXEasyCustomShareView.h"
@interface YXHomeXueJiaQuestionDetailViewController ()<UITextFieldDelegate,SDTimeLineCellDelegate,ZInputToolbarDelegate>{
    YXFindQuestionTableViewCell * cell;
    BOOL zanBool;
    NSDictionary * shareDic;
}
@property(nonatomic)YXHomeQuestionDetailHeaderView * headerView;
@property (nonatomic, strong) NSMutableDictionary * pardic;;
@property (nonatomic, strong) MMImageListView *imageListView;
@end
@implementation YXHomeXueJiaQuestionDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    //初始化所有的控件
    [self initAllControl];
//    [self addRefreshView:self.yxTableView];
    [self requestAnserList];
}
#pragma mark ========== 请求回答列表 ==========
-(void)requestAnserList{
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.startDic[@"id"],NSIntegerToNSString(self.requestPage)];
    //获取回答列表
    kWeakSelf(self);
    [YX_MANAGER requestAnswerListGET:par success:^(id object) {
        if ([object count] != 0) {
       weakself.dataArray = [weakself commonAction:[weakself creatModelsWithCount:object] dataArray:weakself.dataArray]; 
        }else{
            [weakself.yxTableView.mj_footer endRefreshing];
            [weakself.yxTableView.mj_header endRefreshing];
        }
        [weakself refreshTableView];

    }];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestAnserList];
}
-(void)initAllControl{
    [super initAllControl];
    _pardic = [[NSMutableDictionary alloc]init];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    cell = [[[NSBundle mainBundle]loadNibNamed:@"YXFindQuestionTableViewCell" owner:self options:nil]lastObject];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:self.startDic];
    NSString * talkNum = dic[@"comment_number"] ? kGetString(dic[@"comment_number"]) :kGetString(dic[@"answer_number"]);
    NSString * praisNum = kGetString(dic[@"praise_number"]);
    //cell的头图片
    NSString * str11 = [(NSMutableString *)(dic[@"user_photo"] ? dic[@"user_photo"] : dic[@"photo"]) replaceAll:@" " target:@"%20"];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:str11] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    //自己的头图像
    UserInfo *userInfo = curUser;
    NSString * str22 = [(NSMutableString *)userInfo.photo replaceAll:@" " target:@"%20"];
    [cell.addPlImageView sd_setImageWithURL:[NSURL URLWithString:str22] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
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

    kWeakSelf(self);
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",dic[@"question"],dic[@"index"]] UnicodeToUtf8];
    cell.titleTagLbl2.userInteractionEnabled = YES;
    //文本点击回调
    cell.titleTagLbl2.tapBlock = ^(NSString *string) {
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
    NSArray * indexArray = [dic[@"index"] split:@" "];
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
    [cell.titleTagLbl2 setText:titleText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                tapStringArray:modelArray];
    cell.textHeight.constant = [self getLblHeight:dic];
    if (cell.textHeight.constant < 30) {
        [ShareManager setLineSpace:0 withText:[cell.titleTagLbl2.text UnicodeToUtf8] inLabel:cell.titleTagLbl2 tag:dic[@"index"]];
        
    }else{
        [ShareManager setLineSpace:9 withText:[cell.titleTagLbl2.text UnicodeToUtf8] inLabel:cell.titleTagLbl2 tag:dic[@"index"]];
    }
    
    cell.titleTagLbl1.text = [dic[@"title"] UnicodeToUtf8];
    [ShareManager setLineSpace:9 withText:[cell.titleTagLbl1.text UnicodeToUtf8] inLabel:cell.titleTagLbl1 tag:@""];
    cell.questionTitleHeight.constant = [ShareManager inTextOutHeight:cell.titleTagLbl1.text lineSpace:9 fontSize:14];
    
    NSString * str1 = [(NSMutableString *)dic[@"pic1"] replaceAll:@" " target:@"%20"];
    NSString * str2 = [(NSMutableString *)dic[@"pic2"] replaceAll:@" " target:@"%20"];
    NSString * str3 = [(NSMutableString *)dic[@"pic3"] replaceAll:@" " target:@"%20"];
    
    
    if (str1.length <= 0) {
        cell.midImageView1.image = [UIImage imageNamed:@""];
    }else{
        [cell.midImageView1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    if (str2.length <= 0) {
        cell.midImageView2.image = [UIImage imageNamed:@""];
    }else{
        [cell.midImageView2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    if (str3.length <= 0) {
        cell.midImageView3.image = [UIImage imageNamed:@""];
    }else{
        [cell.midImageView3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
    if (str1.length<=5 && str2.length<=5 && str3.length<=5) {
        cell.imvHeight.constant = 0;
    }else{
        cell.imvHeight.constant = 100;
    }

    if ([dic[@"publish_site"] isEqualToString:@""] || !dic[@"publish_site"] ) {
        cell.nameCenter.constant = cell.titleImageView.frame.origin.y;
    }else{
        cell.nameCenter.constant = 0;
    }
    cell.clickImageBlock = ^(NSInteger i) {
        
    };
    cell.plAllHeight.constant = 0;
    cell.addPlViewHeight.constant = 0;
    cell.addPlView.hidden = YES;
    cell.zanblock1 = ^(YXFindQuestionTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZan_WenDa_Action:indexPath1];
    };
    cell.shareQuestionblock = ^(YXFindQuestionTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        UserInfo * userInfo = curUser;
        BOOL isOwn = [self.startDic[@"user_id"] integerValue] == [userInfo.id integerValue];
        shareDic = [NSDictionary dictionaryWithDictionary:self.startDic];
        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"2" tag:[weakself.startDic[@"id"] integerValue]  startDic:weakself.startDic];
    };
    cell.addPlActionblock = ^(YXFindQuestionTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself setupTextField];
        [weakself.inputToolbar.textInput becomeFirstResponder];
    };
    return cell;
}
#pragma mark ========== 问答点赞 ==========
-(void)requestDianZan_WenDa_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.startDic[@"id"]);
    [YX_MANAGER requestPraise_question:track_id success:^(id object) {
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
    return _headerViewHeight;
}
-(CGSize)cellAutoHeight:(NSString *)string {
    //展开后得高度(计算出文本内容的高度+固定控件的高度)
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [string boundingRectWithSize:CGSizeMake(KScreenWidth- 20, 100000) options:option attributes:attribute context:nil].size;
    return size;
}
#pragma mark ========== 获取晒图评论列表 ==========
-(void)refreshTableView{
    [self.yxTableView reloadData];
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
                
                //                self.isReplayingComment = YES;
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_name"]);
                commentItemModel.commentString = [kGetString(dic[@"comment"]) UnicodeToUtf8];
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
        [weakself.yxTableView reloadRowsAtIndexPaths:@[weakself.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark ========== tableview数据 ==========
- (NSArray *)creatModelsWithCount:(NSArray *)formalArray{
    [self.pageArray removeAllObjects];
    
    NSMutableArray *resArr = [NSMutableArray new];
    for (int i = 0; i < formalArray.count; i++) {
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        NSMutableDictionary * pageDic = [[NSMutableDictionary alloc]init];
        model.iconName = formalArray[i][@"user_photo"];
        model.name = formalArray[i][@"user_name"];
        model.userID =formalArray[i][@"user_id"];
        model.msgContent = [formalArray[i][@"answer"] UnicodeToUtf8] ;
        model.commontTime = [formalArray[i][@"publish_date"] integerValue];
        model.praise = kGetString(formalArray[i][@"is_praise"]);
        model.praise_num = kGetString(formalArray[i][@"praise_number"]);
        model.id =  kGetString(formalArray[i][@"id"]);
        model.postid = kGetString(formalArray[i][@"question_id"]);
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
        NSArray * child_listArray =  [NSArray arrayWithArray:formalArray[i][@"child"]];
        for (int i = 0; i < [child_listArray count]; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            commentItemModel.firstUserName = kGetString(child_listArray[i][@"user_name"]);
            commentItemModel.firstUserId = kGetString(child_listArray[i][@"user_id"]);
            if (child_listArray[i][@"aim_id"] != 0) {
                commentItemModel.secondUserName = kGetString(child_listArray[i][@"aim_name"]);
                commentItemModel.secondUserId = kGetString(child_listArray[i][@"aim_id"]);
            }
            commentItemModel.commentString = [child_listArray[i][@"answer"] UnicodeToUtf8];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    if (indexPath.row == 0) {
        cell.bottomLine.hidden = YES;
    }
    cell.indexPath = indexPath;
    cell.nameLable.textColor = KBlackColor;
    cell.contentLabel.textColor = KDarkGaryColor;
    cell.commentView.likeStringLabel.hidden = YES;
    cell.commentView.likeLabel.hidden = YES;
    __weak typeof(self) weakSelf = self;
    cell.imgBlock = ^(SDTimeLineCell * cell) {
        UserInfo *userInfo = curUser;
        NSString * cellUserId = kGetString(cell.model.userID);
        if ([userInfo.id isEqualToString:cellUserId]) {
            weakSelf.navigationController.tabBarController.selectedIndex = 4;
            return;
        }
        HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
        mineVC.userId = cellUserId;
        mineVC.whereCome = YES;    //  YES为其他人 NO为自己
        [weakSelf.navigationController pushViewController:mineVC animated:YES];
    };
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.yxTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell * cell) {
            weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentId];
            weakSelf.currentEditingIndexthPath = cell.indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            
        }];
        [cell setDidLongClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell *cell,NSInteger tag) {
            //在此添加你想要完成的功能
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {

                [weakSelf delePingLun:tag];
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController showWithAnimated:YES];
        }];
        cell.delegate = self;
    }
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    
    cell.starView.hidden = YES;
    return cell;
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
                [weakself requestAnserChildList:model.id page:kGetString(dic[@"page"])];
            });
        }
    }
}
#pragma mark ========== 请求子回答列表 ==========
-(void)requestAnserChildList:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",farther_id,page];
    [YX_MANAGER requestAnswer_childListGET:string success:^(id object) {
        
        if ([object count] == 0) {
            [QMUITips showInfo:@"没有更多评论了" detailText:@"" inView:weakself.yxTableView hideAfterDelay:1];
            return ;
        }
        SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
//        [temp addObjectsFromArray:model.commentItemsArray];
        //判断评论数组是否添加过新数据，如果添加过就不添加了
        
        for (NSDictionary * dic in object) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            if ([dic[@"aim_id"] integerValue] != 0) {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName = kGetString(dic[@"user_name"]);
                commentItemModel.secondUserName = kGetString(dic[@"aim_name"]);
                commentItemModel.secondUserId = kGetString(dic[@"aim_id"]);
                commentItemModel.commentString = [kGetString(dic[@"answer"]) UnicodeToUtf8];
                commentItemModel.labelTag = [dic[@"id"] integerValue];

//                self.isReplayingComment = YES;
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_name"]);
                commentItemModel.commentString = [kGetString(dic[@"answer"]) UnicodeToUtf8];
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
        [self.yxTableView reloadRowsAtIndexPaths:@[self.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark ========== tableview 点击评论按钮 ==========
- (void)didClickcCommentButtonInCell:(SDTimeLineCell *)cell{
    [self setupTextField];

    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel * model = self.dataArray[self.currentEditingIndexthPath.row];
    self.inputToolbar.placeholderLabel.text = [NSString stringWithFormat:@"  回复：%@",model.name];
    self.currentEditingIndexthPath = cell.indexPath;
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
    [YX_MANAGER requestPraise_answer:model.id success:^(id object) {
        self.currentEditingIndexthPath = index;
        [weakself requestAnserList];
    }];
}

#pragma mark ========== 发布回答 ==========
-(void)requestFaBuHuiDa:(NSMutableDictionary *)dic{
    [dic setValue:kGetString(self.startDic[@"id"]) forKey:@"question_id"];
    if (!dic[@"question_id"]) {
        [QMUITips showError:@"问题不存在,请返回重新进入" inView:self.yxTableView hideAfterDelay:1];
        return;
    }else if (!dic[@"answer"] || [dic[@"answer"] length] < 0){
        [QMUITips showError:@"请输入回答" inView:self.yxTableView hideAfterDelay:1];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestFaBuHuiDaPOST:dic success:^(id object) {
        [weakself requestAnserList];
    }];
}
#pragma mark ========== 发布子回答 ==========
-(void)requestFaBuHuiDaChild:(NSMutableDictionary *)dic{
    if (!dic[@"answer_id"]) {
        [QMUITips showError:@"问题不存在,请返回重新进入" inView:self.yxTableView hideAfterDelay:1];
        return;
    }else if (!dic[@"answer"] || [dic[@"answer"] length] < 0){
        [QMUITips showError:@"请输入回答" inView:self.yxTableView hideAfterDelay:1];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestFaBuHuiDa_childPOST:dic success:^(id object) {
        [weakself requestAnserList];
    }];
}
-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/0/%@/%@",type,self.startDic[@"id"],page];
}
-(void)delePingLun:(NSInteger)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelChildPl_WenDa:NSIntegerToNSString(tag) success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        [weakself requestAnserList];
    }];
}
-(void)deleFather_PingLun:(NSString *)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelFatherPl_WenDa:tag success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        [weakself requestAnserList];
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
    [self.pardic removeAllObjects];
    if (self.isReplayingComment) {
        
        
        SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
        
        [self.pardic setValue:model.id forKey:@"answer_id"];
        [self.pardic setValue:[textField.text utf8ToUnicode] forKey:@"answer"];
        [self.pardic setValue:self.commentToUserID forKey:@"aim_id"];
        [self.pardic setValue:self.commentToUser  forKey:@"aim_name"];
        
        [self requestFaBuHuiDaChild:self.pardic];
    }else{
        [self.pardic setValue:[textField.text utf8ToUnicode] forKey:@"answer"];
        [self requestFaBuHuiDa:self.pardic];
    }
}

-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",dic[@"question"],dic[@"index"]];
    return [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
}

#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareViewIsOwn:(BOOL)isOwn isWho:(NSString *)isWho tag:(NSInteger)tagId startDic:(NSDictionary *)startDic{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    kWeakSelf(self);
    // 如果你的 item 是确定的，则可以直接通过 items 属性来显示，如果 item 需要经过一些判断才能确定下来，请看第二个示例
    NSMutableArray * itemsArray1 = [[NSMutableArray alloc]init];
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_remove") title:@"删除" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
        [YX_MANAGER requestDel_WenDa:kGetString(self.startDic[@"id"]) success:^(id object) {
            [QMUITips showSucceed:@"删除成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
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
                                              [[ShareManager sharedShareManager] shareWebPageZhiNanDetailToPlatformType:UMSocialPlatformType_WechatSession obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareWebPageZhiNanDetailToPlatformType:UMSocialPlatformType_WechatTimeLine obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_QQ") title:@"分享给QQ好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareWebPageZhiNanDetailToPlatformType:UMSocialPlatformType_QQ obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareWebPageZhiNanDetailToPlatformType:UMSocialPlatformType_Qzone obj:shareDic];
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
        [[ShareManager sharedShareManager] shareWebPageZhiNanDetailToPlatformType:UMSocialPlatformType_WechatSession obj:shareDic];
    }
    if ([title isEqualToString:@"朋友圈"]) {
        [[ShareManager sharedShareManager] shareWebPageZhiNanDetailToPlatformType:UMSocialPlatformType_WechatTimeLine obj:shareDic];
    }
    if ([title isEqualToString:@"删除"]) {
            [YX_MANAGER requestDel_WenDa:kGetString(self.startDic[@"id"]) success:^(id object) {
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
}
@end
