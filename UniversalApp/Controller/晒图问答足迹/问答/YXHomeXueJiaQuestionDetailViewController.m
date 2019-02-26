//
//  YXHomeXueJiaQuestionDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/16.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "YXHomeQuestionDetailHeaderView.h"
@interface YXHomeXueJiaQuestionDetailViewController ()<UITextFieldDelegate,SDTimeLineCellDelegate>
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
    [self addRefreshView:self.yxTableView];
    [self requestAnserList];
}
#pragma mark ========== 请求回答列表 ==========
-(void)requestAnserList{
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.moment.startId,NSIntegerToNSString(self.requestPage)];
    //获取回答列表
    kWeakSelf(self);
    [YX_MANAGER requestAnswerListGET:par success:^(id object) {
        if ([object count] != 0) {
            weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
            weakself.dataArray = [NSMutableArray arrayWithArray:[weakself creatModelsWithCount:weakself.dataArray]];
            [weakself refreshTableView];
        }else{
            [weakself.yxTableView.mj_footer endRefreshing];
            [weakself.yxTableView.mj_header endRefreshing];
        }
        
    }];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestAnserList];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestAnserList];
}
-(void)initAllControl{
    [super initAllControl];
    _pardic = [[NSMutableDictionary alloc]init];
    [self setupTextField];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //添加分隔线颜色设置
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeQuestionDetailHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, !AxcAE_IsiPhoneX ? 300 : 220);
    
    self.headerView.titleImageView.layer.masksToBounds = YES;
    self.headerView.titleImageView.layer.cornerRadius = self.headerView.titleImageView.frame.size.width / 2.0;
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [self.headerView.totalImage addSubview:_imageListView];
    self.headerView.twoLblHeight.constant = [ShareManager inTextFieldOutDifColorView:[self.moment.detailText UnicodeToUtf8]] ;
    [ShareManager setLineSpace:9 withText:[self.moment.detailText UnicodeToUtf8] inLabel:self.headerView.twoLbl tag:@""];
    NSString * str = [(NSMutableString *)self.moment.photo replaceAll:@" " target:@"%20"];
    [self.headerView.titleImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.headerView.titleLbl.text = self.moment.userName;
    self.headerView.timeLbl.text = [ShareManager updateTimeForRow:self.moment.time];
    self.headerView.oneLbl.text = [self.moment.text UnicodeToUtf8];
    
    NSString * str0;
    if (self.moment.imageListArray.count >= 1) {
        str0 = [(NSMutableString *)self.moment.imageListArray[0] replaceAll:@" " target:@"%20"];
    }
    NSString * str1;
    if (self.moment.imageListArray.count >= 2) {
        str1 = [(NSMutableString *)self.moment.imageListArray[1] replaceAll:@" " target:@"%20"];
    }
    NSString * str2;
    if (self.moment.imageListArray.count >= 3) {
        str2 = [(NSMutableString *)self.moment.imageListArray[2] replaceAll:@" " target:@"%20"];
    }
    
    NSMutableArray * imvArr = [NSMutableArray array];
    
    if (str0.length > 5) {
        [imvArr addObject:str0];

    }else{

        self.headerView.imvHeight.constant = 100;
    }
    if (str1.length > 5) {
        [imvArr addObject:str1];
    }
    if (str2.length > 5) {
        [imvArr addObject:str2];

    }
    if (str0.length<=0 && str1.length<=0 && str2.length<=0) {
        self.headerView.imvHeight.constant = 0;
    }
    
    Moment * moment = [[Moment alloc]init];
    moment.imageListArray = [NSMutableArray arrayWithArray:imvArr];
    moment.singleWidth = (KScreenWidth-30)/3;
    moment.singleHeight = 100;
    moment.fileCount = imvArr.count;
    _imageListView.moment = moment;
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (self.moment.imageListArray.count >=1) {
        NSString * str0 = [(NSMutableString *)self.moment.imageListArray[0] replaceAll:@" " target:@"%20"];
        if (str0.length > 5) {
            height = 100;
        }
    }
    return  160 - 30 + [ShareManager inTextFieldOutDifColorView:[self.moment.detailText UnicodeToUtf8]] + height;
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
        [self.yxTableView reloadRowsAtIndexPaths:@[self.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
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
        model.praise = kGetString(formalArray[i][@"praise_number"]);
        model.id =  kGetString(formalArray[i][@"id"]);
        model.postid = kGetString(formalArray[i][@"question_id"]);
        [pageDic setValue:@([model.id intValue]) forKey:@"id"];
        [pageDic setValue:@(0) forKey:@"page"];
        [self.pageArray addObject:pageDic];
        
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
    cell.indexPath = indexPath;
    cell.nameLable.textColor = KBlackColor;
    cell.contentLabel.textColor = KDarkGaryColor;
//    cell.commentView.likeStringLabel.hidden = YES;
//    cell.commentView.likeLabel.hidden = YES;
    __weak typeof(self) weakSelf = self;
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
                
//                self.isReplayingComment = YES;
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_name"]);
                commentItemModel.commentString = [kGetString(dic[@"answer"]) UnicodeToUtf8];
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
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel * model = self.dataArray[self.currentEditingIndexthPath.row];
    self.textField.placeholder = [NSString stringWithFormat:@"  回复：%@",model.name];
    self.currentEditingIndexthPath = cell.indexPath;
    [self.textField becomeFirstResponder];
    self.isReplayingComment = YES;
    self.commentToUser = model.name;
    [self adjustTableViewToFitKeyboard];
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
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length) {
        [self.textField resignFirstResponder];
        
        [self.pardic removeAllObjects];
        if (self.isReplayingComment) {
            
            
            SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
            SDTimeLineCellCommentItemModel * itemModel;
            for (SDTimeLineCellCommentItemModel * oldItemModel in model.commentItemsArray) {
                if ([oldItemModel.firstUserName isEqualToString:self.commentToUser]) {
                    itemModel = oldItemModel;
                }
            }
            if (itemModel) {
                if ([itemModel.firstUserName isEqualToString:self.commentToUser]) {
                    itemModel.firstUserId = itemModel.firstUserId;
                    itemModel.firstUserName = itemModel.firstUserName;
                }
                if ([itemModel.secondUserName isEqualToString:self.commentToUser]) {
                    itemModel.firstUserId = itemModel.secondUserId;
                    itemModel.firstUserName = itemModel.firstUserName;
                }
                
            }else{
                itemModel = [[SDTimeLineCellCommentItemModel alloc]init];
                if ([model.name isEqualToString:self.commentToUser]) {
                    itemModel.firstUserId = model.userID;
                    itemModel.firstUserName = model.name;
                }
            }

            
            [self.pardic setValue:model.id forKey:@"answer_id"];
            [self.pardic setValue:[textField.text utf8ToUnicode] forKey:@"answer"];
            [self.pardic setValue:itemModel.firstUserId forKey:@"aim_id"];
            [self.pardic setValue:itemModel.firstUserName  forKey:@"aim_name"];
            
            [self requestFaBuHuiDaChild:self.pardic];
        }else{
            [self.pardic setValue:[textField.text utf8ToUnicode] forKey:@"answer"];
            [self requestFaBuHuiDa:self.pardic];
        }
        
    
        self.textField.text = @"";
        self.textField.placeholder = nil;
        
        return YES;
    }
    return NO;
}
#pragma mark ========== 发布回答 ==========
-(void)requestFaBuHuiDa:(NSMutableDictionary *)dic{
    [dic setValue:self.moment.startId forKey:@"question_id"];
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

@end
